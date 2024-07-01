*** Settings ***
Documentation     Test
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           SeleniumLibrary
Library           XML
Library           ${CURDIR}${/}..//Libraries//com.amdocs.automation.base//UpdateXml.py
Resource          ${CURDIR}${/}..//Resource//GetURLFromExcel.robot
Library           ExcelLibrary


*** Variables ***
${urn}      /rp-webapp-9/ordering/Orders?paramType=solutionid&paramValue=
${strColCount}      ${null}
${strRowCount}      ${null}
${rowIndex}         ${null}
${colIndex}         ${null}
${sgIds}        ${null}
${sgId}     ${null}
#${env}      ST5
#&{orders}       a=b
#&{statuses}     c=d


#*** Test Cases ***
#Get Order Details
#    Run Keyword        Get Order Details       1-ME87479
#    ${mis_ordrId} =	    Get From Dictionary	${orders}     MISM
#    ${acsm_ordrId} =	    Get From Dictionary	${orders}     ACSM
#    Log To Console      ACSM Order ID is :
#    Log To Console      ${acsm_ordrId}
#    Log To Console      MISM Order ID is :
#    Log To Console      ${mis_ordrId}
#     ${mis_status} =	    Get From Dictionary	${statuses}     MISM
#    ${acsm_status} =	    Get From Dictionary	${statuses}     ACSM
#    Log To Console   Status of ACSM order is :
#    Log To Console   ${acsm_status}
#    Log To Console   Status of MISM order is :
#    Log To Console   ${mis_status}
#Get data from excel
#    ${result1}     ${result2}        run keyword        Get data from excel      SAVE_ATT_TN      ST4
#    Log to Console      ${result1}
#    Log to Console      ${result2}
#    ${data}=  Read Cell Data By Coordinates   URLs    ${result2}   ${result1}
#    Log to Console      ${data}

*** Keyword ***

Get Order Details
    [Arguments]     ${sorId}
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    ${url}      Set Variable   ${urn}${sorid}
    Log To Console      ${url}
    ${baseUrl}     run keyword     Get Base URL
    Log To Console      ${baseUrl}
    create session   mysession   ${baseUrl}     headers=${auth}
    Log to console  Base URL is:
    Log To Console      ${baseUrl}
    Log to console  URL for get Data is :
    Log to console  ${url}
    ${response}=    GET On Session  mysession      ${url}
    Log to console  ${response.content}

    ${resp}=     to json   ${response.content}
    ${serviceType}=    get value from json     ${resp}         $.SearchOrderResponse.orderDataX9[0].orderActionDataX9..serviceTypeX9
    ${orderActionId}=   get value from json     ${resp}         $.SearchOrderResponse.orderDataX9[0].orderActionDataX9..orderActionIdX9
    ${status}=   get value from json     ${resp}         $.SearchOrderResponse.orderDataX9[0].orderActionDataX9..statusX9
    ${sgIds}=   get value from json     ${resp}         $.SearchOrderResponse.orderDataX9..orderIdX9
    ${sgId}=    get from list  ${sgIds}  0

    ${len}=     Get length      ${serviceType}

    ${orders}       Run Keyword        Save OrderIDs Of the Order       ${len}  ${serviceType}  ${orderActionId}
    ${statuses}     Run Keyword        Save Statuses of the Order       ${len}  ${serviceType}  ${status}

    [RETURN]        ${len}      ${serviceType}    ${orderActionId}    ${status}       ${sgId}       ${orders}       ${statuses}




Get Base URL
    ${result1}     ${result2}        run keyword        Get data from excel      BASE_URL      ${env}
    ${baseUrl}=  Read Cell Data By Coordinates   URLs    ${result2}   ${result1}
    [RETURN]      ${baseUrl}

Save OrderIDs Of the Order
    [Arguments]  ${len}     ${serviceType}  ${orderActionId}
    ${i}=   Set Variable    0
    Remove From Dictionary	${orders}	a
    FOR     ${i}     IN RANGE      ${len}
        Set To Dictionary      ${orders}       ${serviceType[${i}]}    ${orderActionId[${i}]}
    END
    Log To Console   ${orders}
    [RETURN]      ${orders}


Save Statuses of the Order
    [Arguments]  ${len}     ${serviceType}      ${status}
 #   ${len} =  Convert To Number     ${len}
    Remove From Dictionary	${statuses}     c
    ${j}=   Set Variable    0
    FOR     ${j}     IN RANGE      ${len}
        Set To Dictionary      ${statuses}       ${serviceType[${j}]}    ${status[${j}]}
    END
    [RETURN]      ${statuses}