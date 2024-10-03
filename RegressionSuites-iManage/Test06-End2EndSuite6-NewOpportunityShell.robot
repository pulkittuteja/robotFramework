*** Settings ***
Documentation    This suite file is to link an existing Salesforce opportunity along with
...              new and existing ERAs.
...              Suite Flow:
...              * Link an existing Opp and validate Salesforce checklist is checked.
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot
Resource          ..\\Keyword_Library_Assistant.robot
Resource          ..\\Keyword_Library_Shell.robot

*** Variables ***
${text}         No Data Found

*** Test Cases ***
On Draft Shell Validate EMD and EM Picklist not displayed until BU/Dept Selected
    [Documentation]
    [Tags]       Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click My Opp and Engage Tile
    Sleep    3s
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Run Keyword If    '${ENV.upper()}' == 'TEST'    Click Button    ${OPP CREATE NEW btn}
    Field Should Be Disabled    ${OPP MD Input}
    Field Should Be Disabled    ${OPP OWNER Input}
    Shell Select BU/Department    200    10470
    Field Should Be Enabled    ${OPP MD Input}
    Field Should Be Enabled    ${OPP OWNER Input}

Create a new opportunity with Permission members
    [Documentation]         Azure TC ID-
    [Tags]    Regression
    Scroll Element Into View        ${IMANAGE HOME Link}
    Click Element       ${SHELL FILTER Link}
    Click Element       ${IMANAGE HOME Link}
    ${CreatedShellName_S6}     Create a New Shell     ${iManage_Shell_Data}    TC102
    Set Suite variable              ${CreatedShellName_S6}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Wait Until Element Is Visible           ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}
    Run Keyword And Continue On Failure     Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}
    Sleep       5s
    Run Keyword If    '${shell_dict["ManagePermUSERS"]}'!=''        Add Members From Manage Permission      ${shell_dict["ManagePermUSERS"]}
    ...     ELSE        Log     ${text}
    #Run Keyword If    '${shell_dict["ManagePermUSERS"]}'!=''        Delete Members From Manage Permission       ${shell_dict["ManagePermUSERS"]}
    Set Focus To Element        ${Shell Save Button}
    Click Button       ${Shell Save Button}

Create and verify a Standalone ERA
    [Documentation]         Azure TC ID-18421
    [Tags]    Regression
    Open iManage Assistant
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    Create an ERA via Shell        ${era_data}     TC001
    Navigate to iManage Shell Page
    Open Shell From Filter List          ${CreatedShellName_S6}
    ERA is successfully linked to the Shell in Assistant        ${ASSIST ERA Link}      ${ERA NAME}
    Unlink ERA
    Sleep       5s
    Wait Until Element Is Visible        ${HAMBURGER Btn}
    ERA Checklist should be unchecked on Opportunity Shell
    Click Element       ${IMANAGE HOME Link}
    Wait until Element Is Visible       ${ERA TILE Link}
    Click Element       ${ERA TILE Link}
    Open ERA From Filter List       ${ERA NAME}     Normal

Validate locking rule on Client/Acount Field for Standalone ERA in Draft Status
    [Documentation]         Azure TC ID-20627
    [Tags]    Regression
    Wait Until Element Is Visible           ${CLIENT NAME Input}        15s
    Sleep       5s
    User Selects Different Client name on ERA       ${shell_dict["Client Name2"]}        Form Saved
    User Selects Different Child Client Name on ERA     ${shell_dict["Client Name"]}       ${shell_dict["Child1"]}

Complete the Standalone ERA in EMD Review Status and validate locking rules on Client/Account Field
    [Documentation]         Azure TC ID-20628
    [Tags]    Regression
    ERA with completed Part-1 and Part-2            ${era_data}         TC002
    Summary Section FRAR when selected as Normal
    Submit the ERA for Approval
    Validate ERA is in EMD Awaiting Approval Tab        Normal
    Open ERA From Filter List       ${ERA NAME}     Normal
    Wait Until Element Is Visible           ${CLIENT NAME Input}        15s
    Sleep       5s
    User Selects Different Client name on ERA       ${shell_dict["Client Name2"]}        Form Saved
    User Selects Different Child Client Name on ERA     ${shell_dict["Client Name"]}       ${shell_dict["Child2"]}

Approve the Standalone ERA and validate locking rules on Client/Account Field
    [Documentation]         Azure TC ID-20707
    [Tags]    Regression
    Navigate To ERA Approval Link from filter-list
    Approve ERA         ${ERA_dict}     Yes
    Validate ERA is in Approved ERA Tab         Normal
    Open ERA From Filter List       ${ERA NAME}     Normal
    Wait Until Element Is Visible           ${CLIENT NAME Input}        15s
    Sleep       5s
    ${ClientId_Status}      Get Element Attribute       ${CLIENT NAME Input}        disabled
    Log To Console      ${ClientId_Status}
    Should Be Equal       '${ClientId_Status}'      'true'

Validate User is unable to edit fields on Approved Standalone ERA
    [Documentation]         Azure TC ID-
    [Tags]    Regression
    Field Should Be Disabled     ${ERA NAME Input}
    Field Should Be Disabled     ${CLIENT SIZE Select}
    Field Should Be Disabled     ${CLIENT LEGAL STRUCTURE Select}
    Field Should Be Disabled     ${ENGAGE DESCRIPT Textarea}
    Field Should Be Disabled     ${PCOUNTRY JOB CONTRACTED Select}
    Field Should Be Disabled     ${PCOUNTRY WORK PERFORMED Input}
    Field Should Be Disabled     ${EST NET FEES Select}
    Field Should Be Disabled     ${EST CONT MARGIN Input}
    Teardown

Update custom probability field and validate opportunity creation links to the Standalone shell
    [Documentation]         Azure TC ID-18479
    [Tags]    Regression
    Setup
    Login to existing Shell
    Wait Until Page Contains Element           ${CREATE NEW SHELL Btn}
    Open Shell From Filter List          ${CreatedShellName_S6}
    Wait Until Element Is Visible       ${Probability Custom}       5s
    ${prob default val}     Get Value        ${Probability Custom}
    Log      ${prob default val}
    ${count}        Get Length      ${prob default val}
    Log       ${count}
    Run Keyword If    """${prob default val}""" != ''
    ...     Repeat Keyword       ${count +1}        Press Key       ${Probability Custom}    \\08
    ${prob custom val}      Evaluate             ${prob default val}+10
    Input Text      ${Probability Custom}       ${prob custom val}
    Click Element       ${N SAVE Button}
    Run Keyword and Continue On Failure     Page Should Contain Element      ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword and Continue On Failure     Page Should Contain Element      ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SFDC LINK}
    Run Keyword and Continue On Failure     Page Should Contain Element      ${Checked Salesforce opportunity created}
    Run Keyword and Continue On Failure     Page Should Contain Element      ${Checked Primary Key Identifier}

Create iManage change order with different Department
    [Documentation]         Azure TC ID-18479
    [Tags]    Regression
    ${ChangeOrderNew}=        iManage Change Order Creation       ${iManage_Shell_Data}      TC102        TC108a        ${CreatedShellName_S6}
    Set Suite variable          ${ChangeOrderNew}
    Scroll Element Into View        ${CO OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure     Element Should Be Visible       ${CO OPPORTUNITY STATUS BAR}${CO OPPORTUNITY STATUS-CREATION TEXT}

Link Approved ERA and Validate Assistant on Change Order
    [Documentation]
    [Tags]      Regression
    ${ApprovedERAName}      Link Approved ERA
    ERA Checklist should be checked on Opportunity Shell
    From Main Shell Navigate to Change Order        ${ChangeOrderNew}
    Validate Assistant on Change Order      ${ApprovedERAName}      ${ChangeOrderNew}       ${CreatedShellName_S6}

Verify Account/Primary Key Buyer is updated successfully on Change Order when changed on Shell
    [Documentation]
    [Tags]      Regression
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Click Element           ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${CreatedShellName_S6}']
    Wait Until Page Contains Element        //span[contains(normalize-space(.), '${CreatedShellName_S6}') and contains(@id, 'shellname')]
    User Selects Different Child Client Name         ${shell_dict["Client Name"]}       ${shell_dict["Child1"]}          ${shell_dict["existing"]}      ${shell_dict["PKB_Child1"]}
    ${PKB Val}=    Get Element Attribute    ${Primary Key Buyer Input}        title
    From Main Shell Navigate to Change Order        ${ChangeOrderNew}
    Run Keyword And Continue On Failure     Element Should Be Visible       //input[@title="${PKB Val}"]
    Click Element       ${IMANAGE HOME Link}

Close Opportunity with Closed-Won Stage
    [Documentation]         Azure TC ID-18479
    [Tags]    Regression
    Click My Opp and Engage Tile
    Wait Until Page Contains Element           ${CREATE NEW SHELL Btn}
    Open Shell From Filter List          ${CreatedShellName_S6}
    Wait Until Page Contains Element        //span[contains(normalize-space(.), '${CreatedShellName_S6}') and contains(@id, 'shellname')]
    ${OppurtunityCreated}=      Run Keyword And Return Status       Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure     Run Keyword If      '${OppurtunityCreated}'=='True'      Close Opportunity      ${shell_dict["Closed Stage"]}       ${shell_dict["PrimaryReason"]}
    ...         ELSE        Log         Opportunity can't be closed as it's not created yet!
    Teardown

Create a Unit-Value Based sub-budget with Audjustment Discounts & BU200
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait Until Page Contains Element        ${BUDGETS TILE Link}        30s
    Click Element       ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name}=        Complete Sub-Budget Form        ${iBudget_sub_Data}        TC106
    Set Suite Variable      ${sub-budget Name}
    Log      ${budget_dict}
    Log      ${sub-budget Name}

Add Employee Labor/Expenses & Other fees to Unit-Value Rate Card type budget
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Add Labor & Expenses Details        ${budget_dict}
    Run Keyword If      '${budget_dict["OFC"]}' != ''         Add Other fees And Charges on sub-Budget        ${budget_dict}
    Validate Consolidated Budget Tab And Calculate Total Net Fees
    Log      ${iBudget_Calculation}

Create a Unit-Value Based sub-budget without Audjustment Discounts & BU300-CANADA
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Open New Sub-Budget Form
    ${sub-budget Name2}=        Complete Sub-Budget Form        ${iBudget_sub_Data}        TC104
    Set Suite Variable      ${sub-budget Name2}
    Log      ${budget_dict}
    Log      ${sub-budget Name2}

Add RH/IH Contractor Labor/Expenses Details to Unit-Value Rate Card type budget
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Add Labor & Expenses Details        ${budget_dict}
    Run Keyword If      '${budget_dict["OFC"]}' != ''         Add Other fees And Charges on sub-Budget        ${budget_dict}
    Validate Consolidated Budget Tab And Calculate Total Net Fees
    Log      ${iBudget_Calculation}

Link sub-budget to shell and verify only same BU budget is linked
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Click Element       ${IBudget-IManage Link}
    Click My Opp and Engage Tile
    Open Shell From Filter List        ${CreatedShellName_S6}
    ${Attached_Status}=     Link a sub-budget to Shell via Assistant        ${sub-budget Name}
    Wait Until Element Is Visible       //input[@value= '${CreatedShellName_S6}']
    Run Keyword If      '${Attached_Status}'=='Sub-Budget Attached'       Page Should Contain Element     //table[@id= 'GridView']//td[@title= '${sub-budget Name}']
    Click Element       ${IBudget-IManage Link}
    Click My Opp and Engage Tile
    Open Shell From Filter List        ${CreatedShellName_S6}
    ${Attached_Status}=     Link a sub-budget to Shell via Assistant        ${sub-budget Name2}
    Wait Until Element Is Visible       //input[@value= '${CreatedShellName_S6}']
    Run Keyword And Continue On Failure      Should Be Equal As Strings        ${Attached_Status}     Sub-Budget Not Found

EMD-Returned the sub-budget & then Activate it
    [Documentation]
    [Tags]      Regression
    Click Element       ${ASSIST BUDGETS Link}/following-sibling::ul//a[contains(normalize-space(.), '${CreatedShellName_S1}')]
    Run Keyword And Ignore Error        Wait Until Element Is Visible       ${ibudget New budget Link}      30s
    ${Main_Pcode}=       Update Main Project Number      ${shell_dict["BU"]}
    Add Contracts details on Main       ${Contract_Form}        ${Contract_Version}         ${HyperLink}
    Open sub-Budget Linked to Main      ${sub-budget Name}
    Update sub-Budget Project Number        ${Main_Pcode}
    Sub-Budget activation Workflow       ${budget_dict}
    Universal Activation         ${budget_dict}

Validate calculated values on Activated sub
    [Documentation]
    Fetch Consolidated Calculated Values on Activated sub-budget        ${iBudget_Calculation}

Re-estimate Unit-Value Sub-budget with updated Rates
    [Documentation]
    Click Element       ${iBudget Top Navigation Button}
    Wait Until Element Is Visible       ${ibudget project description input}      30s
    Open Budget from Filter-List        	 ${sub-budget Name}
    Validate Budget is Activated And Ready for re-estimation
    ${estimated_budget_dict}=        Update Revised Basic Budget Information on BasicInfo Page       ${IBUDGET_RE-ESTIMATION_DATA}       TC106

Re-estimate Labor & Expense details on sub-budget
    [Documentation]
    Add Revised Labor/Expenses details       ${estimated_budget_dict}
    Run Keyword If      '${estimated_budget_dict["OFC"]}'!=''         Add/Edit Revised Other fees And Charges on sub-Budget        ${estimated_budget_dict}

Validate Re-estimate Calculations on Consolidated Budget Tab
    [Documentation]
    ${val}=     iBudgetCalculations.remove_unwanted      ${Resource_List}
    ${df}=      iBudgetCalculations.replaceNan
    ${val}=     iBudgetCalculations.dataframe_tocsv         dfBeforeCalculationsSuite6.csv
    ${df}=      iBudgetCalculations.calculate_values
    ${val}=     iBudgetCalculations.validate_calculations
    ${val}=     iBudgetCalculations.dataframe_tocsv         dfAfterCalculationsSuite6.csv
