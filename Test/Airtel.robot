*** Settings ***
Library  Documentation  Suite
Library  SeleniumLibrary
Library  OperatingSystem
Documentation    Suite description
Library           SeleniumLibrary

*** Variables ***
${URL}  https://www.airtel.in/
${Browser}  chrome
${prepaid}      //div[@class="header-brand"]//following-sibling::div[@class="header-main"]//child::div[@class="header-main-actions-container"]//child::div[@class="header-main-actions-list-content"]//child::div[@class="actions-list-container"]//child::h3[contains(text(),'PREPAID')]
${recharge}     //div[@class="header-brand"]//following-sibling::div[@class="header-main"]//child::div[@class="header-main-actions-container"]//child::div[@class="header-main-actions-list-content"]//child::div[@class="actions-list-container"]//child::h3[contains(text(),'PREPAID')]//following-sibling::ul//li//a[contains(text(),'Recharge')]
${mobile}       //input[@id='txtMobile']
${plan}     //div[@class="clear pack-detail-wrap"]//following-sibling::div//following-sibling::div//following-sibling::div//following-sibling::div//child::button
${Banking}     //*[contains(text(),'Net Banking')]
${Bank_Name}     //*[contains(text(),'HDFC')]
${hdfc}    //input[@class='form-control text-muted']




*** Test Cases ***
Open Airtel
   Recharge
   set selenium implicit wait   20s


*** Keywords ***
Recharge
    Open browser    ${URL}  ${Browser}
    maximize Browser Window
    Wait Until Page Contains Element        ${prepaid}
    click element   ${prepaid}
    #sleep   0.1 minutes
    Wait Until Page Contains Element        ${recharge}
    click element   ${recharge}
    #Sleep   0.1 minutes
    Wait Until Page Contains Element        ${mobile}
    input text      ${mobile}      9503360675
    #Sleep   0.1 minutes
    Wait Until Page Contains Element        ${plan}
    click element   ${plan}
   #Sleep   0.1 minutes
    Wait Until Page Contains Element        ${Banking}
    click element   ${Banking}
    #Sleep   0.1 minutes
    wait until element is visible        ${Bank_Name}
    click element   ${Bank_Name}
   # wait until element is visible        ${hdfc}    30s
    Sleep   0.4 minutes
    input text      ${hdfc}      9503360675
    close Browser
