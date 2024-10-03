*** Settings ***
Documentation     Sandbox suite
Suite Setup       Run Keywords    Setup    Request Suite Setup    Setup Suite
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        DoNotRun
Resource          resource.robot
Resource          Keyword_Library_Shell_Requests.robot

*** Variables ***
${shell_uri}      /api
${SHELL_DATA2}    ${CURDIR}\\Data\\Shell_request_data.csv
${ERA_DATA2}      ${CURDIR}\\Data\\ERA_request_questions_data2.csv
${LEAD_SOURCE_DATA}    ${CURDIR}\\Data\\lead_source_data.csv
@{q_names}        q1a    q1b    q2    q3    q4a    q4a1    q4a2
...               q4a3    q4b    q4c    q5    q6a    q6b    q6c
...               q6d    q7    q8a    q8b    q9    q10    q11a
...               q11b    q11c    q12    q13    q14    q15    q16a
...               q16a1    q16a2    q16a3    q16a4    q16a5    q16a6    q16b
...               q17a    q17b    q18    q19    q20    q21
@{steps}          Step 1    Step 2    Step 3

*** Test Cases ***
Create Engagement R2a
    ${data}=    Get Data From CSV File    ${SHELL_REQUEST_DATA}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_REQUEST_DATA}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

Create Engagement R2b
    ${data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

Create Engagement R2c
    ${data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

Create Engagement R2d
    ${data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

Create Engagement R2e
    ${data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

Create Engagement R2f
    ${data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

Create Engagement R2g
    ${data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

Create Engagement R2h
    ${data}=    Get Data From CSV File    ${SHELL_DATA2}    TC102a
    ${assess_control_data}=    Get Data From CSV File    ${ERA_DATA2}    TC001
    ${shell_payload}=    Create R2 Shell JSON Dict    ${data}
    Log Dictionary    ${shell_payload}
    Log Dictionary    ${headers}
    Log    ${ENV_URL}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    #${e}=    Get Request    Shell    /engagements/57d49bb7-82fa-4d07-8838-7cc6cac9c794    headers=${HEADERS}    allow_redirects=True
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    #Log    ${e.headers}
    #Log    ${e.history}
    #Log    ${e.content}
    #-------------- Get engagement key
    ${json}=    Loads    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    #-------------- Post opp service
    Sleep    10s
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    Log    ${os.headers}
    Log    ${os.history}
    Log    ${os.content}

*** Keywords ***
Get Main Information
    [Arguments]    ${id}
    ${r}=    GET Request    iBudget    /Contracts(${id})
    Should Be Equal    '${r}'    '<Response [200]>'
    [Return]    ${r}

Create Approver Dict
    [Arguments]    ${WorkflowTaskId}
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    WorkflowTaskId    ${WorkflowTaskId}
    Set To Dictionary    ${dict}    Action    1
    Set To Dictionary    ${dict}    Comment    ${NULL}
    [Return]    ${dict}

Create P1 ERA Questions Dict
    [Arguments]    ${question_dict}    ${question_data}
    @{pickedValue}=    Split String    ${question_data}    ;
    #Set To Dictionary    ${question_dict}    isApplicable    true
    Run Keyword If    ${pickedValue[0]}==2    Set To Dictionary    ${question_dict}    note1    note
    ...    ELSE    Set To Dictionary    ${question_dict}    note1    ${NULL}
    Run Keyword If    ${pickedValue[1]}==2    Set To Dictionary    ${question_dict}    note2    note
    ...    ELSE    Set To Dictionary    ${question_dict}    note2    ${NULL}
    Run Keyword If    ${pickedValue[2]}==2    Set To Dictionary    ${question_dict}    note3    note
    ...    ELSE    Set To Dictionary    ${question_dict}    note3    ${NULL}
    #Set To Dictionary    ${question_dict}    ordinal    ${eng_data}[q1a][ordinal]
    Set To Dictionary    ${question_dict}    pickedValue1    ${pickedValue[0]}
    Set To Dictionary    ${question_dict}    pickedValue2    ${pickedValue[1]}
    Set To Dictionary    ${question_dict}    pickedValue3    ${pickedValue[2]}
    #Set To Dictionary    ${question_dict}    id    ${eng_data}[q1a][id]
    #Set To Dictionary    ${question_dict}    name    ${eng_data}[q1a][name]
    #Set To Dictionary    ${question_dict}    isDeleted    FALSE
    #Set Log Level    INFO
    [Return]    ${question_dict}

Create P1 ERA Payload Dict
    [Arguments]    ${eng_data}    ${assess_control_data}
    #Set Log Level    NONE
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    id    00000000-0000-0000-0000-000000000000
    Set To Dictionary    ${dict}    isConfidential    true
    Set To Dictionary    ${dict}    name    ${eng_data["name"]}
    Set To Dictionary    ${dict}    engagementId    ${eng_data["engagementid"]}
    Set To Dictionary    ${dict}    clientId    ${eng_data["clientId"]}
    Set To Dictionary    ${dict}    clientSize    ${assess_control_data["clientSize"]}
    Set To Dictionary    ${dict}    clientLegalStructure    ${assess_control_data["clientLegalStructure"]}
    Set To Dictionary    ${dict}    principalCountryJobCreated    ${assess_control_data["principalCountryJobCreated"]}
    Set To Dictionary    ${dict}    principalCountryWorkPerformed    ${assess_control_data["principalCountryWorkPerformed"]}
    Set To Dictionary    ${dict}    engagementManagingDirectorId    ${eng_data["engagementManagingDirectorId"]}
    Set To Dictionary    ${dict}    engagementManagerId    ${eng_data["engagementManagerId"]}
    Run Keyword If    '${assess_control_data["qrmManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    qrmManagingDirectorId    ${assess_control_data["qrmManagingDirectorId"]}
    ...    ELSE    Set To Dictionary    ${dict}    qrmManagingDirectorId    ${NULL}
    Run Keyword If    '${assess_control_data["qcManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    qcManagingDirectorId    ${assess_control_data["qcManagingDirectorId"]}
    ...    ELSE    Set To Dictionary    ${dict}    qcManagingDirectorId    ${NULL}
    Set To Dictionary    ${dict}    isMsaRequired    ${assess_control_data["isMsaRequired"]}
    Set To Dictionary    ${dict}    estimatedDuration    ${assess_control_data["estimatedDuration"]}
    Set To Dictionary    ${dict}    estimatedNetFees    ${assess_control_data["estimatedNetFees"]}
    Set To Dictionary    ${dict}    estimatedContributionMargin    ${assess_control_data["estimatedContributionMargin"]}
    Set To Dictionary    ${dict}    qcmdSteps    ${steps}
    Set To Dictionary    ${dict}    rmapSteps    ${steps}
    Set Log Level    INFO
    [Return]    ${dict}
