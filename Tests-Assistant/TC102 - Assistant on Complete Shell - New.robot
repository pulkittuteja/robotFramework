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
TC102 - Assistant on Complete Shell - New
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
    # Opportunity is currently showing the no opportunity text when it should be the link.. will change again after integration is completed
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST OPPORTUNITY CREATION TEXT}
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA CREATE img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA LINK img}
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST BUDGET CREATION TEXT}
    # Create teams icon shows but no "Teams Site creation in process" text anymore? - will need to confirm and fix if necessary
    Expand Assistant Section    ${ASSIST COLLABORATION Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST COLLABORATION Link}/following-sibling::ul${ASSIST COLLABORATION CREATION TEXT}
    Expand Assistant Section  ${ASSIST PKIC REQUEST Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST CDR CREATE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST PKIC CREATE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST VIEW PKIC Link}
*** Keywords ***