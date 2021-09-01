*** Settings ***
Documentation     Create Old Arch Orders in OCX and OMX
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           XML
Library           C:\\Users\\amberb\\PycharmProjects\\Halo-Gamma\\Libraries\\com.amdocs.automation.base\\UpdateXml.py

*** Variables ***
${a}    1-MECAC2933
${b}    /rp-webapp-9/ordering/Orders?paramType=solutionid&paramValue=
${baseUrl}      http://zltv9972.vci.att.com:41200
&{orders}       a=b

*** Tasks ***
Push Notify Request
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    Log to console  ${auth}
    create session   mysession   ${baseUrl}     headers=${auth}
    ${url}      Set Variable   ${b}${a}
    Log to console  ${url}
    ${response}=    GET On Session  mysession      ${url}
    ${resp}=     to json   ${response.content}
    Log to console      ${resp}
    ${serviceType}=    get value from json     ${resp}         $.SearchOrderResponse.orderDataX9[0].orderActionDataX9..serviceTypeX9
    ${orderActionId}=   get value from json     ${resp}         $.SearchOrderResponse.orderDataX9[0].orderActionDataX9..orderActionIdX9
    ${sgIds}=   get value from json     ${resp}         $.SearchOrderResponse.orderDataX9..orderIdX9
    ${sgId}=    get from list  ${sgIds}  0
    ${i}=   Set Variable    0
    ${len}=     Get length      ${serviceType}
    Remove From Dictionary	${orders}	a
    FOR     ${i}     IN RANGE      ${len}
        Set To Dictionary      ${orders}       ${serviceType[${i}]}    ${orderActionId[${i}]}
       # ${i}=    Set Variable    ${i+1}
        Log To Console   ${i}
        Log To Console   ${orders}
    END
    Log To Console   ${orders}
    ${acsm_ordrId} =	Get From Dictionary	${orders}	ACSM
    ${mis_ordrId} =	Get From Dictionary	${orders}	MISM
    Log To Console   ${acsm_ordrId}
    Log To Console   ${mis_ordrId}
    ${acsm_ordrId} =	Get From Dictionary	${orders}	ACSM
    ${mis_ordrId} =	Get From Dictionary	${orders}	MISM
    updateMorSg     ${acsm_ordrId}  ${mis_ordrId}    ${a}   897609   ${sgId}
    Create Soap Client       http://atht4a1.snt.bst.bls.com:8702/omxif-client-inbound-ws-war/ManageOrderService.wsdl
    ${response}     Call SOAP Method With XML        C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//requests//MOR_SG_OLD_1.xml
    Save XML To File     ${response}        C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response    MOR_SG_OLD_Response
    copy file    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//MOR_SG_OLD_Response.xml     C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//MOR_SG_OLD_Response.txt


Verify Order is submitted to OMX