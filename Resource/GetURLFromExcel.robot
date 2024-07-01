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
Library           ExcelLibrary


*** Variables ***
${strColCount}      ${null}
${strRowCount}      ${null}
${rowIndex}         ${null}
${colIndex}         ${null}


*** Keyword ***

Get data from excel
    [Arguments]     ${reqName}      ${envName}
    Open Excel	      Resource/URLs.xls
    # Reading No of Columns in Excel Sheet
    ${strColCount}=     Get Column Count       URLs
    # Reading number of Rows in Excel Sheet
    ${strRowCount} =    Get Row Count          URLs
    FOR    ${rowIndex}     IN RANGE    1    ${strRowCount}
            ${strTempColValue}=  Read Cell Data By Coordinates   URLs    0   ${rowIndex}
            IF    "${strTempColValue}" == "${envName}"
                    ${rowValue}      Set Variable   ${rowIndex}
            END
    END
    FOR    ${colIndex}     IN RANGE    1    ${strColCount}
            ${strTempRowValue}=  Read Cell Data By Coordinates   URLs    ${colIndex}   0
            IF    "${strTempRowValue}" == "${reqName}"
                    ${colValue}      Set Variable   ${colIndex}
            END
    END

    [Return]    ${rowValue}    ${colValue}