*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    RequestsLibrary

*** Variables ***
${URL}    https://www.tripadvisor.com/Attractions-g298357-Activities-Swakopmund_Erongo_Region.html
${BROWSER}    Chrome
${OPENAI_API_KEY}    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
${OPENAI_API_URL}    https://api.openai.com/v1/chat/completions
${MODEL}    gpt-3.5-turbo

*** Test Cases ***
Open Swakopmund Attractions Page
    [Documentation]    Open TripAdvisor Swakopmund attractions page and take a screenshot.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    3s
    Capture Page Screenshot    swakopmund_attractions.png
    [Teardown]    Close Browser

Extract And Rank Attractions
    [Documentation]    Extracts tourist attractions, their review counts, and ratings, then logs them for ranking.
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    3s
    ${attractions}=    Get WebElements    //div[contains(@class,'attraction_element') or contains(@class,'listing_title')]/ancestor::div[contains(@class,'listing')] | //div[contains(@data-automation,'attraction-card')] 
    FOR    ${el}    IN    @{attractions}
        ${name}=    Get Text    xpath=.//div[contains(@class,'listing_title')]//a | .//a[contains(@data-automation,'attraction-title')]
        ${reviews}=    Get Text    xpath=.//span[contains(@class,'reviewCount')] | .//span[contains(@data-automation,'review-count')]
        ${rating}=    Get Element Attribute    xpath=.//span[contains(@class,'ui_bubble_rating') or contains(@aria-label,'bubble rating')]    aria-label
        Log    Attraction: ${name} | Reviews: ${reviews} | Rating: ${rating}
    END
    [Teardown]    Close Browser

Extract From Google Maps
    [Documentation]    Extracts tourist attractions, their ratings, and review counts from Google Maps.
    ${GOOGLE_URL}=    Set Variable    https://www.google.com/maps/search/Swakopmund+attractions
    Open Browser    ${GOOGLE_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    # Accept cookies if prompted (Google sometimes shows a consent dialog)
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Accept all') or contains(text(),'I agree')]]
    Sleep    2s
    # Wait for the results panel to be visible
    Wait Until Element Is Visible    xpath=//div[contains(@role,'main')]
    Capture Page Screenshot    googlemaps_before_extraction.png
    # Get all result cards in the left panel (try to match links to places)
    ${places}=    Get WebElements    //a[contains(@href,'/maps/place/') and @tabindex='0']
    Log    Found places: ${places}
    FOR    ${el}    IN    @{places}
        ${name}=    Get Text    xpath=.//h1[contains(@class,'DUwDvf')]
        ${rating}=    Get Text    xpath=.//span[contains(@aria-label,'tähteä')]
        ${reviews}=    Get Text    xpath=.//span[contains(@aria-label,'arvostelua')]
        Log    GoogleMaps: ${name} | Reviews: ${reviews} | Rating: ${rating}
    END
    [Teardown]    Close Browser

Extract Swakopmund Museum From Google Maps
    [Documentation]    Extracts the name, rating, and review count for Swakopmund Museum from its Google Maps page (Finnish UI).
    ${MUSEUM_URL}=    Set Variable    https://www.google.fi/maps/place/Swakopmund+Museum/@-22.6756226,14.5230034,17z/data=!3m1!4b1!4m6!3m5!1s0x1c7658f9c01bdb93:0x2df2ed521c4360ec!8m2!3d-22.6756226!4d14.5230034!16s%2Fg%2F1222z81j?authuser=0&hl=fi&entry=ttu&g_ep=EgoyMDI1MDUxMy4xIKXMDSoASAFQAw%3D%3D
    Open Browser    ${MUSEUM_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    # Accept cookies if prompted
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    Capture Page Screenshot    museum_maps.png
    # Extract name, rating, and reviews using Finnish selectors
    ${name}=    Get Text    xpath=//h1[contains(@class,'DUwDvf')]
    ${rating}=    Get Text    xpath=//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]/div/div[1]/div[2]/div/div[1]/div[2]/span[1]/span[1]
    ${reviews}=    Get Text    xpath=//span[contains(@aria-label,'arvostelua')]
    Log    Museum: ${name} | Reviews: ${reviews} | Rating: ${rating}
    [Teardown]    Close Browser

Extract Platz Am Meer From Google Maps
    [Documentation]    Extracts the name, rating, and review count for Platz Am Meer Waterfront from its Google Maps page (Finnish UI).
    ${PLATZ_URL}=    Set Variable    https://www.google.fi/maps/place/Platz+Am+Meer+Waterfront/@-22.6453386,14.5250487,17z/data=!3m1!4b1!4m6!3m5!1s0x1c76590c5a81ae6b:0x3196ac88d1f478b5!8m2!3d-22.6453386!4d14.5276236!16s%2Fg%2F11cn9m34j_?entry=ttu&g_ep=EgoyMDI1MDUxMy4xIKXMDSoASAFQAw%3D%3D
    Open Browser    ${PLATZ_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    # Accept cookies if prompted
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    Capture Page Screenshot    platz_maps.png
    # Extract name, rating, and reviews using Finnish selectors
    ${name}=    Get Text    xpath=//h1[contains(@class,'DUwDvf')]
    ${rating}=    Get Text    xpath=//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]/div/div[1]/div[2]/div/div[1]/div[2]/span[1]/span[1]
    ${reviews}=    Get Text    xpath=//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]/div/div[1]/div[2]/div/div[1]/div[2]/span[2]/span/span
    Log    PlatzAmMeer: ${name} | Reviews: ${reviews} | Rating: ${rating}
    [Teardown]    Close Browser

Extract Swakopmund Museum Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Swakopmund Museum from Google Maps by scrolling the reviews section and saving them to a file.
    ${MUSEUM_URL}=    Set Variable    https://www.google.fi/maps/place/Swakopmund+Museum/@-22.6756226,14.5230034,17z/data=!4m8!3m7!1s0x1c7658f9c01bdb93:0x2df2ed521c4360ec!8m2!3d-22.6756226!4d14.5230034!9m1!1b1!16s%2Fg%2F1222z81j?entry=ttu&g_ep=EgoyMDI1MDUxMy4xIKXMDSoASAFQAw%3D%3D
    Open Browser    ${MUSEUM_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    # Accept cookies if prompted
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    # Scroll to reviews section
    Execute JavaScript    window.scrollBy(0, 800)
    Sleep    2s
    # Click 'More reviews' if available
    Run Keyword And Ignore Error    Click Element    xpath=//button[contains(@aria-label,'Lisää arvosteluja') or contains(text(),'Lisää arvosteluja') or contains(text(),'More reviews')]
    Sleep    2s
    # Classic FOR loop to scroll the reviews panel more times and with a larger scroll amount
    FOR    ${INDEX}    IN RANGE    30
        Execute JavaScript    var el = document.evaluate('//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if (el) { el.scrollBy(0, 2000); }
        Sleep    1s
    END
    # Get all visible review text spans
    ${review_elements}=    Get WebElements    xpath=//span[contains(@class,'wiI7pd')]
    ${reviews}=    Create List
    FOR    ${el}    IN    @{review_elements}
        ${review}=    Get Text    ${el}
        ${reviews}=    Create List    @{reviews}    ${review}
    END
    Log    Extracted reviews: ${reviews}
    ${file}=    Set Variable    museum_reviews.txt
    Run Keyword And Ignore Error    Remove File    ${file}
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    Capture Page Screenshot    museum_reviews.png
    [Teardown]    Close Browser

Summarize Museum Reviews Test
    [Documentation]    Calls the AI summary keyword and logs the result.
    Summarize Museum Reviews With AI    museum_reviews.txt

*** Keywords ***
Summarize Museum Reviews With AI
    [Arguments]    ${review_file}
    ${reviews}=    Get File    ${review_file}
    ${prompt}=    Catenate    SEPARATOR=\n    Analyze the following museum reviews and summarize the main good and bad points as bullet points. Separate the good and bad points clearly.\nReviews:\n${reviews}\nSummary:\nGood:\n-
    ${headers}=    Create Dictionary    Authorization=Bearer ${OPENAI_API_KEY}    Content-Type=application/json
    ${message}=    Create Dictionary    role=user    content=${prompt}
    ${messages}=    Create List    ${message}
    ${body}=    Create Dictionary    model=${MODEL}    messages=${messages}
    Create Session    openai    https://api.openai.com
    ${response}=    POST On Session    openai    /v1/chat/completions    headers=${headers}    json=${body}
    ${result}=    Set Variable    ${response.json()['choices'][0]['message']['content']}
    Log    ${result}
