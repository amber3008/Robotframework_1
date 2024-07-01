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
#Library           ${CURDIR}${/}..//Libraries//com.amdocs.automation.base//SendEmail.py
Library           ${CURDIR}${/}..//Libraries//com.amdocs.automation.base//SendEmail_1.py


*** Variables ***
${LOGIN URL}    http://google.com
${baseUrl}      http://zltv9973.vci.att.com:41400
${urn}      /rp-webapp-9/ordering/Orders?paramType=solutionid&paramValue=
${urnSaveTn}    /rp-webapp-9/ordering/SaveTelephoneNumbersInProduct?orderNumber=
${urnSaveUDR}    /rp-webapp-9/ordering/SaveUserDefinedRangesServiceInProduct
${version}      &orderVersion=1
${bvoip_ordrId}   "345674"
${orderType}    ${null}
${status}       ${null}


*** Test Cases ***
#Add TNs in order
#    ${orderId}=    Convert To String    202224684
#    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
#    updateTn
#    ${tnUrl}      Set Variable   ${urnSaveTn}${orderId}${version}
 #   Log To Console    ${tnUrl}
  #  create session   mysession   ${baseUrl}     headers=${auth}
  #  ${json}  Get Binary File  xmls\\requests\\SaveManualTn.json
  #  ${resp}    POST On Session    mysession      ${tnUrl}      data=${json}   # headers=${headers}
  #  Log To Console    ${resp.content}
  #  Create Binary File      xmls\\response\\SaveManualTn.json     ${resp.content}


#Save UDRs in Order
#    ${bvoip_ordrId} =    Convert To String    202224684
#    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
#    ${tns_info}=     getTns
#    ${tn}=   Get From List   ${tns_info}  0
#    ${reqId}=  Get From List   ${tns_info}  1
#    Log To Console    ${tn}
#    ${lr}=      updateSaveUDR   ${tn}   ${reqId}    ${bvoip_ordrId}
#    ${lr1}=   Get From List   ${lr}  0
#    ${lr2}=  Get From List   ${lr}  1
#    Log To Console    ${lr}
#    ${saveUdrUrl}      Set Variable   ${urnSaveUDR}
#    Log To Console    ${saveUdrUrl}
#    create session   mysession   ${baseUrl}     headers=${auth}
#    ${json}  Get Binary File  xmls\\requests\\SaveUDR.json
#    ${resp}    POST On Session    mysession      ${saveUdrUrl}      data=${json}   # headers=${headers}
#    Log To Console    ${resp.content}
#    Create Binary File      xmls\\response\\SaveUDR.json     ${resp.content}


#Get data from excel
#    ${result1}     ${result2}        run keyword        Get data from excel      SAVE_ATT_TN      ST4
#    Log to Console      ${result1}
#    Log to Console      ${result2}
#    ${data}=  Read Cell Data By Coordinates   URLs    ${result2}   ${result1}
#    Log to Console      ${data}

#Checking IFELSE Condition
#    Check IfElse Condition      IPFLEXMIS      DE


#Display xml In console
#    ${contents}=     Get File   xmls//requests//notifyRequest.xml
#    Log To Console      ${contents}


#Email Notification
 #   sendEmail
 #   send mail no attachment     Inpnqrmail.corp.amdocs.com      amberb@amdocs.com       MyWishesComeTrue#3008       amber.bhatnagar@amdocs.com      Status Of Test Case        Test Case Completed


*** Test Cases ***

Checking IFELSE Condition
    Check IfElse Condition      IPFLEXMIS       DE


*** Keyword ***

Check IfElse Condition
    [Arguments]     ${orderType}      ${status}
    Log to console      ${orderType}
    IF  '${status}' == 'DE'
            Log to console     Order is submitted
    END
    IF  '${status}' == 'NE'
            Log to console      Order is not submitted
    END

