*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    ERA
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
SEEDING - ERA Complete
    [Tags]    Seeding
    Get Approver Roles    apprv01
    Login in as Admin
    ${datalist}=    Read Csv File To List    ${era_seed_data}
    ${l}=    Get Length    ${datalist}
    Click ERA Tile
    : FOR    ${i}    IN RANGE    1    ${l}
    \    ${dict}=    Get Data From CSV File    ${era_seed_data}    TC${i}
    \    Set ERA Approval Locators    ${dict}
    \    Log    I'm Here 1
    \    Sleep    3s
    \    Wait Until Page Contains Element    ${CREATE NEW ERA Btn}    30s
    \    Click Button    ${CREATE NEW ERA Btn}
    \    Log    I'm Here 2
    \    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    \    Complete ERA Setup Form    ${dict}
    \    Click Save and Next Button
    \    Validate Part 1 Questions    ${dict}
    \    Click Save and Next Button
    \    Validate Part 2 Questions    ${dict}
    \    Verify Header Section Rating    ${dict}
    \    Click Save and Next Button
    \    Complete Summary Section    ${dict}
    \    Click Save and Next Button
    \    Complete RMAP Section    ${dict}
    \    Click Save and Next Button
    \    Complete QCMD Plan Section    ${dict}
    \    Sleep    2s
    \    Click Button    ${SAVE Button}
    \    Sleep    2s
    \    Log    I'm Here 3
    \    Wait Until Page Contains Element    //span[@id="era"]    30s
    \    Click Element    //span[@id="era"]
    \    #Approve ERA    ${dict}

*** Keywords ***
Get Seed Data From CSV File
    [Arguments]    ${datafile}    ${TestCaseNum}
    Set Log Level    NONE
    ${d}=    Create Dictionary
    ${data}=    Read Csv File To List    ${datafile}
    ${readrow}=    Get Read Row    ${data}    ${TestCaseNum}
    ${col}=    Get From List    ${data}    0
    ${row}=    Get From List    ${data}    ${readrow}
    ${l}=    Get Length    ${col}
    : FOR    ${i}    IN RANGE    1    ${l}
    \    ${k}=    Get From List    ${col}    ${i}
    \    ${v}=    Get From List    ${row}    ${i}
    \    Set To Dictionary    ${d}    ${k}    ${v.strip()}
    Set Log Level    INFO
    [Return]    ${d}
