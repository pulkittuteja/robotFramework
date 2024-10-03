*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***
${ShellDataNum}         TC102

*** Test Cases ***
TC001 - Assistant on New Complete Shell
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    ${ShellDataNum}
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    New Opportunity Setup Form    ${shell_dict}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${shell_dict["Opp/EngName"]}']
    Expand Assistant Section    ${ASSIST ACCOUNT/CLIENT Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST SALESFORCE ACCOUNT Link}
    Expand Assistant Section    ${ASSIST COLLABORATION Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST COLLABORATION Link}/following-sibling::ul${ASSIST TEAMS SITE Link}
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST SALESFORCE Opportunity Link}
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA CREATE img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA LINK img}
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET CREATE img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET COPY img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET LINK img}

*** Keywords ***