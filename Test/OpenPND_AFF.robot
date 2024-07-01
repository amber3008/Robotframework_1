*** Settings ***
Documentation    Suite description
Library           SeleniumLibrary
Library           OperatingSystem
Resource          ${CURDIR}${/}..//Resource//GetURLFromExcel.robot


*** Variables ***
${orderSearch}      //*[contains(text(),'Project Name')]//following-sibling::span//following-sibling::input
${advSearch}        //div[contains(text(),'Advanced Search')]
${searchButton}     //div[@class="footer"]//child::div//following-sibling::div//following-sibling::div//following-sibling::div
${projectName}     //a[@class="projectName"]
${pndView}      //button[@class="pndFullViewButton"]

#*** Test Cases ***
#Open AFFUI
#   Order Search in AFF UI       187432282


*** Keyword ***
Order Search in AFF UI
    [Arguments]     ${ordrActionId}
    Log To Console    ${ordrActionId}
    Log To Console    ================== GUI Testing Started ======================
    ${result1}     ${result2}        run keyword        Get data from excel      AFFUI_URL      ${env}
    ${affUiUrl}=  Read Cell Data By Coordinates   URLs    ${result2}   ${result1}
    Log To Console    ${affUiUrl}
    Log To Console    ================== Opening Browser ======================
    open browser    ${affUiUrl}    Chrome
    Log To Console    ================== Browser Opened ======================
    set selenium implicit wait   60s
   # Log To Console    Done02
    Log To Console    ================== Maximizing Window ======================
    Maximize Browser Window
    Log To Console    ================== Window Maximised ======================
    Wait Until Page Contains Element        ${advSearch}
   # Log To Console    Done11
    Log To Console    ================== Inititiating Order Search ======================
    click element   ${advSearch}
   # Log To Console    Done12
    #Log To Console    ====================Done1============================
    #Log To Console    Done2
    Wait Until Page Contains Element        ${orderSearch}
   # Log To Console    Done21
    input text     ${orderSearch}      ${ordrActionId}
    Log To Console    ================== Inititiated Order Search ======================
    click element   ${searchButton}
    #Log To Console    Done23
    #Log To Console    =====================Done2===========================
    #Log To Console    Done3
    Wait Until Page Contains Element        ${projectName}
    click element   ${projectName}
    Log To Console    Done4
    Sleep   1.5 minutes
    #wait until element is visible        ${pndView}
    #wait until element is enabled        ${pndView}
    click element   ${pndView}
    Sleep   0.8 minutes
    Log To Console    ================== GUI testing Completed ======================
    close Browser
    Log To Console    ================== Browser Closed ======================