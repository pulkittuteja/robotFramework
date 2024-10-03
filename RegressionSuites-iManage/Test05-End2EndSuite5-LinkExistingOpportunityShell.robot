*** Settings ***
Documentation    This suite file is to link an existing Salesforce opportunity along with
...              new and existing ERAs.
...              Suite Flow:
...              * Link an existing Opp and validate Salesforce checklist is checked.
...              * Validate Assistant on linked Existing opportunity shell
...              * Create a new Approved ERA from Assistant and validate Shell cannot be deleted
...              * Validate locking Rule for Client/Account for Linked Existing Opportunity Shell + Approved New ERA
...              * Add and Delete users from Manage Permission Link

Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot

*** Variables ***
${text}         No Data Found
${Members}      QA, qasamsha05na1;QA, qasamsha05pod2
${Contract_Form}        JAL
${Contract_Version}     Original
${HyperLink}         https://www.yahoo.com/

*** Test Cases ***
Link an existing opportunity and validate Salesforce checklist
    [Documentation]         Azure TC-
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${CreatedShellName_S5}     Link Exiting opportuinty with complete Shell     ${iManage_Shell_Data}    TC302
    Set Suite variable              ${CreatedShellName_S5}
    Run Keyword and Continue On Failure     Page Should Contain Element      ${Checked Salesforce opportunity created}

Validate Assistant on linked Existing opportunity shell
    [Documentation]         Azure TC-19647
    [Tags]    Regression
    Open iManage Assistant
    Validate Default Fields on Assistant for Proposed Opportunity Stage
    Click Element       ${SHELL FILTER Link}

Validate locking Rule for Client/Account for Standalone Existing Opportunity Shell
    [Documentation]         Azure TC-20629
    [Tags]    Regression
    Open Shell From Filter List          ${CreatedShellName_S5}
    Sleep       2s
    User Selects Different Client Name      ${shell_dict["Client Name2"]}        Form Saved      ${shell_dict["existing"]}      ${shell_dict["PKB_Client2"]}
    Set Focus To Element        ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name            ${shell_dict["Client Name"]}      ${shell_dict["Child1"]}         ${shell_dict["existing"]}       ${shell_dict["PKB_Child1"]}
    Scroll Element Into View        ${Shell Save Button}

Create a new Approved ERA from Assistant and Validate Shell Cannot be Deleted
    [Documentation]         Azure TC-
    [Tags]    Regression
    Open iManage Assistant
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    Validate ERA Fields Populated With Shell Data        ${shell_dict}
    ERA with completed Part-1 and Part-2        ${era_data}     TC002
    Summary Section FRAR when selected as Normal
    Submit the ERA for Approval
    Approve ERA         ${ERA_dict}     Yes
    Validate ERA is in Approved ERA Tab         Normal
    Navigate to iManage Shell Page
    Open Shell From Filter List          ${CreatedShellName_S5}
    ERA Checklist should be checked on Opportunity Shell
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${DELETE DRAFT Btn}

Validate locking Rule for Client/Account for Existing Opportunity Shell + Approved New ERA
    [Documentation]         Azure TC ID-20672
    [Tags]      Regression
    Sleep       2s
    User Selects Different Client Name      ${shell_dict["Client Name2"]}        ${ErrorMsg_ApprovedERA}     ${shell_dict["existing"]}      ${shell_dict["PKB_Client2"]}
    Set Focus To Element        ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name            ${shell_dict["Client Name"]}      ${shell_dict["Child2"]}             ${shell_dict["existing"]}     ${shell_dict["PKB_Child2"]}
    Scroll Element Into View        ${Shell Save Button}

Unlink The ERA To Create Standalone Approved ERA
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Open iManage Assistant
    Expand Assistant Section     ${ASSIST ERA Link}
    Unlink ERA
    Sleep       5s
    Wait Until Element Is Visible        ${HAMBURGER Btn}
    ERA Checklist should be unchecked on Opportunity Shell

Add and Delete users from Manage Permission Link
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Run Keyword If    '${shell_dict["ManagePermUSERS"]}'!=''        Add Members From Manage Permission      ${shell_dict["ManagePermUSERS"]}
    ...     ELSE        Log     ${text}
    Run Keyword If    '${shell_dict["ManagePermUSERS"]}'!=''        Delete Members From Manage Permission       ${shell_dict["ManagePermUSERS"]}
    Set Focus To Element        ${Shell Save Button}
    Click Button       ${Shell Save Button}

Link Approved ERA and Validate Locking Rule on Client/Account Field for Existing Opp Shell
    [Documentation]         Azure TC ID-18578
    [Tags]      Regression
    ${ApprovedERAName}      Link Approved ERA
    Log To Console          ${ApprovedERAName}
    ERA Checklist should be checked on Opportunity Shell
    Click Element       ${SHELL FILTER Link}
    Open Shell From Filter List          ${CreatedShellName_S5}
    Sleep       2s
    User Selects Different Client Name      ${shell_dict["Client Name2"]}        ${ErrorMsg_ApprovedERA}     ${shell_dict["existing"]}      ${shell_dict["PKB_Client2"]}
    Set Focus To Element        ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name            ${shell_dict["Client Name"]}      ${shell_dict["Child1"]}         ${shell_dict["existing"]}        ${shell_dict["PKB_Child1"]}
    #Unlink-ing ERA
    Open iManage Assistant
    Expand Assistant Section     ${ASSIST ERA Link}
    Unlink ERA
    Sleep       5s
    Wait Until Element Is Visible        ${HAMBURGER Btn}
    ERA Checklist should be unchecked on Opportunity Shell
    Click Element       ${SHELL FILTER Link}

Link SFDC ERA and Validate Locking Rule on Client/Account Field for Existing Opp Shell
    [Documentation]         Azure TC ID-18429
    [Tags]      Regression
    Open Shell From Filter List         ${CreatedShellName_S5}
    Scroll Element Into View        ${Shell Save Button}
    Link SFDC ERA           ${SFDC-ERA-URL-DEV}         ${SFDC-ERA-URL-QA}
    ERA Checklist should be checked on Opportunity Shell
    Click Element       ${SHELL FILTER Link}
    Open Shell From Filter List          ${CreatedShellName_S5}
    Sleep       2s
    User Selects Different Client Name      ${shell_dict["Client Name2"]}        ${ErrorMsg_SFDC_ERA}     ${shell_dict["existing"]}         ${shell_dict["PKB_Client2"]}
    Set Focus To Element        ${ACCOUNT/CLIENT Input}
    User Selects Different Child Client Name            ${shell_dict["Client Name"]}      ${shell_dict["Child2"]}         ${shell_dict["existing"]}     ${shell_dict["PKB_Child2"]}
    Scroll Element Into View        ${Shell Save Button}

Unlink ERA from Assistant and Delete Shell
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${DELETE DRAFT Btn}
    Open iManage Assistant
    Expand Assistant Section     ${ASSIST ERA Link}
    Unlink ERA
    Sleep       5s
    Wait Until Element Is Visible        ${HAMBURGER Btn}
    ERA Checklist should be unchecked on Opportunity Shell
    Click Element       ${SHELL FILTER Link}
    Delete Shell        ${CreatedShellName_S5}
    Wait Until Page Contains Element    ${CREATE NEW SHELL Btn}     20s
    Wait Until Page Contains Element    ${SHELL OPP/ENG FILTER input}    20s
    Input Text    ${SHELL OPP/ENG FILTER input}    ${CreatedShellName_S5}${\n}
    Press Key       ${SHELL OPP/ENG FILTER input}       \\13
    Wait Until Element Is Visible        ${No Data Txt}         10s
    Run Keyword And Continue On Failure    Page Should Contain Element      ${No Data Txt}

Create a budget from iBudget and Validate Assistant on Standalone sub-budget
    [Documentation]         Azure TC ID-
    [Tags]      Regression
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait until Page Contains Element        ${BUDGETS TILE Link}        30s
    Click Element       ${BUDGETS TILE Link}
    Open New Sub-Budget Form
    ${sub-budget Name}=        Complete Sub-Budget Form        ${iBudget_sub_Data}        TC101
    Set Suite Variable      ${sub-budget Name}
    Log      ${budget_dict}
    Log      ${sub-budget Name}

Link the sub-budget to Main from iBudget & Ready For Activation
    [Documentation]
    [Tags]      Regression
    Link sub-budget to Main from sub-Budget        ${CreatedShellName_S5}      ${sub-budget Name}
    Click Element       ${IBudget-IManage Link}
    Wait Until Element Is Visible       ${MY OPP&ENGAGE TILE Link}
    Click Element       ${MY OPP&ENGAGE TILE Link}
    Open Shell From Filter List          ${CreatedShellName_S5}
    Scroll Element Into View        ${Shell Save Button}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Click Element       ${ASSIST BUDGETS Link}/following-sibling::ul//a[contains(normalize-space(.), '${CreatedShellName_S5}')]
    Run Keyword And Ignore Error        Wait Until Element Is Visible       ${ibudget New budget Link}      30s
    ${Main_Pcode}=       Update Main Project Number      ${shell_dict["BU"]}
    Add Contracts details on Main       ${Contract_Form}        ${Contract_Version}         ${HyperLink}
    Open sub-Budget Linked to Main      ${sub-budget Name}
    Update sub-Budget Project Number        ${Main_Pcode}

EMD Approved the sub-budget & Validate budget Calculations
    [Documentation]
    [Tags]      Regression
    Sub-Budget activation Workflow       ${budget_dict}
    Universal Activation         ${budget_dict}
