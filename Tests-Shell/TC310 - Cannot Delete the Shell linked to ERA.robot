*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell    ERA    Assistant
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC310 - Cannot Delete the Shell linked to ERA
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC310
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Shell Setup Form    ${shell_dict}
    Sleep    2s
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Click Element    ${ASSIST ERA CREATE img}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Validate ERA Fields Populated With Shell Data    ${shell_dict}
    Click Button    ${SAVE Button}
    Sleep    5s
    Click Element    ${IMANAGE HOME Link}
    Click My Opp and Engage Tile
    Open Shell From Filter List    ${shell_dict["Opp/EngName"]}
    Element Should Not Be Visible    ${DELETE DRAFT Btn}
    #Click Element    ${DELETE DRAFT Btn}
    #Alert Should Be Present    ${SHELL ALERT CANNOT DELETE text}    timeout=30s
    Sleep    3s

*** Keywords ***
