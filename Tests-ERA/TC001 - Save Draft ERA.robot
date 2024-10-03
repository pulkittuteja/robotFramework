*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    debug    ERA
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC001 - Save Draft ERA
    [Tags]    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC001
    Set ERA Approval Locators    #${dict}
    #Click ERA Tile
    #Click Button    ${CREATE NEW ERA Btn}
    Create Draft Shell With All Data        #Runs function to create Shell with TC102 data
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    #Verify Filter List - By ERA Name    ${ERA NAME}    Draft

*** Keywords ***
Verify Filter List - By ERA Name
    [Arguments]    ${era_name}    ${expected_status}
    Click Link    ${ERA Link}
    Log    ${filter_list.upper()}
    Run Keyword If    '${expected_status.upper()}' != 'DRAFT' and '${expected_status.upper()}' != 'SUBMITTED' and '${expected_status.upper()}' != 'EMD REVIEW' and '${expected_status.upper()}' != 'APPROVED'    Fatal Error    \${expected_status} value needs to be Draft, Submitted, EMD Review, or Approved only
    Run Keyword If    '${expected_status.upper()}' == 'DRAFT'    Click Button    ${DRAFT ERA Btn}
    ...    ELSE IF    '${expected_status.upper()}' == 'SUBMITTED'    Click Button    ${ERA AWAITING APPROVE Btn}
    ...    ELSE IF    '${expected_status.upper()}' == 'EMD REVIEW'    Click Button    ${ERA AWAITING APPROVE Btn}
    ...    ELSE IF    '${expected_status.upper()}' == 'APPROVED'    Click Button    ${APPROVED ERAS Btn}
    Input Text    ${ERA NAME FILTER Input}    ${era_name}
    Wait Until Page Contains Element    ${FILTER Btn}    30s
    Click Element    ${FILTER Btn}
    Sleep    2s
    Page Should Contain Element    //td[@aria-label='Column ERA Name, Value ${era_name}']
    Page Should Contain Element    //td[@aria-label='Column Status, Value ${exp_status.upper()}']
