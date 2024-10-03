*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC101 - Create Draft Shell with Minimum required data
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as MINE
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC101
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${DELETE DRAFT Btn}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${MANAGE PURSUIT button}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${HAMBURGER Btn}
    New Opportunity Setup Form    ${shell_dict}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    Run Keyword And Continue On Failure    Element Should Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${DELETE DRAFT Btn}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${MANAGE PURSUIT button}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${HAMBURGER Btn}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${shell_dict["Opp/EngName"]}']
    Expand Assistant Section    ${ASSIST ACCOUNT/CLIENT Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST MESSAGE text}
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST MESSAGE text}
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST MESSAGE text}
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST MESSAGE text}
    Sleep    3s

*** Keywords ***
