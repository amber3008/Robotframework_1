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
${mis_ordrId}       89076
${b}    /rp-webapp-9/ordering/Orders?paramType=solutionid&paramValue=
${baseUrl}      http://zltv9972.vci.att.com:41200
${submitUrn}    /rp-webapp-9/ordering/SubmitOrderAction
&{orders}       a=b
&{statuses}     c=d
${json_file}    C:\\Users\\amberb\\PycharmProjects\\Halo-Gamma\\xmls\\requests\\

*** Tasks ***
Verify Order is submitted to OMX
    ${auth}=    BuiltIn.Create Dictionary    UAMS_USER=Asmsa1      UAMS_PASS=Asmsa1
    updateSubmitJson    ${mis_ordrId}
    create session   mysession   ${baseUrl}     headers=${auth}
    ${json}  Get Binary File  C:\\Users\\amberb\\PycharmProjects\\Halo-Gamma\\xmls\\requests\\SubmitOrderActionReq.json
    ${resp}    POST On Session    mysession      ${submitUrn}      data=${json}   # headers=${headers}
    Log To Console    ${resp.content}