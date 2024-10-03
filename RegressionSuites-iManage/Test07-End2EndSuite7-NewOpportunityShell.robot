*** Settings ***
Documentation    This suite file is to create new draft opportunity and validate Primary
...              Key buyer content along with Assistant& ERAs.
...              Suite Flow:
...              * Create draft Opportunity and validate Assistant is not activated.
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
Create Draft Shell and validate Error Message when Non-mandatory fields left blank
    [Documentation]     Azure TC -
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${DraftShellName_S7}     ${draft_Data_dict_S7}     Create a Draft New Shell     ${iManage_Shell_Data}    TC103a
    Set Suite variable              ${DraftShellName_S7}
    Set Suite variable              ${draft_Data_dict_S7}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Sleep       5s
    Run Keyword And Continue On Failure      Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-INCOMPLETE SHELL}
    Run Keyword And Continue On Failure      Page Should Contain Element         ${ErrorSectionPath}//div[text()= '${ErrorMsgNonMandatory}']
    Run Keyword And Continue On Failure      Page Should Contain Element         ${WrapperErrorSectionPath}//div[text()= '${ErrorMsgNonMandatory}']
    Validate assistant is inactive      ${draft_Data_dict_S7}
    Click Element       ${SHELL FILTER Link}

Create New Shell with different Opportunity MD and EMD
    [Documentation]
    [Tags]      Regression
    @{Shell_List}       Create List
    Open Shell From Filter List          ${DraftShellName_S7}
    ${CreatedShellName_S7}     Complete New Shell creation from Draft     ${iManage_Shell_Data}    TC104a      ${draft_Data_dict_S7}
    Append To List      ${Shell_List}       ${CreatedShellName_S7}
    Set Suite variable              ${Shell_List}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Sleep       2s
    Run Keyword And Continue On Failure     Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}
    Run Keyword And Continue On Failure     Wait Until Element Is Visible       ${ErrorSectionPath}//div[text()= 'Form Saved']          30s
    Add Attribute to the Assistant Attribute Dict       ${Shell_List[0]}        Main Budget     ${Shell_List[0]}
    Click Element       ${IMANAGE HOME Link}

Create New Shell with different Opportunity Owner and EM
    [Documentation]         Azure TC-18432/18440
    [Tags]    Regression
    ${CreatedShellName_S7}     Create a New Shell     ${iManage_Shell_Data}    TC104b
    Append To List      ${Shell_List}       ${CreatedShellName_S7}
    Log To Console      ${Shell_List}
    Log To Console      ${Shell_List[1]}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Sleep       3s
    Run Keyword And Continue On Failure     Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}
    Add Attribute to the Assistant Attribute Dict       ${Shell_List[1]}        Main Budget     ${Shell_List[1]}
    Click Element       ${SHELL FILTER Link}

Create a new Approved ERA and link multiple Shells to it
    [Documentation]
    [Tags]      Regression
    Open Shell From Filter List         ${Shell_List[1]}
    Open iManage Assistant
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    ERA with completed Part-1 and Part-2        ${era_data}     TC002
    Summary Section FRAR when selected as Normal
    Submit the ERA for Approval
    Approve ERA         ${ERA_dict}     Yes
    Validate ERA is in Approved ERA Tab         Normal
    Navigate to iManage Shell Page
    Open Shell From Filter List         ${Shell_List[0]}
    ${ApprovedERAName}      Link Approved ERA
    Set Suite Variable          ${ApprovedERAName}
    Add Attribute to the Assistant Attribute Dict       ${Shell_List[0]}        ERA     ${ApprovedERAName}
    Add Attribute to the Assistant Attribute Dict       ${Shell_List[1]}        ERA     ${ApprovedERAName}
    Teardown

Create iManage Change Order with Differnce currency and Multiple Services
    [Documentation]
    [Tags]      Regression
    Setup
    Login to existing Shell
    Wait Until Page Contains Element           ${CREATE NEW SHELL Btn}
    Open Shell From Filter List          ${Shell_List[0]}
    ${OppurtunityCreated}=      Run Keyword And Return Status       Wait Until Element Is Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}         10s
    ${ChangeOrderNew}=      Run Keyword And Continue On Failure     Run Keyword If      '${OppurtunityCreated}'=='True'     iManage Change Order Creation       ${iManage_Shell_Data}      TC104a        TC108c        ${Shell_List[0]}
    ...     ELSE        Log         Change Order can't be Created As opportunity is not created successfully yet!
    Log To Console       ${ChangeOrderNew}
    Run Keyword If      '${ChangeOrderNew}'!='None'     Add Attribute to the Assistant Attribute Dict       ${Shell_List[0]}        Change Orders     ${ChangeOrderNew}
    Click Element       ${IMANAGE HOME Link}
    Teardown

Create different contract-currency sub-Budgets & validate consolidated calculations
    [Documentation]
    [Tags]      Regression
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait until Page Contains Element        ${BUDGETS TILE Link}        30s
    Click Element       ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name}=        Complete Sub-Budget Form        ${iBudget_sub_Data}        TC109
    Set Suite Variable      ${sub-budget Name}
    Add Labor & Expenses Details        ${budget_dict}
    Run Keyword If      '${budget_dict["OFC Count"]}' != ''         Add Other fees And Charges on sub-Budget        ${budget_dict}
    Log      ${iBudget_Calculation}
    Validate Consolidated Budget Tab And Calculate Total Net Fees
    Log      ${iBudget_Calculation}

Create sub-budget & Link both Sub-budgets to the Shell from Sub-Budget
    [Documentation]
    [Tags]      Regression
    Run Keyword And Continue On Failure     Link sub-budget to Main from sub-Budget        ${Shell_List[0]}      ${sub-budget Name}
    Add Attribute to the Assistant Attribute Dict       ${Shell_List[0]}        sub-Budgets     ${sub-budget Name}
    Log     ${Assitant-Attributes dict}
    Open New Sub-Budget Form
    ${sub-budget Name}=        Complete Sub-Budget Form        ${iBudget_sub_Data}        TC101
    Set Suite Variable      ${sub-budget Name}
    Run Keyword And Continue On Failure      Link sub-budget to Main from sub-Budget        ${Shell_List[0]}      ${sub-budget Name}
    Add Attribute to the Assistant Attribute Dict       ${Shell_List[0]}        sub-Budgets     ${sub-budget Name}
    Log     ${Assitant-Attributes dict}
    Click Element       ${IBudget-IManage Link}

Create Multiple iManage Change Orders
    [Documentation]
    [Tags]      Regression
    Click My Opp and Engage Tile
    Open Shell From Filter List          ${Shell_List[1]}
    @{ChangeOrderList}=    Create List
    ${ChangeOrderNew}=        iManage Change Order Creation       ${iManage_Shell_Data}      TC104b        TC109a        ${Shell_List[1]}
    Append To List      ${ChangeOrderList}     ${ChangeOrderNew}
    Run Keyword If      '${ChangeOrderNew}'!='None'     Add Attribute to the Assistant Attribute Dict       ${Shell_List[1]}        Change Orders     ${ChangeOrderNew}
    ${ChangeOrderNew}=        iManage Change Order Creation       ${iManage_Shell_Data}      TC104b        TC109b        ${Shell_List[1]}
    Append To List      ${ChangeOrderList}     ${ChangeOrderNew}
    Run Keyword If      '${ChangeOrderNew}'!='None'     Add Attribute to the Assistant Attribute Dict       ${Shell_List[1]}        Change Orders     ${ChangeOrderNew}
    Set Suite Variable      ${ChangeOrderList}
    Log To Console      ${ChangeOrderList}
    Click Element       ${IMANAGE HOME Link}
    Teardown

Validate Multiple Shells are linked to Assistant on ERA
    [Documentation]     Azure TC -
    [Tags]    Regression
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait Until Element Is Visible     ${ERA TILE Link}      30s
    Click Element    ${ERA TILE Link}
    ${ERA Name_New}     Get Substring       ${ApprovedERAName}      0       30
    Set Global variable     ${ERA Name_New}
    Wait Until Element Is Visible       //button[text()= 'Approved ERAs']
    Click Element       //button[text()= 'Approved ERAs']
    Open ERA From Filter List       ${ApprovedERAName}     Normal
    Open Assistant On ERA and Validate Attached Shells        ${Shell_List}

Validate Assistant on ERA on slection of Shells
    [Documentation]
    [Tags]      Regression
    Expand Assistant Section        ${ASSIST MY OPP&ENGAGE Link}
    From Assistant select shell and validate Attached Attributes         ${Shell_List}


    

