*** Settings ***
Documentation     To create GAMMA Orders.
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           XML
Library           ${CURDIR}${/}..//Libraries//com.amdocs.automation.base//UpdateXml.py
Library           Dialogs

*** Variables ***
${isPmtu}   N
${isAdx}   Y
${stateRegion1}   N
${stateRegion2}   Y


*** Test Cases ***
Push UNI CNOD Request TC1

    updateXmlUni    ${isPmtu}   ${isAdx}    ${stateRegion1}     ${stateRegion2}
    # Log to console  ${stateRegion1}
    Create Soap Client    http://zltv9973.vci.att.com:41400/ORDERING_PORTFOLIO/CustomerOrderEstablishment?wsdl
    ${response}    Call SOAP Method With XML    xmls//requests//CNOD_UNI_NS.xml
    Save XML To File    ${response}    xmls//response    CNOD_UNI_NS_Response
    copy file  xmls//response//CNOD_UNI_NS_Response.xml  xmls//response//CNOD_UNI_NS_Response.txt

Push PTP CNOD Request TC2
    ${unis}=   updateXmlPTP
    Log to console  ${unis}
   # ${username} =	Get Value From User	Input user name	default
    Create Soap Client    http://zltv9973.vci.att.com:41400/ORDERING_PORTFOLIO/CustomerOrderEstablishment?wsdl
    ${response}    Call SOAP Method With XML    xmls//requests//CNOD_PTP_NS.xml
    Save XML To File    ${response}    xmls//response    CNOD_PTP_NS_Response
    copy file  xmls//response//CNOD_PTP_NS_Response.xml  xmls//response//CNOD_PTP_NS_Response.txt

