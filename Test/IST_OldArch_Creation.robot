*** Settings ***
Documentation     To create Old Arch Orders.
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           SeleniumLibrary
Library           XML
Library           ${CURDIR}${/}..//Libraries//com.amdocs.automation.base//UpdateXml.py
Resource          ${CURDIR}${/}..//Resource//GetURLFromExcel.robot
Resource          ${CURDIR}${/}..//Resource//GetOrderDetails.robot
Resource          ${CURDIR}${/}..//Test//OpenPND_AFF.robot
Library           ${CURDIR}${/}..//Libraries//com.amdocs.automation.base//SendEmail_1.py


*** Variables ***
${orderType}     IPFLEXMIS
${env}     ST5
${baseUrl}      ${null}
${urn}      /rp-webapp-9/ordering/Orders?paramType=solutionid&paramValue=
${urnSaveTn}    /rp-webapp-9/ordering/SaveTelephoneNumbersInProduct?orderNumber=
${version}      &orderVersion=1
${submitUrn}    /rp-webapp-9/ordering/SubmitOrderAction
${urnSaveUDR}    /rp-webapp-9/ordering/SaveUserDefinedRangesServiceInProduct
&{orders}       a=b
&{statuses}     c=d
${json_file}    ${CURDIR}${/}..\\xmls\\requests\\
${bvoip_ordrId}     ${null}
${bvoip_status}     ${null}
${len}        ${null}
${serviceType}       ${null}
${sgIds}        ${null}
${sgId}     ${null}
${sorid}       ${null}
${sorIds}   ${null}


*** Test Cases ***

Push Notify Request
    ${sorIds}=   updateXml    ${orderType}
    Log to console   SOR ID and PROJECT is
    Log to console      ${sorIds}
    ${baseUrl}     run keyword     Get Base URL
    ${result1}     ${result2}        run keyword        Get data from excel      NOTIFY_REQUEST      ${env}
    ${urlFromExcel}=  Read Cell Data By Coordinates   URLs    ${result2}   ${result1}
    Log To Console      ${urlFromExcel}
    ${contents}=     Get File   xmls//requests//notifyRequest.xml
    Log To Console      ${contents}
    Create Soap Client    ${urlFromExcel}
    ${response}    Call SOAP Method With XML     xmls//requests//notifyRequest.xml
    Save XML To File    ${response}     xmls//response    notifyResponse
    copy file    xmls//response//notifyResponse.xml   xmls//response//notifyResponse.txt
    ${responseContent}=     Get File   xmls//response//notifyResponse.xml
    Log To Console      ${responseContent}


Push Decompose Sales Order Request
    ${ids}=     getSorProjId
    pushDecomposeXml    ${ids}
    ${result1}     ${result2}        run keyword        Get data from excel      DECOMPOSE_SALES_ORDER_REQUEST      ${env}
    ${urlFromExcel}=  Read Cell Data By Coordinates   URLs    ${result2}   ${result1}
    Log To Console      ${urlFromExcel}
    ${requestContent}=     Get File   xmls//requests//decomposeSalesOrderRequest.xml
    Log To Console      ${requestContent}
    Create Soap Client    ${urlFromExcel}
    ${response}    Call SOAP Method With XML     xmls//requests//decomposeSalesOrderRequest.xml
    Save XML To File    ${response}     xmls//response    decomposeSalesOrderResponse
    copy file    xmls//response//decomposeSalesOrderResponse.xml   xmls//response//decomposeSalesOrderResponse.txt
    ${responseContent}=     Get File   xmls//response//decomposeSalesOrderResponse.xml
    Log To Console      ${responseContent}
    Sleep   5 minutes


Push Manage Order Request for Service Group
    ${ids}=     getSorProjId
    ${sorid}=   Get From List   ${ids}  0
    ${projId}=  Get From List   ${ids}  1
    ${len}      ${serviceType}    ${orderActionId}    ${status}       ${sgId}       ${orders}       ${statuses}      Run Keyword        Get Order Details       ${sorid}

    ${bvoip_ordrId} =	    Get From Dictionary	${orders}     BVOIP
    ${mis_ordrId} =	    Get From Dictionary	${orders}     MISM
    ${acsm_ordrId} =	    Get From Dictionary	${orders}     ACSM
    Log To Console      ACSM Order ID is :
    Log To Console      ${acsm_ordrId}
    Log To Console      MISM Order ID is :
    Log To Console      ${mis_ordrId}
    IF    '${orderType}' == 'IPFLEXMIS'
            Log To Console      BVOIP Order ID is :
            Log To Console      ${bvoip_ordrId}
    END
    updateMorSg     ${acsm_ordrId}      ${mis_ordrId}    ${sorid}   ${projId}   ${sgId}
    ${result1}     ${result2}        run keyword        Get data from excel      ORDER_REQUEST      ${env}
    ${urlFromExcel}=  Read Cell Data By Coordinates   URLs    ${result2}   ${result1}
    Log To Console      ${urlFromExcel}
    ${requestContent}=     Get File   xmls//requests//MOR_SG_OLD.xml
    Log To Console      ${requestContent}
    Create Soap Client    ${urlFromExcel}
    ${response}     Call SOAP Method With XML         xmls//requests//MOR_SG_OLD.xml
    Save XML To File     ${response}         xmls//response    MOR_SG_OLD_Response
    copy file     xmls//response//MOR_SG_OLD_Response.xml      xmls//response//MOR_SG_OLD_Response.txt
    ${responseContent}=     Get File   xmls//response//MOR_SG_OLD_Response.xml
    Log To Console      ${responseContent}


Verify MIS order is submitted
    ${mis_status} =	    Get From Dictionary	${statuses}     MISM
    ${acsm_status} =	    Get From Dictionary	${statuses}     ACSM
    Log To Console   Status of ACSM order is :
    Log To Console   ${acsm_status}
    Log To Console   Status of MISM order is :
    Log To Console   ${mis_status}
    Run Keyword If    '${mis_status}' == 'DE'   Submit Order Message
    Run Keyword If    '${mis_status}' == 'NE'      Submit Order If not Submitted
    Run Keyword If    '${orderType}' == 'IPFLEXMIS'      Verify TNs are added to BVOIP order
    Run Keyword If    '${orderType}' == 'IPFLEXMIS'      Verify BVOIP Order is submitted to OMX


View Order in AFFUI

    ${ids}=     getSorProjId
    ${sorid}=   Get From List   ${ids}  0
    Log To Console   ${sorid}
    ${len}      ${serviceType}    ${orderActionId}    ${status}       ${sgId}       ${orders}       ${statuses}      Run Keyword        Get Order Details       ${sorid}
    ${mis_ordrId} =	    Get From Dictionary	    ${orders}     MISM
    ${mis_status} =	    Get From Dictionary	    ${statuses}     MISM
    IF    '${mis_status}' == 'DE'
            Order Search in AFF UI       ${mis_ordrId}
    ELSE IF    '${mis_status}' == 'NE'
        Log    MIS order is not submitted
    END

    IF  '${orderType}' == 'IPFLEXMIS'
        ${bvoip_ordrId} =	    Get From Dictionary	${orders}     BVOIP
        ${bvoip_status} =	    Get From Dictionary	${statuses}     BVOIP
        IF    '${bvoip_status}'  == 'DE'
                Run Keyword If    '${orderType}' == 'IPFLEXMIS'      Order Search in AFF UI       ${bvoip_ordrId}
        ELSE IF    '${bvoip_status}' == 'NE'
                Log    BVOIP order is not submitted
        END
    END

Email Notification
    #sendEmail
    send mail no attachment     Inpnqrmail.corp.amdocs.com      amberb@amdocs.com       MyWishesComeTrue#3008       amber.bhatnagar@amdocs.com      Status Of Test Case        Test Case Completed



*** Keyword ***

Add TNs and Submit Order
    Add TNs in order
    Save UDRs in Order
    Submit Order If not Submitted

Add TNs in order
    ${bvoip_ordrId} =	Get From Dictionary	${orders}     BVOIP
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    updateTn
    ${tnUrl}      Set Variable   ${urnSaveTn}${bvoip_ordrId}${version}
    Log To Console    URL for save ATT TN is :
    Log To Console    ${tnUrl}
    ${baseUrl}     run keyword     Get Base URL
    Log to console  Base URL is:
    Log To Console      ${baseUrl}
    ${requestContent}=     Get File   xmls\\requests\\SaveManualTn.json
    Log To Console      ${requestContent}
    create session   mysession   ${baseUrl}     headers=${auth}
    ${json}  Get Binary File  xmls\\requests\\SaveManualTn.json
    ${resp}    POST On Session    mysession      ${tnUrl}      data=${json}   # headers=${headers}
    Log To Console    ${resp.content}
    Create Binary File      xmls\\response\\SaveManualTn.json     ${resp.content}
    ${responseContent}=     Get File   xmls\\response\\SaveManualTn.json
    #Log To Console      ${responseContent}


Save UDRs in Order
    ${bvoip_ordrId} =	Get From Dictionary	${orders}     BVOIP
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    ${tns_info}=     getTns
    ${tn}=   Get From List   ${tns_info}  0
    ${reqId}=  Get From List   ${tns_info}  1
    Log To Console    TN added is :
    Log To Console    ${tn}
    ${lr}=      updateSaveUDR   ${tn}   ${reqId}    ${bvoip_ordrId}
    ${lr1}=   Get From List   ${lr}  0
    ${lr2}=  Get From List   ${lr}  1
    Log To Console    NPA NXX of the TN is :
    Log To Console    ${lr}
    ${saveUdrUrl}      Set Variable   ${urnSaveUDR}
    ${baseUrl}     run keyword     Get Base URL
    Log to console  Base URL is:
    Log To Console      ${baseUrl}
    Log To Console    URL to push Save UDR is :
    Log To Console    ${saveUdrUrl}
    ${requestContent}=     Get File   xmls\\requests\\SaveUDR.json
    Log To Console      ${requestContent}
    create session   mysession   ${baseUrl}     headers=${auth}
    ${json}  Get Binary File  xmls\\requests\\SaveUDR.json
    ${resp}    POST On Session    mysession      ${saveUdrUrl}      data=${json}   # headers=${headers}
    Log To Console    ${resp.content}
    Create Binary File      xmls\\response\\SaveUDR.json     ${resp.content}
    ${responseContent}=     Get File   xmls\\response\\SaveUDR.json
   # Log To Console      ${responseContent}


Submit Order Message
    Log To Console      Order Submitted Successfully

Submit Order If not Submitted
    ${mis_ordrId} =	Get From Dictionary	${orders}	MISM
    ${acsm_status} =	Get From Dictionary	${statuses}     ACSM
    ${mis_status} =	    Get From Dictionary	${statuses}     MISM
    IF    '${orderType}' == 'IPFLEXMIS'
            ${ordrId} =   Get From Dictionary	${orders}	BVOIP
            ${bvoip_status} =   Get From Dictionary	${statuses}	BVOIP
    END
    IF    '${orderType}' == 'MIS'
            ${ordrId} =   Get From Dictionary	${orders}	MISM
    END

    Log To Console   Status of ACSM Order ID is :
    Log To Console   ${acsm_status}
    Log To Console   Status of MISM Order ID is :
    Log To Console   ${mis_status}
    IF    '${orderType}' == 'IPFLEXMIS'
        Log To Console   Status of BVOIP Order ID is :
        Log To Console   ${bvoip_status}
        Log To Console   BVOIP Order ID is :
        Log To Console   ${ordrId}
    END
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    ${baseUrl}     run keyword     Get Base URL
    Log to console  Base URL is:
    Log To Console      ${baseUrl}
    updateSubmitJson    ${ordrId}
    ${requestContent}=     Get File   xmls\\requests\\SubmitOrderActionReq.json
    Log To Console      ${requestContent}
    create session   mysession   ${baseUrl}     headers=${auth}
    ${json}  Get Binary File  xmls\\requests\\SubmitOrderActionReq.json
    ${resp}    POST On Session    mysession      ${submitUrn}      data=${json}   # headers=${headers}
    Log To Console    ${resp.content}
    Create Binary File      xmls\\response\\SubmitOrderActionRes.json     ${resp.content}
    ${responseContent}=     Get File   xmls\\response\\SubmitOrderActionRes.json
  #  Log To Console      ${responseContent}



Verify BVOIP Order is submitted to OMX
    ${bvoip_status} =	Get From Dictionary	${statuses}     BVOIP
    Run Keyword If    '${bvoip_status}' == 'DE'   Submit Order Message
    Run Keyword If    '${bvoip_status}' == 'NE'   Submit Order If not Submitted


Verify TNs are added to BVOIP order
    ${bvoip_status} =	Get From Dictionary	${statuses}     BVOIP
    Run Keyword If    '${bvoip_status}' == 'NE'     Add TNs and Submit Order



