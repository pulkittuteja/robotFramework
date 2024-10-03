*** Settings ***
Documentation     This suite file is to create an opportunity with Different Currency
...               type as of selected BU and further to create multiple Change Orders
...               and High rated ERA.
...               Suite Flow:
...               * Create New Opp with Different Currency type and add multiple services
...               * Validate currency conversion for multiple services
...               * Create Draft ERA with Overall High Rating
...               * Approve High CRAR ERA
...               * Validate Opportunity is Created Successfully in SFDC and Change Order creation link is visible
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot

*** Variables ***
${Contract_Form}    JAL
${Contract_Version}    Original
${HyperLink}      https://www.yahoo.com/

*** Test Cases ***
Error Message on Draft Shell with Missing Mandatory Data
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    Validate Error Message on Shell with missing Fields    Name    ${iManage_Shell_Data}
    Validate Error Message on Shell with missing Fields    BU    ${iManage_Shell_Data}
    Validate Error Message on Shell with missing Fields    EMD    ${iManage_Shell_Data}
    Validate Error Message on Shell with missing Fields    EM    ${iManage_Shell_Data}

Create New Opp with Different Currency type and add multiple services
    [Documentation]    Azure TC-18432/18440
    [Tags]    Regression
    ${CreatedShellName_S4}    Create a New Shell    ${iManage_Shell_Data}    TC105b
    Set Suite variable    ${CreatedShellName_S4}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Sleep    2s
    Run Keyword And Continue On Failure    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}

Validate Opportunity and Base Currency conversion service amount
    [Documentation]    Azure TC-
    [Tags]    Regression
    ${cur_rates}=    Get Currency Rates
    Check for the conversion Service Amount Fields    ${cur_rates}    ${shell_dict["SerOffAmt"]}    ${shell_dict["ServiceOffLines"]}

Create ERA with Overall High Rating
    [Documentation]    Azure TC-18577
    [Tags]    Regression
    Open iManage Assistant
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    ERA with completed Part-1 and Part-2    ${era_data}    TC015
    Wait until Element is Visible    ${FRAR Select}
    ${FRAR Selected Value}=    Get Selected List Value    ${FRAR Select}
    Run Keyword And Continue On Failure    Should be equal as strings    ${FRAR Selected Value}    High

Validate for mandatory Field sections for selected FRAR and complete summary section
    [Documentation]    Azure TC-
    [Tags]    Regression
    Summary Section FRAR when selected as Increased
    Summary Section FRAR when selected as High
    Complete Summary Section    ${ERA_dict}
    Click Save and Next Button

Enter RMAP and QCMD details in created ERA for High CRAR
    [Documentation]    Azure TC-
    [Tags]    Regression
    Complete RMAP Section    ${ERA_dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${ERA_dict}
    Click Button    ${SAVE Button}
    Sleep    2s

Submit the ERA with High CRAR
    [Documentation]    Azure TC-
    [Tags]    Regression
    Submit the ERA for Approval
    Validate ERA is in EMD Awaiting Approval Tab    High
    Open ERA From Filter List    ${ERA NAME}    High
    Navigate To ERA Approval Link from filter-list
    Approve ERA    ${ERA_dict}    Yes

Validate locking Rule for Client/Account with Submitted High Rating ERA
    [Documentation]    Azure TC-20685
    [Tags]    Regression
    Navigate to iManage Shell Page
    Open Shell From Filter List    ${CreatedShellName_S4}
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    ${ErrorMsg_ApprovedERA}    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child1"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child1"]}

Approve the ERA with High CRAR
    [Documentation]    Azure TC-
    [Tags]    Regression
    From Shell Navigate to ${ASSIST ERA Link} further to ${ERA NAME}
    Navigate To ERA Approval Link from filter-list
    Submit the ERA for Approval
    Validate ERA is in EMD Awaiting Approval Tab    High
    Open ERA From Filter List    ${ERA NAME}    High
    Navigate To ERA Approval Link from filter-list
    Approve ERA    ${ERA_dict}    Yes

Validate Opportunity is created successfully in SFDC and Add Primary Key Buyer
    [Documentation]    Azure TC-
    [Tags]    Regression
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SFDC LINK}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${Checked Salesforce opportunity created}

Validate locking Rule for Client/Account with Approved High Rating ERA
    [Documentation]    Azure TC-20686
    [Tags]    Regression
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    ${ErrorMsg_ApprovedERA}    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child2"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child2"]}
    Teardown

Close Opportunity without Primary Reason & validate for the Error message
    [Tags]    Regression
    Setup
    Sleep    3s
    Login to existing Shell
    Open Shell From Filter List    ${CreatedShellName_S4}
    ${OppurtunityCreated}=    Run Keyword And Return Status    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Close Opportunity    ${shell_dict["Closed Stage"]}    ${shell_dict["PrimaryReason"]}
    ...    ELSE    Log    Opportunity can't be closed as it's not created yet!
    Click Element    ${IMANAGE HOME Link}

Create a Sub-budget from iBudget with Exceptions and Different Dept
    [Tags]    Regression
    Wait until Page Contains Element    ${BUDGETS TILE Link}    30s
    Click Element    ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name}=    Complete Sub-Budget Form    ${iBudget_sub_Data}    TC105
    Set Suite Variable    ${sub-budget Name}
    Log    ${budget_dict}
    Log    ${sub-budget Name}

Add RH/IH Contractor Labor Details And Validated Consolidated Budget Calculation
    [Tags]    Regression
    Add Labor & Expenses Details    ${budget_dict}
    Run Keyword If    '${budget_dict["OFC"]}' != ''    Add Other fees And Charges on sub-Budget    ${budget_dict}
    Log    ${iBudget_Calculation}
    Validate Consolidated Budget Tab And Calculate Total Net Fees
    Log    ${iBudget_Calculation}

Link created sub-budget to shell from Assistant
    [Tags]    Regression
    Click Element    ${IBudget-IManage Link}
    Click My Opp and Engage Tile
    Open Shell From Filter List    ${CreatedShellName_S4}
    ${Attached_Status}=    Link a sub-budget to Shell via Assistant    ${sub-budget Name}
    Wait Until Element Is Visible    //input[@value= '${CreatedShellName_S4}']
    Run Keyword If    '${Attached_Status}'=='Sub-Budget Attached'    Page Should Contain Element    //table[@id= 'GridView']//td[@title= '${sub-budget Name}']

Change Main/sub Project Code & add contract link
    Click Element    ${ASSIST BUDGETS Link}/following-sibling::ul//a[contains(normalize-space(.), '${CreatedShellName_S1}')]
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${ibudget New budget Link}    30s
    ${Main_Pcode}=    Update Main Project Number    ${shell_dict["BU"]}
    Add Contracts details on Main    ${Contract_Form}    ${Contract_Version}    ${HyperLink}
    Open sub-Budget Linked to Main    ${sub-budget Name}
    Update sub-Budget Project Number    ${Main_Pcode}

Validate sub-budget is in FSC-Returned State & then Activate it
    Sub-Budget activation Workflow    ${budget_dict}
    Universal Activation    ${budget_dict}

Validate calculated values on Activated sub
    Fetch Consolidated Calculated Values on Activated sub-budget    ${iBudget_Calculation}

Re-estimate Sub-budget with updated Contract Rates & MF/IBU Exceptions
    Click Element    ${iBudget Top Navigation Button}
    Wait Until Element Is Visible    ${ibudget project description input}    30s
    Open Budget from Filter-List    ${sub-budget Name}
    Validate Budget is Activated And Ready for re-estimation
    ${estimated_budget_dict}=    Update Revised Basic Budget Information on BasicInfo Page    ${IBUDGET_RE-ESTIMATION_DATA}    TC103

Re-estimate Labor & Expense details on sub-budget
    Add Revised Labor/Expenses details    ${estimated_budget_dict}
    Run Keyword If    '${estimated_budget_dict["OFC"]}'!=''    Add/Edit Revised Other fees And Charges on sub-Budget    ${estimated_budget_dict}

Validate Re-estimate Calculations on Consolidated Budget Tab
    ${val}=    iBudgetCalculations.remove_unwanted    ${Resource_List}
    ${df}=    iBudgetCalculations.replaceNan
    ${val}=    iBudgetCalculations.dataframe_tocsv    dfBeforeCalculationsSuite4.csv
    ${df}=    iBudgetCalculations.calculate_values
    ${val}=    iBudgetCalculations.validate_calculations
    ${val}=    iBudgetCalculations.dataframe_tocsv    dfAfterCalculationsSuite4.csv
