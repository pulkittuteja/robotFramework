*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell    ERA    Assistant
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC304 - Create New Shell and Link a New ERA
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC304
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Shell Setup Form    ${shell_dict}
    Sleep    1s
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Click Element    ${ASSIST ERA CREATE img}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Validate ERA Fields Populated With Shell Data    ${shell_dict}
    Click Button    ${SAVE Button}
    Sleep    1s
    Click Element    ${IMANAGE HOME Link}
    Click My Opp and Engage Tile
    Open Shell From Filter List    ${shell_dict["Opp/EngName"]}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Page Should Contain Element    //a[text()='${shell_dict["Opp/EngName"]}']    #WTH am I doing here?.. this might not be right..
    Sleep    3s

*** Keywords ***
