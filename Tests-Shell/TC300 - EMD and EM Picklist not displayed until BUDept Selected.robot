*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell    ERA    Assistant
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC300 - EMD and EM Picklist not displayed until BU/Dept Selected
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Run Keyword If    '${ENV.upper()}' == 'DEV'    Click Button    ${OPP LINK EXISTING btn}
    Field Should Be Disabled    ${LEAD EMD Input}
    Field Should Be Disabled    ${LEAD EM Input}
    Shell Select BU/Department    200    10470
    Field Should Be Enabled    ${LEAD EMD Input}
    Field Should Be Enabled    ${LEAD EM Input}

*** Keywords ***
