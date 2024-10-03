*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell    ERA    Assistant
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
# Complete, except for Link ERA button does not get pressed
TC305 - Create Conf Shell and Link Approved Non-Conf ERA
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    GEN01
    Set Global Variable    ${ERA NAME}    ${dict["ERA Name"]}
    Set ERA Approval Locators    #${dict}
    #Click ERA Tile
    #Click Button    ${CREATE NEW ERA Btn}
    #Create Draft Shell With All Data        #Runs function to create Shell with TC102 data
    #Wait Until Page Contains Element    ${ERA NAME Input}    30s
    #Complete ERA Setup Form    ${dict}
    #Click Save and Next Button
    #Validate Part 1 Questions    ${dict}
    #Click Save and Next Button
    #Validate Part 2 Questions    ${dict}
    #Verify Header Section Rating    ${dict}
    #Click Save and Next Button
    #Complete Summary Section    ${dict}
    #Click Save and Next Button
    #Complete RMAP Section    ${dict}
    #Click Save and Next Button
    #Complete QCMD Plan Section    ${dict}
    #Click Button    ${SAVE Button}
    #Sleep    2s
    #Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    #Click Button    ${SUBMIT TO EMD Button}
    #Approve ERA    ${dict}
    #Sleep    2s
    #Go To    ${ENV_URL}
    ${dict}=    Get Data From CSV File    ${shell_data}    TC305
    Set Shell Name Locators    ${dict}
    Click My Opp and Engage Tile
    Wait Until Page Contains Element        ${CREATE NEW SHELL Btn}
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${dict["existing"]}
    Shell Setup Form    ${dict}
    Sleep    2s
    #Cancel Basic Authentication
    Link Shell to Existing ERA    ${ERA NAME}
    #Wait Until Page Contains    ${SHELL NAME Title}
    #Element Should Contain    ${SHELL NAME Title}    ${SHELL NAME}
    #Validate Assistant - Opp&Eng Linked
    Open iManage Assistant
    #${t_shellname}=    Truncate Name    ${ERA NAME}    30
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Page Should Contain Element    //a[text()='${ERA NAME}']
    #Validate Assistant - ERA Linked
    #${t_eraname}=    Truncate Name    ${ERA NAME}    30
    #Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Page Should Contain Element    //a[text()='${ERA NAME}']

*** Keywords ***
