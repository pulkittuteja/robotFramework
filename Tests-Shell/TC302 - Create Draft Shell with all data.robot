*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC302 - Create Draft Shell with all data
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC302
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${DELETE DRAFT Btn}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${HAMBURGER Btn}
    Shell Setup Form    ${shell_dict}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    Run Keyword And Continue On Failure    Element Should Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${DELETE DRAFT Btn}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${HAMBURGER Btn}
    Sleep    3s

*** Keywords ***
