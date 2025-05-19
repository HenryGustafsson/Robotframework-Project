*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    BuiltIn
Library    Collections
Library    RequestsLibrary
Library    Process

*** Variables ***
${BROWSER}    Chrome

*** Test Cases ***
# Test case: Extract reviews for Swakopmund Museum from Google Maps
Extract Swakopmund Museum Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Swakopmund Museum from Google Maps by scrolling the reviews section and saving them to a file.
    # Set the Google Maps URL for Swakopmund Museum
    ${MUSEUM_URL}=    Set Variable    https://www.google.fi/maps/place/Swakopmund+Museum/@-22.6756226,14.5230034,17z/data=!4m8!3m7!1s0x1c7658f9c01bdb93:0x2df2ed521c4360ec!8m2!3d-22.6756226!4d14.5230034!9m1!1b1!16s%2Fg%2F1222z81j?entry=ttu&g_ep=EgoyMDI1MDUxMy4xIKXMDSoASAFQAw%3D%3D
    # Open the browser and navigate to the URL
    Open Browser    ${MUSEUM_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    # Accept cookies if prompted (button text may vary by language)
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    # Scroll down to the reviews section
    Execute JavaScript    window.scrollBy(0, 800)
    Sleep    2s
    # Click 'More reviews' if available (handles multiple languages)
    Run Keyword And Ignore Error    Click Element    xpath=//button[contains(@aria-label,'Lisää arvosteluja') or contains(text(),'Lisää arvosteluja') or contains(text(),'More reviews')]
    Sleep    2s
    # Scroll the reviews panel multiple times to load more reviews
    FOR    ${INDEX}    IN RANGE    30
        Execute JavaScript    var el = document.evaluate('//*[@id="QA0Szd"]/div/div/div[1]/div[2]/div/div[1]/div/div/div[2]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if (el) { el.scrollBy(0, 2000); }
        Sleep    1s
    END
    # Get all visible review text elements
    ${review_elements}=    Get WebElements    xpath=//span[contains(@class,'wiI7pd')]
    ${reviews}=    Create List
    # Extract text from each review element
    FOR    ${el}    IN    @{review_elements}
        ${review}=    Get Text    ${el}
        ${reviews}=    Create List    @{reviews}    ${review}
    END
    # Log the extracted reviews
    Log    Extracted reviews: ${reviews}
    # Set the output file path for raw reviews
    ${file}=    Set Variable    review_texts/museum_reviews.txt
    # Remove the file if it exists (to avoid appending to old data)
    Run Keyword And Ignore Error    Remove File    ${file}
    # Write each review to the file, separated by ---
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    # Capture a screenshot of the reviews page
    Capture Page Screenshot    review_screenshots/museum_reviews.png
    # Call the Gemini summarization keyword for this attraction
    Run Keyword    Summarize Museum Reviews With Gemini Test
    [Teardown]    Close Browser

# Test case: Extract reviews for Swakopmund Genocide Museum from Google Maps
Extract Swakopmund Genocide Museum Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Swakopmund Genocide Museum from Google Maps by scrolling the reviews section and saving them to a file.
    ${GENMUSEUM_URL}=    Set Variable    https://www.google.fi/maps/place/Swakopmund+Genocide+Museum/@-22.6375583,14.5585919,17z/data=!4m8!3m7!1s0x1c76590e2339157d:0x89d63bc2e62b1f67!8m2!3d-22.6375584!4d14.5634628!9m1!1b1!16s%2Fg%2F11kjlvp94z?entry=ttu&g_ep=EgoyMDI1MDUxNS4wIKXMDSoASAFQAw%3D%3D
    Open Browser    ${GENMUSEUM_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    Execute JavaScript    window.scrollBy(0, 800)
    Sleep    2s
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
    ${file}=    Set Variable    review_texts/genocide_museum_reviews.txt
    Run Keyword And Ignore Error    Remove File    ${file}
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    Capture Page Screenshot    review_screenshots/genocide_museum_reviews.png
    Run Keyword    Summarize Genocide Museum Reviews With Gemini Test
    [Teardown]    Close Browser

# Test case: Extract reviews for Platz Am Meer Waterfront from Google Maps
Extract Platz Am Meer Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Platz Am Meer Waterfront from Google Maps by scrolling the reviews section and saving them to a file.
    ${PLATZ_URL}=    Set Variable    https://www.google.fi/maps/place/Platz+Am+Meer+Waterfront/@-22.6453385,14.5227527,17z/data=!4m8!3m7!1s0x1c76590c5a81ae6b:0x3196ac88d1f478b5!8m2!3d-22.6453386!4d14.5276236!9m1!1b1!16s%2Fg%2F11cn9m34j_?entry=ttu&g_ep=EgoyMDI1MDUxNS4wIKXMDSoASAFQAw%3D%3D
    Open Browser    ${PLATZ_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    Execute JavaScript    window.scrollBy(0, 800)
    Sleep    2s
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
    ${file}=    Set Variable    review_texts/platz_am_meer_reviews.txt
    Run Keyword And Ignore Error    Remove File    ${file}
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    Capture Page Screenshot    review_screenshots/platz_am_meer_reviews.png
    Run Keyword    Summarize Platz Am Meer Reviews With Gemini Test
    [Teardown]    Close Browser

# Test case: Extract reviews for Kristall Galerie from Google Maps
Extract Kristall Galerie Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Kristall Galerie from Google Maps by scrolling the reviews section and saving them to a file.
    ${KRISTALL_URL}=    Set Variable    https://www.google.fi/maps/place/Kristall+Galerie/@-22.6746743,14.5234546,17z/data=!4m8!3m7!1s0x1c7658fa486d87ef:0xe581b30b47e101c8!8m2!3d-22.6746743!4d14.5260295!9m1!1b1!16s%2Fg%2F121g7dvl?entry=ttu&g_ep=EgoyMDI1MDUxNS4wIKXMDSoASAFQAw%3D%3D
    Open Browser    ${KRISTALL_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    Execute JavaScript    window.scrollBy(0, 800)
    Sleep    2s
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
    ${file}=    Set Variable    review_texts/kristall_galerie_reviews.txt
    Run Keyword And Ignore Error    Remove File    ${file}
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    Capture Page Screenshot    review_screenshots/kristall_galerie_reviews.png
    Run Keyword    Summarize Kristall Galerie Reviews With Gemini Test
    [Teardown]    Close Browser

# Test case: Extract reviews for Desert Explorers Adventure Centre from Google Maps
Extract Desert Explorers Adventure Centre Reviews From Google Maps
    [Documentation]    Extracts as many review comments as possible for Desert Explorers Adventure Centre from Google Maps by scrolling the reviews section and saving them to a file.
    ${DESERT_EXPLORERS_URL}=    Set Variable    https://www.google.fi/maps/place/Desert+explorers+adventure+centre/@-22.685034,14.5265861,17z/data=!4m8!3m7!1s0x1c7658f2672cc215:0xddf0ca10c9d54b5e!8m2!3d-22.685034!4d14.529161!9m1!1b1!16s%2Fg%2F11c52s_y2l?entry=ttu&g_ep=EgoyMDI1MDUxNS4wIKXMDSoASAFQAw%3D%3D
    Open Browser    ${DESERT_EXPLORERS_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    5s
    Run Keyword And Ignore Error    Click Button    xpath=//button[.//div[contains(text(),'Hyväksy kaikki') or contains(text(),'Salli kaikki')]]
    Sleep    2s
    Execute JavaScript    window.scrollBy(0, 800)
    Sleep    2s
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
    ${file}=    Set Variable    review_texts/desert_explorers_reviews.txt
    Run Keyword And Ignore Error    Remove File    ${file}
    FOR    ${review}    IN    @{reviews}
        Append To File    ${file}    ${review}\n---\n
    END
    Capture Page Screenshot    review_screenshots/desert_explorers_reviews.png
    Run Keyword    Summarize Desert Explorers Adventure Centre Reviews With Gemini Test
    [Teardown]    Close Browser

*** Keywords ***
# Keyword: Summarize Swakopmund Museum reviews using Gemini AI
Summarize Museum Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result.
    # Run the Python script to summarize reviews using Gemini
    ${output}=    Run Process    python    summarize_reviews_with_file.py    review_texts/museum_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    # Check for missing Gemini client or script errors
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.
    # Save the summary output to a file
    ${summary_file}=    Set Variable    review_summaries/museum_reviews_gemini_summary.txt
    Create File    ${summary_file}    ${output.stdout}

# Keyword: Summarize Genocide Museum reviews using Gemini AI
Summarize Genocide Museum Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result for the genocide museum.
    ${output}=    Run Process    python    summarize_reviews_with_file.py    review_texts/genocide_museum_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.
    ${summary_file}=    Set Variable    review_summaries/genocide_museum_reviews_gemini_summary.txt
    Create File    ${summary_file}    ${output.stdout}

# Keyword: Summarize Platz Am Meer reviews using Gemini AI
Summarize Platz Am Meer Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result for Platz Am Meer Waterfront.
    ${output}=    Run Process    python    summarize_reviews_with_file.py    review_texts/platz_am_meer_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.
    ${summary_file}=    Set Variable    review_summaries/platz_am_meer_reviews_gemini_summary.txt
    Create File    ${summary_file}    ${output.stdout}

# Keyword: Summarize Kristall Galerie reviews using Gemini AI
Summarize Kristall Galerie Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result for Kristall Galerie.
    ${output}=    Run Process    python    summarize_reviews_with_file.py    review_texts/kristall_galerie_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.
    ${summary_file}=    Set Variable    review_summaries/kristall_galerie_reviews_gemini_summary.txt
    Create File    ${summary_file}    ${output.stdout}

# Keyword: Summarize Desert Explorers Adventure Centre reviews using Gemini AI
Summarize Desert Explorers Adventure Centre Reviews With Gemini Test
    [Documentation]    Calls the Gemini AI summary keyword and logs the result for Desert Explorers Adventure Centre.
    ${output}=    Run Process    python    summarize_reviews_with_file.py    review_texts/desert_explorers_reviews.txt    shell=True    stdout=PIPE    stderr=PIPE
    Log    ===== GEMINI STDOUT =====\n${output.stdout}
    Log    ===== GEMINI STDERR =====\n${output.stderr}
    Should Not Contain    ${output.stderr}    ModuleNotFoundError    Gemini Python client is not installed. Run 'pip install google-generativeai'.
    Should Not Contain    ${output.stderr}    Traceback    Gemini script failed. See stderr above.
    ${summary_file}=    Set Variable    review_summaries/desert_explorers_reviews_gemini_summary.txt
    Create File    ${summary_file}    ${output.stdout}
