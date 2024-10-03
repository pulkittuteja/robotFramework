*** Settings ***
Documentation     Sandbox suite
Suite Setup       Run Keywords    Setup    Request Suite Setup    Setup Suite
Suite Teardown    Teardown    #Test Teardown    Test Teardown
Force Tags        DoNotRun
Resource          ..\\resource.robot
Resource          ..\\Keyword_Library_Shell_Requests.robot
Resource          ..\\Keyword_Library_ERA_Requests.robot
Resource          ..\\Keyword_Library_iBudget.robot

*** Variables ***
${DRB_SHELL_DATA}    ${CURDIR}\\..\\Data\\DRB_Shell_request_data.csv
${DRB_ERA_DATA}    ${CURDIR}\\..\\Data\\DRB_ERA_request_questions_data.csv

*** Test Cases ***
Data Seed DRB
    ${TC}=    Get TC Numbers    ${DRB_SHELL_DATA}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    Create Session    ERA    ${ENV_ERA_URL}/api    headers=${ERA_HEADERS}    verify=True
    : FOR    ${i}    IN    @{TC}
    \    Log    ${i}
    \    ${shell_data}=    Get Data From CSV File    ${DRB_SHELL_DATA}    ${i}
    \    ${era_data}=    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Get Data From CSV File    ${DRB_ERA_DATA}    ${shell_data["ERANUM"]}
    \    ${shell_data}=    Create iManage Engagement Shell    ${shell_data}
    \    ${era_data}=    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Create iManage ERA    ${era_data}    ${shell_data}
    \    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Update Part 1 & 2 questions    ${era_data}
    \    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Approve ERA    ${era_data}

*** Keywords ***
