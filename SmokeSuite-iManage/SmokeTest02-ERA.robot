*** Settings ***
Documentation    This suite file is to smoke test ERA workflow along
...              with unlinking of Approved ERA.
Suite Setup       Run Keywords    Setup
Suite Teardown    Teardown
Resource          ..\\resource.robot
Resource          ..\\Keyword_Library_Assistant.robot
Resource          ..\\Keyword_Library_Shell.robot

*** Variables ***

*** Test Cases ***
Create Shell & Add Draft ERA
    [Tags]    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${CreatedShellName_Smoke}     Create a New Shell     ${iManage_Shell_Data}    TC105a
    Set Suite variable              ${CreatedShellName_Smoke}
    Scroll Element Into View        ${OPPORTUNITY STATUS BAR}
    Sleep       2s
    Run Keyword And Continue On Failure     Element Should Be Visible       ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-CREATION TEXT}
    Open iManage Assistant
    Sleep       5s
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    Create an ERA via Shell        ${era_data}     TC001
    Click Element       ${IMANAGE HOME Link}

ERA in EMD Review Status
    [Tags]      Smoke
    Run Keyword And Ignore Error        Click Element       ${IMANAGE HOME Link}
    Wait until Element Is Visible       ${ERA TILE Link}
    Click Element       ${ERA TILE Link}
    Open ERA From Filter List       ${ERA NAME}     Normal
    ERA with completed Part-1 and Part-2            ${era_data}         TC002
    Summary Section FRAR when selected as Normal
    Submit the ERA for Approval                 #...for bypass & Navigate to approve for test
    Validate ERA is in EMD Awaiting Approval Tab        Normal

ERA in Approved Status
    [Tags]      Smoke
    Open ERA From Filter List       ${ERA NAME}     Normal
    Navigate To ERA Approval Link from filter-list
    Approve ERA         ${ERA_dict}     Yes
    Validate ERA is in Approved ERA Tab         Normal

Unlink ERA to Create Standalone ERA
    [Tags]      Smoke
    Navigate to iManage Shell Page
    Open Shell From Filter List          ${CreatedShellName_Smoke}
    ERA is successfully linked to the Shell in Assistant        ${ASSIST ERA Link}      ${ERA NAME}
    Unlink ERA
    Sleep       5s
    Wait Until Element Is Visible        ${HAMBURGER Btn}
    ERA Checklist should be unchecked on Opportunity Shell
