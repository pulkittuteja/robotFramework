*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    ERA
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC002 - Normal ERA Complete
    [Tags]    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC101
    ${era_dict}=    Get Data From CSV File    ${era_data}    TC002
    ${era_dict}=    Update ERA Dictionary with Shell Values    ${era_dict}    ${shell_dict}
    Set ERA Approval Locators
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    New Opportunity Setup Form    ${shell_dict}
    #
    Expand Assistant Section    ${ASSIST ERA Link}
    Click Element    ${ASSIST ERA CREATE img}
    #
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${era_dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${era_dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${era_dict}
    Verify Header Section Rating    ${era_dict}
    Click Save and Next Button
    Complete Summary Section    ${era_dict}
    #Click Save and Next Button
    #Complete RMAP Section    ${era_dict}
    #Click Save and Next Button
    #Complete QCMD Plan Section    ${era_dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${era_dict}

*** Keywords ***
Update ERA Dictionary with Shell Values
    [Arguments]    ${era_dict}    ${shell_dict}
    Set To Dictionary    ${era_dict}    ${shell_dict[0]}    ${shell_dict[1]}
    [Return]    ${era_dict}
