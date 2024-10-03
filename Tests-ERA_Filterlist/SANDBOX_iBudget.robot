*** Settings ***
Documentation     Sandbox suite
Suite Setup       Run Keywords    Setup    Request Suite Setup    Setup Suite
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        DoNotRun
Resource          resource.robot
Resource          Keyword_Library_Shell_Requests.robot
Resource          Keyword_Library_ERA_Requests.robot
Resource          Keyword_Library_iBudget.robot

*** Variables ***

*** Test Cases ***
Validate Draft ERA 1
    ${shell_data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102
    ${era_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    Create Session    ERA    ${ENV_ERA_URL}/api    headers=${ERA_HEADERS}    verify=True
    #-------------- Get engagement key
    ${shell_payload}=    Create R2 Shell JSON Dict    ${shell_data}
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    #
    #-------------- Create ERA
    ${era_payload}=    Create P1 ERA Payload Dict    ${shell_payload}    ${era_data}
    ${era}=    Post Request    ERA    /assessments    headers=${ERA_HEADERS}    data=${era_payload}    allow_redirects=True
    ${assess_json}=    Loads    ${era.content}
    ${assessmentid}=    Get From Dictionary    ${assess_json}    id
    ${assessment}=    Get Request    ERA    /assessments/${assessmentid}    headers=${ERA_HEADERS}    allow_redirects=True
    #
    #-------------- Update Part 1 & 2 questions
    ${q}=    Loads    ${assessment.content}
    Set Log Level    NONE
    : FOR    ${i}    IN    @{q_names}
    \    ${q_payload}=    Create P1 ERA Questions Dict    ${q}[${i}]    ${assess_control_data}[${i}]
    \    Put Request    ERA    /questions/${q}[${i}][id]    headers=${ERA_HEADERS}    data=${q_payload}    allow_redirects=True
    Set Log Level    INFO
    #
    #-------------- Submit for approval
    ${comment_payload}=    Create Dictionary    comment    ${empty}
    ${submit}=    Put Request    ERA    /assessments/${assessmentid}/submit    headers=${ERA_HEADERS}    data=${comment_payload}    allow_redirects=True
    #
    #-------------- EMD Approval
    ${assess_resp}=    Get Request    ERA    /assessments/${assessmentid}/workflow    headers=${ERA_HEADERS}    allow_redirects=True
    ${assess_json}=    Loads    ${assess_resp.content}
    #Log Dictionary    ${assess_json}
    ${wf_resp}=    Get From Dictionary    ${assess_json}    workflowTasks
    ${approve_payload}=    Create Approver Dict    ${wf_resp[0]}[id]
    #
    #-------------- Secondary Approvals
    ${emd_approve}=    Put Request    ERA    /assessments/${assessmentid}/review    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True
    ${assess_json}=    Loads    ${emd_approve.content}
    ${wf_resp}=    Get From Dictionary    ${assess_json}    workflowTasks
    ${l}=    Get Length    ${wf_resp}
    : FOR    ${i}    IN RANGE    1    ${l}
    \    Log    ${wf_resp[${i}]}[id]
    \    ${approve_payload}=    Create Approver Dict    ${wf_resp[${i}]}[id]
    \    Put Request    era    /assessments/${assessmentid}/approve    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True

*** Keywords ***
