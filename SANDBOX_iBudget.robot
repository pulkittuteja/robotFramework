*** Settings ***
Documentation     Sandbox suite
Suite Setup       Run Keywords    Setup    Request Suite Setup    Setup Suite
Force Tags        DoNotRun    #Suite Teardown    Teardown    #Test Teardown    Test Teardown
Resource          resource.robot
Resource          Keyword_Library_Shell_Requests.robot
Resource          Keyword_Library_ERA_Requests.robot
Resource          Keyword_Library_iBudget_Request.robot

*** Variables ***

*** Test Cases ***
Create Engagement/ERA/Budget R2
    ${shell_data}=    Get Data From CSV File    ${SHELL_REQUEST_DATA}    TC302
    #${shell_data}=    Get Data From CSV File    ${SHELL_REQUEST_DATA}    TC102
    ${era_control_data}=    Get Data From CSV File    ${ERA_REQUEST_DATA}    TC001
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    Create Session    ERA    ${ENV_ERA_URL}/api    headers=${ERA_HEADERS}    verify=True
    #-------------- Create R2 Shell
    ${shell_data}=    Create iManage Engagement Shell    ${shell_data}
    #
    ${shell_data}=    Create iManage ERA    ${shell_data}

Test Break1
    #-------------- Create ERA
    ${era_payload}=    Create P1 ERA Payload Dict    ${shell_payload}    ${era_control_data}
    ${era}=    Post Request    ERA    /assessments    headers=${ERA_HEADERS}    data=${era_payload}    allow_redirects=True
    ${assess_json}=    String to json    ${era.content}
    ${assessmentid}=    Get From Dictionary    ${assess_json}    id
    ${assessment}=    Get Request    ERA    /assessments/${assessmentid}    headers=${ERA_HEADERS}    allow_redirects=True
    #
    #-------------- Update Part 1 & 2 questions
    ${q}=    String to json    ${assessment.content}
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
    Log    ${assess_resp.content}
    ${assess_json}=    String to json    ${assess_resp.content}
    Log    Look at this
    Log Dictionary    ${assess_json}
    ${wf_resp}=    Get From Dictionary    ${assess_json}    workflowTasks
    ${approve_payload}=    Create Approver Dict    ${wf_resp[0]}[id]
    #
    #-------------- Secondary Approvals
    ${emd_approve}=    Put Request    ERA    /assessments/${assessmentid}/review    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True
    ${assess_json}=    String to json    ${emd_approve.content}
    ${wf_resp}=    Get From Dictionary    ${assess_json}    workflowTasks
    ${l}=    Get Length    ${wf_resp}
    : FOR    ${i}    IN RANGE    1    ${l}
    \    Log    ${wf_resp[${i}]}[id]
    \    ${approve_payload}=    Create Approver Dict    ${wf_resp[${i}]}[id]
    \    Put Request    era    /assessments/${assessmentid}/approve    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True
    #

test break
    #-------------- Get Main Data
    ${main_dict}=    Get Main Data    ${engagementid}
    #
    #-------------- Change Main Pcode
    ${main_dict}=    Change Main Project Code    ${main_dict}
    #
    #-------------- Add contract info to Main
    Add contract info to Main    ${main_dict}
    #
    #-------------- Create Sub Budget under Main
    ${sub_dict}=    Create Sub Budget under Main    ${main_dict}
    #
    #-------------- Create Sub Budget Basic Info
    ${rate_dict}=    Create Contract Rate Dict    ${sub_dict['Id']}    MD1
    ${rate_json}=    Format Dictionary to iBudget Json    ${rate_dict}
    Log    ${rate_json}
    ${r}=    POST Request    iBudget    /ContractRates    data=${rate_json}
    log    ${r.content}
    #
    #-------------- Complete Sub Budget Labor
    ${labor_dict}=    Create Sub Budget Labor Row Dict    ${sub_dict['Id']}    LAB003
    ${labor_json}=    Format Dictionary to iBudget Json    ${labor_dict}
    Log    ${labor_json}
    ${l}=    POST Request    iBudget    /LaborResources    data=${labor_json}
    log    ${l.content}
    #

Test Break2
    #-------------- Complete Sub Budget Expenses
    #
    #-------------- Complete Sub Budget Other Fees
    #
    #-------------- Complete Sub Budget Additional Info
    #
    #-------------- Submit Sub
    Submit Sub Budget    ${sub_dict}

*** Keywords ***
