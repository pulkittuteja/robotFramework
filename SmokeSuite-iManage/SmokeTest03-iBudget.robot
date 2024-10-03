*** Settings ***
Documentation    This suite file is to smoke test on sub-budgets and
...              add them to the Main Shell/Budget.
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
Create Shell from iBudget
    [Tags]    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait until Page Contains Element        ${BUDGETS TILE Link}        30s
    Click Element       ${BUDGETS TILE Link}
    Open New Shell From iBudget
    Sleep       5s
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${iManage_Shell_Data}    TC104a
    Set Global Variable    ${shell_dict}
    Check For Opp Button    ${shell_dict["existing"]}
    ${shell_dict_empty}=    Get Shell Test Data and Element Locators    ${iManage_Shell_Data}     TC000
    New Opportunity Setup Form    ${shell_dict}     ${shell_dict_empty}
    Click Element       ${IMANAGE HOME Link}

New Hourly Sub-Budget
    [Tags]      Smoke
    Run Keyword And Ignore Error        Click Element       ${IMANAGE HOME Link}
    Wait Until Page Contains Element        ${BUDGETS TILE Link}        30s
    Click Element        ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name1}=        Complete Sub-Budget Form        ${iBudget_sub_Data}        TC101
    Set Suite Variable      ${sub-budget Name1}

New Unit-Value Sub-Budget
    [Tags]      Smoke
    Open New Sub-Budget Form
    ${sub-budget Name2}=        Complete Sub-Budget Form        ${iBudget_sub_Data}        TC104
    Set Suite Variable      ${sub-budget Name2}

Link sub-Budgets to Main
    [Tags]      Smoke
    Link sub-budget to Main from sub-Budget        ${shell_dict["Opp/EngName"]}      ${sub-budget Name2}
    Click Element       ${sub-budget Main Link}
    Link sub-budget to Main from Main       ${sub-budget Name1}
    Wait Until Element Is Visible       //input[@value= '${shell_dict["Opp/EngName"]}']
    Run Keyword And Continue On Failure     Page Should Contain Element     //table[@id= 'GridView']//td[@title= '${sub-budget_Name1}']
