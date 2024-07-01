*** Settings ***
Documentation     To create GAMMA Orders.
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           XML
Library           SeleniumLibrary
Library           ${CURDIR}${/}..//Libraries//com.amdocs.automation.base//UpdateXml.py
Library           Dialogs

*** Variables ***
#${isPmtu}   N
#${isAdx}   Y
#${stateRegion1}   N
#${stateRegion2}   Y
${LOGIN URL}    http://t3nap1a1.snt.bst.bls.com:9003/omx-web/index.html


*** Test Cases ***
Push UNI CNOD Request TC
   # ${env}=     Get Value From User     Enter Env      ST4
    ${stateRegion1}=     Get Value From User     Enter StateRegion1      default
    ${stateRegion2}=     Get Value From User     Enter StateRegion2      default
    ${isAdx}=       Get Value From User     Enter IsADX         default
    ${isPmtu}=      Get Value From User     Enter IsPMTU        default


    updateXmlUni    ${isPmtu}   ${isAdx}    ${stateRegion1}     ${stateRegion2}
    # Log to console  ${stateRegion1}
    ${getUrl}=      Get Value From User     Enter URL      ST4
    Log to console  ${getUrl}
    Create Soap Client    ${getUrl}
    ${response}    Call SOAP Method With XML    xmls//requests//CNOD_UNI_NS.xml
    Save XML To File    ${response}    xmls//response    CNOD_UNI_NS_Response
    copy file  xmls//response//CNOD_UNI_NS_Response.xml  xmls//response//CNOD_UNI_NS_Response.txt


Push PTP CNOD Request TC2
    ${statRegion}=      Get Value From User     Enter StateRegions      default
    Log to console      ${statRegion}
    ${unis}=   updateXmlPTP
    Log to console  ${unis}
   # ${username} =	Get Value From User	Input user name	default
    Create Soap Client    http://zltv9973.vci.att.com:41400/ORDERING_PORTFOLIO/CustomerOrderEstablishment?wsdl
    ${response}    Call SOAP Method With XML    xmls//requests//CNOD_PTP_NS.xml
    Save XML To File    ${response}    xmls//response    CNOD_PTP_NS_Response
    copy file  xmls//response//CNOD_PTP_NS_Response.xml  xmls//response//CNOD_PTP_NS_Response.txt

