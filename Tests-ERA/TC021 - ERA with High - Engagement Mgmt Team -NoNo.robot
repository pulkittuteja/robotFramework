*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    ERA
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC021 - ERA with High - Engagement Mgmt Team -NoNo
    [Tags]    Regression    Rating
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC021
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE Button}
    Sleep    2s

*** Keywords ***
