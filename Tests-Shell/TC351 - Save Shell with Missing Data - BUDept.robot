*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC351 - Save Shell with Missing Data - BUDept
    [Tags]    Regression    error
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC351
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Shell Setup Form    ${shell_dict}
    Wait Until Page Contains Element    ${SHELL BOTTOM ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${SHELL BOTTOM ERROR MSG Label}    ${shell_dict["onsrceen_msg"]}

*** Keywords ***
