*** Settings ***
Documentation     Sandbox suite
Suite Setup       Run Keywords    Setup    Request Suite Setup    Setup Suite
Suite Teardown    Teardown    #Test Teardown    Test Teardown
Force Tags        DoNotRun
Resource          resource.robot
Resource          Keyword_Library_Shell_Requests.robot
Resource          Keyword_Library_ERA_Requests.robot
Resource          Keyword_Library_iBudget_Request.robot

*** Variables ***
${YE_SHELL_DATA}    ${CURDIR}\\Data\\Yr_End_ Data_Shell_request_data.csv

*** Test Cases ***
Data Seed YE
    ${TC}=    Get TC Numbers    ${YE_SHELL_DATA}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    Create Session    ERA    ${ENV_ERA_URL}/api    headers=${ERA_HEADERS}    verify=True
    : FOR    ${i}    IN    @{TC}
    \    Log    ${i}
    \    ${shell_data}=    Get Data From CSV File    ${YE_SHELL_DATA}    ${i}
    \    ${era_data}=    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Get Data From CSV File    ${ERA_REQUEST_DATA}    ${shell_data["ERANUM"]}
    \    #${era_data}=    Get Data From CSV File    ${ERA_REQUEST_DATA}    TC001
    \    ${shell_data}=    Create iManage Engagement Shell    ${shell_data}
    \    ${era_data}=    Create iManage ERA    ${era_data}    ${shell_data}
    \    Update Part 1 & 2 questions    ${era_data}
    \    Run Keyword If    '${era_data["SubmitApproval"].upper()}'=='TRUE'    Approve ERA    ${era_data}
    \    ${main_dict}=    Get Main Data    ${shell_data['engagementid']}
    \    ${main_dict}=    Change Main Project Code    ${main_dict}
    \    Add contract info to Main    ${main_dict}
    \    ${sub_dict}=    Create Sub Budget under Main    ${main_dict}

Create Engagement/ERA/Budget R2
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    Create Session    ERA    ${ENV_ERA_URL}/api    headers=${ERA_HEADERS}    verify=True
    ${shell_data}=    Get Data From CSV File    ${SHELL_REQUEST_DATA}    SHL102
    ${era_data}=    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Get Data From CSV File    ${ERA_REQUEST_DATA}    ${shell_data["ERANUM"]}
    ${shell_data}=    Create iManage Engagement Shell    ${shell_data}
    ${era_data}=    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Create iManage ERA    ${era_data}    ${shell_data}
    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Update Part 1 & 2 questions    ${era_data}
    Run Keyword If    '${shell_data["ERANUM"]}'!=''    Approve ERA - NEW    ${era_data}

*** Keywords ***
Approve ERA - NEW
    [Arguments]    ${era_data}
    [Documentation]    TBD
    #-------------- Submit for approval
    Return From Keyword If    '${era_data["SubmitApproval"].upper()}'=='FALSE'    ERA does not require approval
    ${comment_payload}=    Create Dictionary    comment    ${empty}
    ${submit}=    Put Request    ERA    /assessments/${era_data['assessmentid']}/submit    headers=${ERA_HEADERS}    data=${comment_payload}    allow_redirects=True
    #
    #-------------- EMD Approval
    ${assess_resp}=    Get Request    ERA    /assessments/${era_data['assessmentid']}/workflow    headers=${ERA_HEADERS}    allow_redirects=True
    Log    ${assess_resp.content}
    ${assess_json}=    String to json    ${assess_resp.content}
    Log    Look at this
    Log Dictionary    ${assess_json}
    ${wf_resp}=    Get From Dictionary    ${assess_json}    workflowTasks
    ${approve_payload}=    Create Approver Dict    ${wf_resp[0]}[id]
    Log Dictionary    ${approve_payload}
    #
    #-------------- Secondary Approvals
    ${emd_approve}=    Put Request    ERA    /assessments/${era_data['assessmentid']}/review    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True
    ${assess_json}=    String to json    ${emd_approve.content}
    ${wf_resp}=    Get From Dictionary    ${assess_json}    workflowTasks
    ${l}=    Get Length    ${wf_resp}
    : FOR    ${i}    IN RANGE    1    ${l}
    \    Log    ${wf_resp[${i}]}[id]
    \    ${approve_payload}=    Create Approver Dict    ${wf_resp[${i}]}[id]
    \    Put Request    era    /assessments/${era_data['assessmentid']}/approve    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True
