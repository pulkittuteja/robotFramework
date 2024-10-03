*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Setup        Import Roles
Test Teardown     Test Teardown
Force Tags        ITPRO    debug    ERA
Resource          resource.robot

*** Variables ***
${ROLES}          ${CURDIR}\\Data\\Roles.csv

*** Test Cases ***
SANDBOX
    [Tags]    sandbox
    New Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC001
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save Button
    Validate Assistant ERA
    Sleep    5s

*** Keywords ***
Validate Assistant ERA
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
