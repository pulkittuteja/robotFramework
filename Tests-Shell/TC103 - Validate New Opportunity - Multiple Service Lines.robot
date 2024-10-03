*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC103 - Create Draft Shell with all data
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as MINE
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC103
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    New Opportunity Setup Form    ${shell_dict}
    ${matching_xpath}=    Get Matching Xpath Count    ${SERVICE OFFERING Select}
    Should Be Equal    ${matching_xpath}    ${shell_dict["ServiceOffLines"]}
    Sleep    3s

*** Keywords ***
