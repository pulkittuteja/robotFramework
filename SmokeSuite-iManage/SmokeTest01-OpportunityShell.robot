*** Settings ***
Documentation    This suite file is to smoke test on Opportunity Shell
...              with link Approved ERA.
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot
Resource          ..\\Keyword_Library_Assistant.robot
Resource          ..\\Keyword_Library_Shell.robot

*** Variables ***
${NumberOfServices}         3
${Revenue Number Of Months}         8

*** Test Cases ***
Draft Shell Creation
    [Tags]    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${DraftShellName_Smoke1}     ${draft_Data_dict_Smoke}     Create a Draft New Shell     ${iManage_Shell_Data}    TC101
    Set Suite variable              ${DraftShellName_Smoke1}
    Set Suite variable              ${draft_Data_dict_Smoke}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure     Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-INCOMPLETE SHELL}
    Validate assistant is inactive      ${draft_Data_dict_Smoke}
    Click Element       ${SHELL FILTER Link}

Complete Shell with Proposed Opportunity Stage
    [Documentation]         Azure TC ID- 18181
    [Tags]       Smoke
    Open Shell From Filter List          ${DraftShellName_Smoke1}
    ${CreatedShellName_Smoke1}     Complete New Shell creation from Draft     ${iManage_Shell_Data}    TC102      ${draft_Data_dict_Smoke}
    Set Suite variable              ${CreatedShellName_Smoke1}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Run Keyword And Continue On Failure     Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}
    Click Element       ${IMANAGE HOME Link}

Complete Shell creation with Qualified Opportunity Stage along with pursuit team members
    [Tags]       Smoke
    Run Keyword And Ignore Error        Click Element       ${IMANAGE HOME Link}
    ${CreatedShellName_Smoke2}     Create a New Shell     ${iManage_Shell_Data}    TC106a
    Set Suite variable              ${CreatedShellName_Smoke2}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Sleep       2s
    Run Keyword And Continue On Failure     Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}

Link Approved ERA
    [Documentation]         Azure TC-18578
    [Tags]    Smoke
    ${ApprovedERAName}      Link Approved ERA
    Log To Console          ${ApprovedERAName}
    ERA Checklist should be checked on Opportunity Shell
    ERA is successfully linked to the Shell in Assistant        ${ASSIST ERA Link}       ${ApprovedERAName}
    Click Element       ${SHELL FILTER Link}

Add Additional Services to the shell
    [Documentation]         Azure TC-18567
    [Tags]    Smoke
    Open Shell From Filter List          ${CreatedShellName_Smoke2}
    Add Services to the Created Shell       ${NumberOfServices}
    Click Element       ${SHELL FILTER Link}
    Teardown

Add Revenue Schedule to the Primary and Additional Services
    [Documentation]         Azure TC- 18567 [Add Revenue Schedule to primary Service]
    [Tags]          Smoke
    Setup
    Sleep       3s
    Login to existing Shell
    Open Shell From Filter List          ${CreatedShellName_Smoke2}
    Wait Until page Contains Element        ${Revenue Schedule Link}
    Add Revenue Schedule To All Services        ${Revenue Number Of Months}
    Click Element       ${SHELL FILTER Link}
    Open Shell From Filter List          ${CreatedShellName_Smoke2}
    Validate Revenue Schedule is added successfully
    Click Element       ${SHELL FILTER Link}

Create iManage Change Order
    [Tags]      Smoke
    Open Shell From Filter List          ${CreatedShellName_Smoke1}
    ${ChangeOrderNew}=        iManage Change Order Creation       ${iManage_Shell_Data}      TC102        TC108b        ${CreatedShellName_Smoke1}
    Click Element        ${SHELL FILTER Link}
