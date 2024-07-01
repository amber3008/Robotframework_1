*** Settings ***
Documentation     Create Old Arch Orders in OCX and OMX
Library           Collections
Library           SoapLibrary
Library           OperatingSystem
Library           RequestsLibrary
Library           JSONLibrary
Library           XML
Library           ${CURDIR}${/}..\\Libraries\\com.amdocs.automation.base\\UpdateXml.py
Variables         ../Config/config.yaml

*** Variables ***



*** Test Cases ***
Retreive Data from YAML File
        Log to Console      Retrieve typeOfOrder from yaml file     ${typeOfOrder}