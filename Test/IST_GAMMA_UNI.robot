*** Settings ***
Documentation     To create GAMMA UNI Orders.
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           XML
Library           C://Users//amberb//PycharmProjects//Halo-Gamma//Libraries//com.amdocs.automation.base//UpdateXml.py


*** Variables ***
${a}     Y


*** Test Cases ***
Push CNOD Request
    updateXmlUni    ${a}
    Create Soap Client    http://zltv9973.vci.att.com:41400/ORDERING_PORTFOLIO/CustomerOrderEstablishment?wsdl
    ${response}    Call SOAP Method With XML    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//requests//CNOD_UNI_NS.xml
    Save XML To File    ${response}    C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response    CNOD_UNI_NS_Response
    copy file   C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//CNOD_UNI_NS_Response.xml  C://Users//amberb//PycharmProjects//Halo-Gamma//xmls//response//CNOD_UNI_NS_Response.txt




