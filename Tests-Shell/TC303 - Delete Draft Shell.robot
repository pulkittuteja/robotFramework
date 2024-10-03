*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
#Test fails due to header link not clickable.  Dan is reviewing
TC303 - Delete Draft Shell
    [Tags]    Regression
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC303
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Shell Setup Form    ${shell_dict}
    Sleep    1s
    Click Element    ${SHELL HEADER Link}       #waiting for Dan to review why its disabled
    Search Shell From Filter List by Name    ${shell_dict["Opp/EngName"]}
    Wait Until Page Contains Element    //a[span[text()='${shell_dict["Opp/EngName"]}']]    30s
    Click Element    //a[span[text()='${shell_dict["Opp/EngName"]}']]
    Click Element    ${DELETE DRAFT Btn}
    ${msg}=    Handle Alert
    Sleep    5s
    Search Shell From Filter List by Name    ${shell_dict["Opp/EngName"]}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    //a[span[text()='${shell_dict["Opp/EngName"]}']]
    Sleep    3s

*** Keywords ***
