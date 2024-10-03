*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***
${ShellDataNum}         TC101
${Existing Shell}       Test Draft Opportunity 1551739786
${Search Field}         xpath=((.//div[contains(., 'Closed')])[last()]/following::input[@type='text'])[2]

*** Test Cases ***
TC001 - Assistant on Draft Shell
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    ${ShellDataNum}
    Click My Opp and Engage Tile
    Click Element    ${Search Field}
    Input Text       ${Search Field}    ${Existing Shell}
    Click Element       //a[span[text()='Test Draft Opportunity 1551739786']]
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${shell_dict["Opp/EngName"]}']
    Expand Assistant Section    ${ASSIST ACCOUNT/CLIENT Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST NO ACCOUNT/CLIENT TEXT}
    Expand Assistant Section    ${ASSIST COLLABORATION Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST COLLABORATION Link}/following-sibling::ul${ASSIST NO COLLABORATION TEXT}
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST NO OPPORTUNITY TEXT}
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST NO ERA TEXT}
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST NO SUB BUDGET TEXT}

*** Keywords ***