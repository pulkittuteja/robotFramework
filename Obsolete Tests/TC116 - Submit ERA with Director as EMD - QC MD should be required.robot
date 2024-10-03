*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    ERA
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
# Obsolete because users are carried over from Shell
TC116 - Submit ERA with Director as EMD - QC MD should be required - Obsolete
    Comment     Obsolete because users are carried over from Shell
    [Tags]    Regression    error
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC116
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
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE

*** Keywords ***
