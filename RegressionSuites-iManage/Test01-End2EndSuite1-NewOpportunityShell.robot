*** Settings ***
Documentation     This suite file is to validate the New Draft ERA and it's data
...               along with Expected UI functionality with added ERA
...               Suite Flow:
...               * New Shell creation
...               * Validate Assistant
...               * ERA creation in Draft Status
...               * ERA in EMD Review Status
...               * ERA in Approved status
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot
Resource          ..\\Keyword_Library_Assistant.robot
Resource          ..\\Keyword_Library_Shell.robot

*** Variables ***
${Contract_Form}    JAL
${Contract_Version}    Original
${HyperLink}      https://www.yahoo.com/

*** Test Cases ***
Create draft Shell with mandatory fields and validate Assistant is inactive
    [Documentation]    Azure TC ID-
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${DraftShellName_S1}    ${draft_Data_dict_S1}    Create a Draft New Shell    ${iManage_Shell_Data}    TC101
    Set Suite variable    ${DraftShellName_S1}
    Set Suite variable    ${draft_Data_dict_S1}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-INCOMPLETE SHELL}
    Validate assistant is inactive    ${draft_Data_dict_S1}
    Click Element    ${SHELL FILTER Link}

Shell is created successfully with all fields
    [Documentation]    Azure TC ID- 18181
    [Tags]    Regression    Smoke
    Open Shell From Filter List    ${DraftShellName_S1}
    ${CreatedShellName_S1}    Complete New Shell creation from Draft    ${iManage_Shell_Data}    TC102    ${draft_Data_dict_S1}
    Set Suite variable    ${CreatedShellName_S1}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}

Validate Assistant Fields on created shell
    [Documentation]    Continuation Azure TC ID- 18181
    [Tags]    Regression    Smoke
    Sleep    5s
    Open iManage Assistant
    Validate Default Fields on Assistant for Proposed Opportunity Stage
    Click Element    ${SHELL FILTER Link}

Validate locking Rule for Client/Account for Standalone Shell
    [Documentation]    Azure TC ID-20641
    [Tags]    Regression
    Open Shell From Filter List    ${CreatedShellName_S1}
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    Form Saved    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child1"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child1"]}

ERA created from New Opp Shell Assistant in Draft Status
    [Documentation]    Azure TC ID- 18338
    [Tags]    Regression    Smoke
    Open iManage Assistant
    Sleep    5s
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    Create an ERA via Shell    ${era_data}    TC001
    Validate Fields are copied from Shell to ERA    ${shell_dict["Child1"]}    ${shell_dict["Child1_ClientID"]}
    Navigate to iManage Shell Page
    Open Shell From Filter List    ${CreatedShellName_S1}
    ERA is successfully linked to the Shell in Assistant    ${ASSIST ERA Link}    ${ERA NAME}
    Click Element    ${SHELL FILTER Link}

Validate locking Rule for Client/Account for Standalone Shell + Draft ERA
    [Documentation]    Azure TC ID-20642
    [Tags]    Regression
    Open Shell From Filter List    ${CreatedShellName_S1}
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    Form Saved    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child2"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child2"]}

ERA created from New Opp Shell Asssitant in EMD Review Status
    [Documentation]    Azure TC ID- 18339
    [Tags]    Regression
    From Shell Navigate to ${ASSIST ERA Link} further to ${ERA NAME}
    ERA with completed Part-1 and Part-2    ${era_data}    TC002
    Summary Section FRAR when selected as Normal
    Submit the ERA for Approval
    Validate ERA is in EMD Awaiting Approval Tab    Normal

ERA created from New Opp Shell Asssitant in Approved Status
    [Documentation]    Azure TC ID- 18341
    [Tags]    Regression
    Open ERA From Filter List    ${ERA NAME}    Normal
    Navigate To ERA Approval Link from filter-list
    Approve ERA    ${ERA_dict}    Yes
    Validate ERA is in Approved ERA Tab    Normal
    Navigate to iManage Shell Page
    Open Shell From Filter List    ${CreatedShellName_S1}
    ERA Checklist should be checked on Opportunity Shell

Validate locking Rule for Client/Account for Standalone Shell + Approved Normal Rating ERA
    [Documentation]    Azure TC ID-20683
    [Tags]    Regression
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    ${ErrorMsg_ApprovedERA}    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child1"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child1"]}

Validate Opportunity is created successfully in SFDC
    [Documentation]    Azure TC-
    [Tags]    Regression
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${OPPORTUNITY STATUS-SFDC LINK}
    Run Keyword and Continue On Failure    Page Should Contain Element    ${Checked Salesforce opportunity created}

Validate Assistant on Shell Filter-list
    [Tags]    Regression
    Click Element    ${SHELL FILTER Link}
    Open Assistant and check Attached Parameters    ${CreatedShellName_S1}

Close Opportunity with Closed-Won
    [Tags]    Regression
    sleep    10s
    Click Element    //a[span[@title='${CreatedShellName_S1}']]
    Wait Until Page Contains Element    //span[@id='shellname']
    ${OppurtunityCreated}=    Run Keyword And Return Status    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Close Opportunity    ${shell_dict["Closed Stage"]}    ${shell_dict["PrimaryReason"]}    ${shell_dict["Proposal Used"]}
    ...    ELSE    Log    Opportunity can't be closed as it's not created yet!
    Teardown

Create a Sub-budget from iBudget with no Exceptions
    [Tags]    Regression
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait until Page Contains Element    ${BUDGETS TILE Link}    30s
    Click Element    ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name}=    Complete Sub-Budget Form    ${iBudget_sub_Data}    TC103
    Set Suite Variable    ${sub-budget Name}
    Log    ${budget_dict}
    Log    ${sub-budget Name}

Add Employee Labor & Expenses/Other Fees to the Sub-budget
    [Tags]    Regression
    Add Labor & Expenses Details    ${budget_dict}
    Run Keyword If    '${budget_dict["OFC"]}' != ''    Add Other fees And Charges on sub-Budget    ${budget_dict}
    Log    ${iBudget_Calculation}

Calculate And verify Global Net values on Consolidated Budget Tabs
    [Tags]    Regression
    Validate Consolidated Budget Tab And Calculate Total Net Fees
    Log    ${iBudget_Calculation}

Link the sub-budget to Main from iBudget & validate in Assistant
    [Tags]    Regression
    Link sub-budget to Main from sub-Budget    ${CreatedShellName_S1}    ${sub-budget Name}
    Click Element    ${IBudget-IManage Link}
    Wait Until Element Is Visible    ${MY OPP&ENGAGE TILE Link}
    Click Element    ${MY OPP&ENGAGE TILE Link}
    Open Shell From Filter List    ${CreatedShellName_S1}
    Scroll Element Into View    ${Shell Save Button}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST BUDGETS Link}

Change Main/sub Project Code & add contract link
    Click Element    ${ASSIST BUDGETS Link}/following-sibling::ul//a[contains(normalize-space(.), '${CreatedShellName_S1}')]
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${ibudget New budget Link}    30s
    ${Main_Pcode}=    Update Main Project Number    ${shell_dict["BU"]}
    Add Contracts details on Main    ${Contract_Form}    ${Contract_Version}    ${HyperLink}
    Open sub-Budget Linked to Main    ${sub-budget Name}
    Update sub-Budget Project Number    ${Main_Pcode}

Validate sub-budget is in EM-Submitted State & then Activate it
    Sub-Budget activation Workflow    ${budget_dict}
    Universal Activation    ${budget_dict}

Validate calculated values on Activated sub
    Fetch Consolidated Calculated Values on Activated sub-budget    ${iBudget_Calculation}

Re-estimate Sub-budget with updated Contract Rates & no Exceptions
    Click Element    ${iBudget Top Navigation Button}
    Wait Until Element Is Visible    ${ibudget project description input}    30s
    Open Budget from Filter-List    ${sub-budget Name}
    Validate Budget is Activated And Ready for re-estimation
    ${estimated_budget_dict}=    Update Revised Basic Budget Information on BasicInfo Page    ${IBUDGET_RE-ESTIMATION_DATA}    TC105

Re-estimate Labor & Expense details on sub-budget
    Add Revised Labor/Expenses details    ${estimated_budget_dict}
    Run Keyword If    '${estimated_budget_dict["OFC"]}'!=''    Add/Edit Revised Other fees And Charges on sub-Budget    ${estimated_budget_dict}

Validate Re-estimate Calculations on Consolidated Budget Tab
    ${val}=    iBudgetCalculations.remove_unwanted    ${Resource_List}
    ${df}=    iBudgetCalculations.replaceNan
    ${val}=    iBudgetCalculations.dataframe_tocsv    dfBeforeCalculationsSuite1.csv
    ${df}=    iBudgetCalculations.calculate_values
    ${val}=    iBudgetCalculations.validate_calculations
    ${val}=    iBudgetCalculations.dataframe_tocsv    dfAfterCalculationsSuite1.csv

Set Final Stage of sub-budget & create output dictionary

*** Keywords ***
Validate Fields are copied from Shell to ERA
    [Arguments]    ${Client}    ${ClientID}
    Set Log Level    NONE
    Run Keyword And Ignore Error    Element Should be Visible    //*[@ng-reflect-model= '${Client}']
    Run Keyword And Ignore Error    Element Should be Visible    //*[@ng-reflect-model= '${ClientID}']
    Run Keyword And Continue On Failure    Element Should be Visible    //*[@ng-reflect-model= '${shell_dict["OppMD"]}']
    Run Keyword And Continue On Failure    Element Should be Visible    //*[@ng-reflect-model= '${shell_dict["OppOwner"]}']
    Set Log Level    INFO

Login For ERA
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click ERA Tile
    Wait Until Element Is Visible    (//span[contains(normalize-space(.), '${CreatedERA}')])    30s
    Click Element    (//span[contains(normalize-space(.), '${CreatedERA}')])

Login for Awaiting Approved ERA
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click ERA Tile
    Wait Until Element Is Visible    //tr[@aria-rowindex= '1']
    Click Element    ${ERA AWAITING APPROVE Btn}
    Run Keyword And Continue On Failure    Wait Until Page Contains element    //span[contains(normalize-space(.), '${CreatedERA}')]
