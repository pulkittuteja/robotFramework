*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
#Manage permissions button not showing up
TC370 - Shell Remove Permissions Creator
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as GLMD
    ${shell_dict}=    Get Data From CSV File    ${shell_data}    TC370
    Set Shell Name Locators    ${shell_dict}
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Shell Setup Form    ${shell_dict}
    Sleep    1s
    Wait until page contains element    ${PERM MANAGE PERMISSIONS Btn}    10s
    Click Button    ${PERM MANAGE PERMISSIONS Btn}
    sleep    5s
    Wait until page contains element    //td[text()='${ACTIVEUSER}']/preceding-sibling::td/div/button    5s
    Click Element    //td[text()='${ACTIVEUSER}']/preceding-sibling::td/div/button
    Alert Should Be Present    ${PERM REMOVE USER ALERT Text}    timeout=30s
    Sleep    1s
    Page Should Contain Element    ${PERM REMOVE USER ERROR MSG}
    Sleep    3s

*** Keywords ***
