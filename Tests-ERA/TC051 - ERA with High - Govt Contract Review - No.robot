*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    ERA
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC051 - ERA with High - Govt Contract Review - No
    [Tags]    Regression    Rating
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC051
    Set ERA Approval Locators    #${dict}
    #Click ERA Tile
    #Click Button    ${CREATE NEW ERA Btn}
    Create Draft Shell With All Data        #Runs function to create Shell with TC102 data
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
