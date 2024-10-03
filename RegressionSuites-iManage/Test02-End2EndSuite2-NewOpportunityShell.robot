*** Settings ***
Documentation     This suite file is to create an New opportunity with additional pursuit members and
...               validating the creation of team site and link existing approved ERAs.
...               Suite Flow:
...               * New Opp. Shell with Additional Pursuit Members
...               * Link/Unlink Approved ERA
...               * Link/Unlink SFDC ERA
...               * Add Additional Services to the created Shell
...               * Add Revenue Schedule to the Primary and Additional Services
...               * Validate Oportunity creation in SFDC
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot

*** Variables ***
${Salesforce ERA}    Salesforce ERA
${NumberOfServices}    2
${Revenue Number Of Months}    8
${Contract_Form}    JAL
${Contract_Version}    Original
${HyperLink}      https://www.yahoo.com/
#${CreatedShellName_S2}    Test New Opportunity 1598865914

*** Test Cases ***
Save Draft Shell with Missing Data - Account/Client & Validate Assistant is Inactive
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${DraftShellName_S2}    ${draft_Data_dict_S2}    Create a Draft New Shell    ${iManage_Shell_Data}    TC354
    Set Suite variable    ${DraftShellName_S2}
    Set Suite variable    ${draft_Data_dict_S2}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-INCOMPLETE SHELL}
    Validate assistant is inactive    ${draft_Data_dict_S2}
    Click Element    ${SHELL FILTER Link}

New opportunity is created with Additional Pursuit Members
    [Documentation]    Azure TC-18441
    [Tags]    Regression
    Open Shell From Filter List    ${DraftShellName_S2}
    ${CreatedShellName_S2}    Complete New Shell creation from Draft    ${iManage_Shell_Data}    TC106a    ${draft_Data_dict_S2}
    Set Suite variable    ${CreatedShellName_S2}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}

Validate Approved ERA is linked successfully
    [Documentation]    Azure TC-18578
    [Tags]    Regression
    ${ApprovedERAName}    Link Approved ERA
    Log To Console    ${ApprovedERAName}
    ERA Checklist should be checked on Opportunity Shell
    ERA is successfully linked to the Shell in Assistant    ${ASSIST ERA Link}    ${ApprovedERAName}
    Click Element    ${SHELL FILTER Link}

Validate locking Rule for Client/Account for Standalone Shell + Linked Approved ERA
    [Documentation]    Azure TC ID-20686
    [Tags]    Regression
    Open Shell From Filter List    ${CreatedShellName_S2}
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    ${ErrorMsg_ApprovedERA}    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child1"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child1"]}

Validate User is able to unlink the Approved ERA from Assistant
    [Documentation]    Azure TC ID-
    [Tags]    Regression
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Unlink ERA
    Sleep    5s
    Wait Until Element Is Visible    ${HAMBURGER Btn}
    ERA Checklist should be unchecked on Opportunity Shell

Validate SFDC ERA is linked successfully
    [Documentation]    Azure TC-18408
    [Tags]    Regression
    Link SFDC ERA    ${SFDC-ERA-URL-DEV}    ${SFDC-ERA-URL-QA}
    ERA Checklist should be checked on Opportunity Shell
    ERA is successfully linked to the Shell in Assistant    ${ASSIST ERA Link}    ${Salesforce ERA}
    Click Element    ${SHELL FILTER Link}

Validate locking Rule for Client/Account for Standalone Shell + Linked SFDC ERA
    [Documentation]    Azure TC ID-20684
    [Tags]    Regression
    Open Shell From Filter List    ${CreatedShellName_S2}
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    ${ErrorMsg_SFDC_ERA}    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child2"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child2"]}

Validate User is able to unlink the SFDC ERA from Assistant
    [Documentation]    Azure TC ID-
    [Tags]    Regression
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Unlink ERA
    Sleep    5s
    Wait Until Element Is Visible    ${HAMBURGER Btn}    30s
    ERA Checklist should be unchecked on Opportunity Shell
    Click Element    ${SHELL FILTER Link}

Open Existing Shell and validate Opportunity is created in SFDC
    [Documentation]    Azure TC-
    [Tags]    Regression
    Wait Until Page Contains Element    ${CREATE NEW SHELL Btn}
    Open Shell From Filter List    ${CreatedShellName_S2}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SFDC LINK}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${Checked Salesforce opportunity created}

Create Multiple iManage Change Orders
    [Tags]    Regression
    @{ChangeOrderList}=    Create List
    ${ChangeOrderNew}=    iManage Change Order Creation    ${iManage_Shell_Data}    TC106a    TC108b    ${CreatedShellName_S2}
    Append To List    ${ChangeOrderList}    ${ChangeOrderNew}
    ${ChangeOrderNew}=    iManage Change Order Creation    ${iManage_Shell_Data}    TC106a    TC108a    ${CreatedShellName_S2}
    Append To List    ${ChangeOrderList}    ${ChangeOrderNew}
    Set Suite Variable    ${ChangeOrderList}
    Log To Console    ${ChangeOrderList}
    Click Element    ${SHELL FILTER Link}

Add Additional Services to the shell
    [Documentation]    Azure TC-18567
    [Tags]    Regression
    Open Shell From Filter List    ${CreatedShellName_S2}
    Add Services to the Created Shell    ${NumberOfServices}
    Click Element    ${SHELL FILTER Link}
    Teardown

Add Revenue Schedule to the Primary and Additional Services
    [Documentation]    Azure TC- 18567 [Add Revenue Schedule to primary Service]
    [Tags]    Regression
    Setup
    Sleep    3s
    Login to existing Shell
    Open Shell From Filter List    ${CreatedShellName_S2}
    Wait Until page Contains Element    ${Revenue Schedule Link}
    Add Revenue Schedule To All Services    ${Revenue Number Of Months}
    Click Element    ${SHELL FILTER Link}
    Open Shell From Filter List    ${CreatedShellName_S2}
    Validate Revenue Schedule is added successfully

Validate CO Opportunity is created successfully and Close Change Order Opportunity with Closed-Won
    [Tags]    Regression
    From Main Shell Navigate to Change Order    ${ChangeOrderList[0]}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SFDC LINK}
    ${OppurtunityCreated}=    Run Keyword And Return Status    Element Should Be Visible    ${CO OPPORTUNITY STATUS BAR}${CO OPPORTUNITY STATUS-SUCCESS CREATION}
    ${CO_dict}=    Get Shell Test Data and Element Locators    ${iManage_Shell_Data}    TC108a
    log    ${CO_dict}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Close Opportunity    ${CO_dict["Closed Stage"]}    ${CO_dict["PrimaryReason"]}    ${CO_dict["Proposal Used"]}
    ...    ELSE    Log    Opportunity can't be closed as it's not created yet!

Close ChangeOrder Opportunity with Close-Protiviti Declined
    [Tags]    Regression
    From Main Shell Navigate to Change Order    ${ChangeOrderList[1]}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SFDC LINK}
    ${OppurtunityCreated}=    Run Keyword And Return Status    Element Should Be Visible    ${CO OPPORTUNITY STATUS BAR}${CO OPPORTUNITY STATUS-SUCCESS CREATION}
    ${CO_dict}=    Get Shell Test Data and Element Locators    ${iManage_Shell_Data}    TC108b
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Close Opportunity    ${CO_dict["Closed Stage"]}    ${CO_dict["PrimaryReason"]}
    ...    ELSE    Log    Opportunity can't be closed as it's not created yet!
    Teardown

Create a Sub-budget from iBudget with Exceptions and Employee Labor/Expenses Details
    [Tags]    Regression
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait until Page Contains Element    ${BUDGETS TILE Link}    30s
    Click Element    ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name}=    Complete Sub-Budget Form    ${iBudget_sub_Data}    TC110
    Set Suite Variable    ${sub-budget Name}
    Log    ${budget_dict}
    Log    ${sub-budget Name}
    Add Labor & Expenses Details    ${budget_dict}
    Run Keyword If    '${budget_dict["OFC"]}' != ''    Add Other fees And Charges on sub-Budget    ${budget_dict}
    Log    ${iBudget_Calculation}

Calculate And verify calculations on Consolidated Budget Tabs
    [Tags]    Regression
    Validate Consolidated Budget Tab And Calculate Total Net Fees
    Log    ${iBudget_Calculation}

Link the sub-budget from Main
    [Tags]    Regression
    Click Element    ${iBudget Top Navigation Button}
    Open Budget from Filter-List    ${CreatedShellName_S2}
    Link sub-budget to Main from Main    ${sub-budget Name}
    Wait Until Element Is Visible    //input[@value= '${CreatedShellName_S2}']
    Run Keyword And Continue On Failure    Page Should Contain Element    //table[@id= 'GridView']//td[@title= '${sub-budget_Name}']

Change Main/sub Project Code & add contract link
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${ibudget New budget Link}    30s
    ${Main_Pcode}=    Update Main Project Number    ${shell_dict["BU"]}
    Add Contracts details on Main    ${Contract_Form}    ${Contract_Version}    ${HyperLink}
    Open sub-Budget Linked to Main    ${sub-budget Name}
    Update sub-Budget Project Number    ${Main_Pcode}

Validate sub-budget is in FSC Approved State & then Activate it
    Sub-Budget activation Workflow    ${budget_dict}
    Universal Activation    ${budget_dict}

Validate calculated values on Activated sub
    Fetch Consolidated Calculated Values on Activated sub-budget    ${iBudget_Calculation}

Re-estimate Sub-budget with updated Contract Rates & Labor Exceptions
    Click Element    ${iBudget Top Navigation Button}
    Wait Until Element Is Visible    ${ibudget project description input}    30s
    Open Budget from Filter-List    ${sub-budget Name}
    Validate Budget is Activated And Ready for re-estimation
    ${estimated_budget_dict}=    Update Revised Basic Budget Information on BasicInfo Page    ${IBUDGET_RE-ESTIMATION_DATA}    TC102

Re-estimate Labor & Expense details on sub-budget
    Add Revised Labor/Expenses details    ${estimated_budget_dict}
    Run Keyword If    '${estimated_budget_dict["OFC"]}'!=''    Add/Edit Revised Other fees And Charges on sub-Budget    ${estimated_budget_dict}

Validate Re-estimate Calculations on Consolidated Budget Tab
    ${val}=    iBudgetCalculations.remove_unwanted    ${Resource_List}
    ${df}=    iBudgetCalculations.replaceNan
    ${val}=    iBudgetCalculations.dataframe_tocsv    dfBeforeCalculationsSuite2.csv
    ${df}=    iBudgetCalculations.calculate_values
    ${val}=    iBudgetCalculations.validate_calculations
    ${val}=    iBudgetCalculations.dataframe_tocsv    dfAfterCalculationsSuite2.csv

*** Keywords ***
