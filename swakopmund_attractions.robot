*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    RequestsLibrary
Library    Process

*** Variables ***
${URL}    https://www.tripadvisor.com/Attractions-g298357-Activities-Swakopmund_Erongo_Region.html
${BROWSER}    Chrome
${OPENAI_API_KEY}    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
${OPENAI_API_URL}    https://api.openai.com/v1/chat/completions
${MODEL}    gpt-3.5-turbo
${GEMINI_API_KEY}    AIzaSyCbTIxJeF4OH-iu5XAL9w5KH9m4isteco8

*** Test Cases ***
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

Extract Swakopmund Genocide Museum Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Swakopmund Genocide Museum from Google Maps by scrolling the reviews section and saving them to a file.
    ${GENOCIDE_URL}=    Set Variable    https://www.google.fi/maps/place/Swakopmund+Genocide+Museum/@-22.6375583,14.5585919,17z/data=!4m8!3m7!1s0x1c76590e2339157d:0x89d63bc2e62b1f67!8m2!3d-22.6375584!4d14.5634628!9m1!1b1!16s%2Fg%2F11kjlvp94z?entry=ttu&g_ep=EgoyMDI1MDUxNS4wIKXMDSoASAFQAw%3D%3D
    Open Browser    ${GENOCIDE_URL}    ${BROWSER}
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
    FOR    ${INDEX}    IN RANGE    30
        Execute JavaScript    var el = document.evaluate('//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if (el) { el.scrollBy(0, 2000); }
        Sleep    1s
    END
    ${review_elements}=    Get WebElements    xpath=//span[contains(@class,'wiI7pd')]
    ${reviews}=    Create List
    FOR    ${el}    IN    @{review_elements}
        ${review}=    Get Text    ${el}
        ${reviews}=    Create List    @{reviews}    ${review}
    END
    Log    Extracted reviews: ${reviews}
    ${file}=    Set Variable    genocide_museum_reviews.txt
    Run Keyword And Ignore Error    Remove File    ${file}
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    Capture Page Screenshot    genocide_museum_reviews.png
    [Teardown]    Close Browser

Extract Platz Am Meer Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Platz Am Meer Waterfront from Google Maps by scrolling the reviews section and saving them to a file.
    ${PLATZ_URL}=    Set Variable    https://www.google.fi/maps/place/Platz+Am+Meer+Waterfront/@-22.6453385,14.5227527,17z/data=!4m8!3m7!1s0x1c76590c5a81ae6b:0x3196ac88d1f478b5!8m2!3d-22.6453386!4d14.5276236!9m1!1b1!16s%2Fg%2F11cn9m34j_?entry=ttu&g_ep=EgoyMDI1MDUxNS4wIKXMDSoASAFQAw%3D%3D
    Open Browser    ${PLATZ_URL}    ${BROWSER}
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
    FOR    ${INDEX}    IN RANGE    30
        Execute JavaScript    var el = document.evaluate('//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if (el) { el.scrollBy(0, 2000); }
        Sleep    1s
    END
    ${review_elements}=    Get WebElements    xpath=//span[contains(@class,'wiI7pd')]
    ${reviews}=    Create List
    FOR    ${el}    IN    @{review_elements}
        ${review}=    Get Text    ${el}
        ${reviews}=    Create List    @{reviews}    ${review}
    END
    Log    Extracted reviews: ${reviews}
    ${file}=    Set Variable    platz_am_meer_reviews.txt
    Run Keyword And Ignore Error    Remove File    ${file}
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    Capture Page Screenshot    platz_am_meer_reviews.png
    [Teardown]    Close Browser

Summarize Museum Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result.
    ${output}=    Run Process    python    summarize_reviews_with_file.py    museum_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.

Summarize Genocide Museum Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result for the genocide museum.
    ${output}=    Run Process    python    summarize_reviews_with_file.py    genocide_museum_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.

Summarize Platz Am Meer Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result for Platz Am Meer Waterfront.
    ${output}=    Run Process    python    summarize_reviews_with_file.py    platz_am_meer_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.
