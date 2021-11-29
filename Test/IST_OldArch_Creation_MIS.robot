*** Settings ***
Documentation     To create Old Arch Orders.
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           XML
Library           C://Users//amberb//PycharmProjects//Halo-Gamma//Libraries//com.amdocs.automation.base//UpdateXml.py


*** Variables ***
${a}     MIS
${baseUrl}      http://zltv9972.vci.att.com:41200
${urn}      /rp-webapp-9/ordering/Orders?paramType=solutionid&paramValue=
${submitUrn}    /rp-webapp-9/ordering/SubmitOrderAction
&{orders}       a=b
&{statuses}     c=d
${json_file}    C:\\Users\\amberb\\PycharmProjects\\Halo-Gamma\\xmls\\requests\\


*** Test Cases ***
Push Notify Request
    ${sorIds}=   updateXml    ${a}
    Log to console  ${sorIds}
    Create Soap Client    http://newtt4a1.snt.bst.bls.com:9003/omxenterprise-client-inbound-ws-war/NxEnterpriseService.wsdl
    ${response}    Call SOAP Method With XML    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//requests//notifyRequest.xml
    Save XML To File    ${response}    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response    notifyResponse
    copy file   C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//notifyResponse.xml  C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//notifyResponse.txt


Push Decompose Sales Order Request
    ${ids}=     getSorProjId
    Log to console  ${ids}
    pushDecomposeXml    ${ids}
    Create Soap Client    http://zltv9972.vci.att.com:41200/NW-WEB_SERVICES/NotifyOCX?wsdl
    ${response}    Call SOAP Method With XML    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//requests//decomposeSalesOrderRequest.xml
    Save XML To File    ${response}    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response    decomposeSalesOrderResponse
    copy file   C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//decomposeSalesOrderResponse.xml  C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//decomposeSalesOrderResponse.txt
    Sleep   5 minutes


Push Manage Order Request for Service Group
    ${ids}=     getSorProjId
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    Log to console  ${auth}
    create session   mysession   ${baseUrl}     headers=${auth}
    ${sorid}=   Get From List   ${ids}  0
    ${projId}=  Get From List   ${ids}  1
    Log to console  ${sorid}
    ${url}      Set Variable   ${urn}${sorid}
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

    ${i}=   Set Variable    0
    Remove From Dictionary	${orders}	a
    FOR     ${i}     IN RANGE      ${len}
        Set To Dictionary      ${orders}       ${serviceType[${i}]}    ${orderActionId[${i}]}
    END
    Log To Console   ${orders}

    Remove From Dictionary	${statuses}     c
    ${j}=   Set Variable    0
    FOR     ${j}     IN RANGE      ${len}
        Set To Dictionary      ${statuses}       ${serviceType[${j}]}    ${status[${j}]}
        Log To Console   ${j}
        Log To Console   ${statuses}
    END
    Log To Console   ${statuses}

    ${acsm_ordrId} =	Get From Dictionary	${orders}	ACSM
    ${mis_ordrId} =	Get From Dictionary	${orders}	MISM
    updateMorSg     ${acsm_ordrId}  ${mis_ordrId}    ${sorid}   ${projId}   ${sgId}
    Create Soap Client       http://atht4a1.snt.bst.bls.com:8702/omxif-client-inbound-ws-war/ManageOrderService.wsdl
    ${response}     Call SOAP Method With XML        C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//requests//MOR_SG_OLD.xml
    Save XML To File     ${response}        C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response    MOR_SG_OLD_Response
    copy file    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//MOR_SG_OLD_Response.xml     C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//MOR_SG_OLD_Response.txt


Verify Order is submitted to OMX
    ${acsm_status} =	Get From Dictionary	${statuses}     ACSM
    ${mis_status} =	    Get From Dictionary	${statuses}     MISM
    Log To Console   ${acsm_status}
    Log To Console   ${mis_status}
    Run Keyword If    '${mis_status}' == 'DE'   Submit Order Message
    Run Keyword If    '${mis_status}' == 'NE'      Submit Order If not Submitted


*** Keyword ***

Submit Order Message
    Log To Console      Order Submitted Successfully

Submit Order If not Submitted
    ${mis_ordrId} =	Get From Dictionary	${orders}	MISM
    ${acsm_status} =	Get From Dictionary	${statuses}     ACSM
    ${mis_status} =	    Get From Dictionary	${statuses}     MISM
    Log To Console   ${acsm_status}
    Log To Console   ${mis_status}
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    Log To Console    ${mis_status}
    updateSubmitJson    ${mis_ordrId}
    create session   mysession   ${baseUrl}     headers=${auth}
    ${json}  Get Binary File  ${json_file}SubmitOrderActionReq.json
    ${resp}    POST On Session    mysession      ${submitUrn}      data=${json}   # headers=${headers}
    Log To Console    ${resp.content}