*** Settings ***
Documentation     This suite file is to open an existing opportunity with 'Identified'
...               opportunity Stage and validating Increased ERA's along with RMAP and
...               QC MD filled.
...               Suite Flow:
...               * Open Existing Opp. and validate opp creation in SFDC
...               * Validate Assistant for Selected oportunity Stage
...               * Create Draft ERA with Overall Increased Rating
...               * Add RMAP and QC MD details
...               * Approve increased CRAR ERA
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot
Resource          ..\\Keyword_Library_Assistant.robot
Resource          ..\\Keyword_Library_Shell.robot

*** Variables ***
${Closed}         Closed - Unqualified
${Reason}         Client Unresponsive
${dept}           13110

*** Test Cases ***
Create Draft Shell w/o PKB field and validate Assistant is not activated
    [Documentation]    Azure TC -
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${DraftShellName_S3}    ${draft_Data_dict_S3}    Create a Draft New Shell    ${iManage_Shell_Data}    TC103b
    Set Suite variable    ${DraftShellName_S3}
    Set Suite variable    ${draft_Data_dict_S3}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-INCOMPLETE SHELL}
    Validate assistant is inactive    ${draft_Data_dict_S3}
    Click Element    ${SHELL FILTER Link}

Complete new shell and validate for BU Locking Rule
    [Tags]    Regression
    Open Shell From Filter List    ${DraftShellName_S3}
    ${CreatedShellGlobal_S3}    Complete New Shell creation from Draft    ${iManage_Shell_Data}    TC105a    ${draft_Data_dict_S3}
    Set Suite variable    ${CreatedShellGlobal_S3}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Sleep    2s
    Run Keyword And Continue On Failure    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}
    Scroll Element Into View    ${BU/DEPT Select}
    Click Element    ${BU/DEPT Select}
    Sleep    1s
    Input Text    //dx-data-grid[@id='businessUnitGrid']//td[@aria-label="Column Department ID, Filter cell"]//input    ${dept}
    Sleep    2s
    Run Keyword And Continue On Failure    Page Should Not Contain Element    //td[text()='${dept}']
    Click Element    //button[@class= 'closePopupBtn']

Validate Assistant for Identified Opportunity Stage
    [Documentation]    Azure TC-
    [Tags]    Regression
    Sleep    5s
    Open iManage Assistant
    Validate Default Fields on Assistant for Identified Opportunity Stage    ${CreatedShellGlobal_S3}

Create Main Budget Manually From Assistant & Validate Message
    [Tags]    Regression
    From Assistant Navigate to ${ASSIST BUDGETS Link} further to ${ASSIST BUDGETS CREATE img}
    Sleep    2s
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST BUDGET CREATION TEXT}

Create ERA with Overall Increased Rating
    [Documentation]    Azure TC-18577
    [Tags]    Regression
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    ERA with completed Part-1 and Part-2    ${era_data}    TC026
    Wait until Element is Visible    ${FRAR Select}
    ${FRAR Selected Value}=    Get Selected List Value    ${FRAR Select}
    Run Keyword And Continue On Failure    Should be equal as strings    ${FRAR Selected Value}    Increased

Validate for mandatory Field sections for selected FRAR
    [Documentation]    Azure TC-
    [Tags]    Regression
    Summary Section FRAR when selected as Normal
    Summary Section FRAR when selected as High
    Summary Section FRAR when selected as Increased
    Click Save and Next Button

Enter RMAP and QCMD details in created ERA for Increased CRAR
    [Documentation]    Azure TC-
    [Tags]    Regression
    Complete RMAP Section    ${ERA_dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${ERA_dict}
    Click Button    ${SAVE Button}

Submit the ERA with Increased CRAR
    [Documentation]    Azure TC-18340 [Only approved by ERA]
    [Tags]    Regression
    Submit the ERA for Approval
    Validate ERA is in EMD Awaiting Approval Tab    Increased
    Open ERA From Filter List    ${ERA NAME}    Increased
    Navigate To ERA Approval Link from filter-list
    Approve ERA    ${ERA_dict}    Yes

Validate locking Rule for Client/Account with Submitted Increased Rating ERA
    [Documentation]    Azure TC-20682
    [Tags]    Regression
    Navigate to iManage Shell Page
    Open Shell From Filter List    ${CreatedShellGlobal_S3}
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    ${ErrorMsg_ApprovedERA}    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child1"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child1"]}
    Scroll Element Into View    ${Shell Save Button}

Approve the ERA with Increased CRAR
    [Documentation]    Azure TC-18341
    [Tags]    Regression
    From Shell Navigate to ${ASSIST ERA Link} further to ${ERA NAME}
    Navigate To ERA Approval Link from filter-list
    Approve ERA    ${ERA_dict}    No
    Validate ERA is in Approved ERA Tab    Increased
    Navigate to iManage Shell Page
    Open Shell From Filter List    ${CreatedShellGlobal_S3}
    ERA Checklist should be checked on Opportunity Shell

Validate locking Rule for Client/Account with Approved Increased Rating ERA
    [Documentation]    Azure TC- 20683[This test case would validate the error message that user
    ...    will encounter while updating Client/Account details when an approved
    ...    Increased rating ERA is linked to Shell]
    [Tags]    Regression
    User Selects Different Client Name    ${shell_dict["Client Name2"]}    ${ErrorMsg_ApprovedERA}    ${shell_dict["existing"]}    ${shell_dict["PKB_Client2"]}
    Set Focus To Element    ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name    ${shell_dict["Client Name"]}    ${shell_dict["Child2"]}    ${shell_dict["existing"]}    ${shell_dict["PKB_Child2"]}
    Click Element    ${IMANAGE HOME Link}

Close Opportunity with Closed-Unqualified and validate Shell is moved to closed tab
    [Tags]    Regression
    Click My Opp and Engage Tile
    Wait Until Page Contains Element    ${CREATE NEW SHELL Btn}
    Open Shell From Filter List    ${CreatedShellGlobal_S3}
    Sleep    3s
    ${OppurtunityCreated}=    Run Keyword And Return Status    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Close Opportunity    ${Closed}    ${Reason}    ${shell_dict["Proposal Used"]}
    ...    ELSE    Log    Opportunity can't be closed as it's not created yet!    #${shell_dict["Closed Stage"]}    ${shell_dict["PrimaryReason"]}

Create an Unit-Value sub-budget with different Contract Currency
    [Tags]    Regression
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait until Page Contains Element    ${BUDGETS TILE Link}    30s
    Click Element    ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name}=    Complete Sub-Budget Form    ${iBudget_sub_Data}    TC107
    Set Suite Variable    ${sub-budget Name}
    Log    ${budget_dict}
    Log    ${sub-budget Name}

Link created sub-budget to shell from Assistant
    [Tags]    Regression
    Click Element    ${IBudget-IManage Link}
    Click My Opp and Engage Tile
    Open Shell moved to closed tab    ${CreatedShellGlobal_S3}
    ${Attached_Status}=    Link a sub-budget to Shell via Assistant    ${sub-budget Name}
    Wait Until Element Is Visible    //input[@value= '${CreatedShellGlobal_S3}']    30s
    Run Keyword If    '${Attached_Status}'=='Sub-Budget Attached'    Page Should Contain Element    //table[@id= 'GridView']//td[@title= '${sub-budget Name}']

Copy a sub-budget from Assistant
    [Tags]    Regression
    Click Element    ${IBudget-IManage Link}
    Click My Opp and Engage Tile
    Open Shell moved to closed tab    ${CreatedShellGlobal_S3}
    Scroll Element Into View    ${Shell Save Button}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Click Element    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET COPY img}
    ${budget_dict}=    Get Budget Test Data    ${iBudget_sub_Data}    TC108
    ${sub-Budget Copied}=    Add copied sub-budget to Shell    ${budget_dict["Project Description"]}    ${sub-budget Name}
    Set Suite Variable    ${sub-Budget Copied}

Validate added sub-budget is linked to Assistant & Main
    [Tags]    Regression
    Click Element    ${sub-budget Main Link}
    Wait Until Element Is Visible    //input[@value= '${CreatedShellGlobal_S3}']
    Run Keyword And Continue On Failure    Page Should Contain Element    //table[@id= 'GridView']//td[@title= '${sub-budget Name}']
    Run Keyword And Continue On Failure    Page Should Contain Element    //table[@id= 'GridView']//td[@title= '${sub-Budget Copied}']
    Click Element    ${IBudget-IManage Link}
    Click My Opp and Engage Tile
    Open Shell moved to closed tab    ${CreatedShellGlobal_S3}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${ASSIST BUDGETS Link}/following-sibling::ul//a[text()= '${sub-budget Name}']
    Run Keyword And Continue On Failure    Page Should Contain Element    ${ASSIST BUDGETS Link}/following-sibling::ul//a[text()= '${sub-Budget Copied}']
