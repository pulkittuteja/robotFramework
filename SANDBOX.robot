*** Settings ***
Documentation     Sandbox suite
Force Tags        DoNotRun
Resource          resource.robot
Resource          Keyword_Library_Shell_Requests.robot

*** Variables ***
${shell_uri}      /api
${cookie_loc}     ${CURDIR}\\Data
${YE_SHELL_DATA}    ${CURDIR}\\Data\\Yr_End_ Data_Shell_request_data.csv
${DRB_SHELL_DATA}    ${CURDIR}\\Data\\DRB_Shell_request_data.csv

*** Test Cases ***
Get TC Numbers
    ${TC}=    Get TC Numbers    ${YE_SHELL_DATA}
    Log    ${TC}

Get Data From CSV
    #${APPROVERS}=    Get Data From CSV File    ${APPRV_DATA}
    ${APPROVERS}=    Get Data From CSV File    ${APPRV_DATA}    apprv01

Create Cookie File
    Request Suite Setup

Cookie
    Set Environment Variable    ERA COOKIE    ABCDE

Cookie2
    ${g}=    Get Environment Variable    ERA COOKIE

*** Keywords ***
Get TC Numbers
    [Arguments]    ${datafile}
    Set Log Level    NONE
    ${list}=    Create List
    ${data}=    Read Csv As List    ${datafile}    ,
    : FOR    ${i}    IN    @{data}
    \    ${v}=    Get From List    ${i}    0
    \    Append To List    ${list}    ${v}
    Remove From List    ${list}    0
    [Return]    ${list}

Request Suite Setup1
    ${ec}=    Run Keyword And Ignore Error    Get File    ${cookie_loc}\\ERA_COOKIE.txt
    ${sc}=    Run Keyword And Ignore Error    Get File    ${cookie_loc}\\SHELL_COOKIE.txt
    Run Keyword If    '${ec[0]}'=='FAIL' or '${sc[0]}'=='FAIL'    Create File    path=${cookie_loc}\\ERA_COOKIE.txt    content=''

Get Cookie Info
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${COOKIES}=    Get Cookies
    Set Global Variable    ${COOKIES}
    ${HEADERS}=    Create Headers Dict    ${COOKIES}
    Set Global Variable    ${HEADERS}
    Go To    ${ENV_ERA_URL}
    ${ERA_COOKIES}=    Get Cookies
    Set Global Variable    ${ERA_COOKIES}
    ${ERA_HEADERS}=    Create Headers Dict    ${ERA_COOKIES}
    Set Global Variable    ${ERA_HEADERS}
