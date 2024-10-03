*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    DoNotRun
Resource          resource.robot

*** Variables ***

*** Test Cases ***
TC201 - Approve ERA - Normal
    [Tags]    Demo
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC025
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
    Click Button    ${SUBMIT TO EMD Button}
    Approve ERA    ${dict}

TC203 - Approve ERA - High
    [Tags]    Demo
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC203
    Set Suite Variable    ${data_dict}    ${dict}
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
    Click Button    ${SUBMIT TO EMD Button}
    Log User Out
    Login in as EMD
    Approve ERA as EMD
    Log User Out
    Login in as QRMMD
    Approve ERA as QRMMD
    Log User Out
    Login in as QCMD
    Approve ERA as QCMD
    Log User Out
    Login in as RMD
    Approve ERA as RMD
    Sleep    5s

*** Keywords ***
