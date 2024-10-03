*** Settings ***
Documentation     A resource file for page element locators.

*** Variables ***

*** Keywords ***
Approve ERA
    [Arguments]    ${era_data}
    [Documentation]    TBD
    #-------------- Submit for approval
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
    #
    #-------------- Secondary Approvals
    ${emd_approve}=    Put Request    ERA    /assessments/${era_data['assessmentid']}/review    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True
    ${assess_json}=    String to json    ${emd_approve.content}
    ${wf_resp}=    Get From Dictionary    ${assess_json}    workflowTasks
    ${l}=    Get Length    ${wf_resp}
    FOR    ${i}    IN RANGE    1    ${l}
        Log    ${wf_resp[${i}]}[id]
        ${approve_payload}=    Create Approver Dict    ${wf_resp[${i}]}[id]
        Put Request    era    /assessments/${era_data['assessmentid']}/approve    headers=${ERA_HEADERS}    data=${approve_payload}    allow_redirects=True
    END

Create Approver Dict
    [Arguments]    ${WorkflowTaskId}
    [Documentation]    TBD
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    WorkflowTaskId    ${WorkflowTaskId}
    Set To Dictionary    ${dict}    Action    1
    Set To Dictionary    ${dict}    Comment    ${NULL}
    [Return]    ${dict}

Create iManage ERA
    [Arguments]    ${era_data}    ${shell_data}
    [Documentation]    This Keyword sets up a ERA data payload based off the given ERA and Shell data dictionaries.
    ...    The keyword will fail if no datafile path is given. The test case number defaults to EMPTY if a test case number is not given and the will exit from the
    ...    keyword without a failure. This is to accomadate the use of this keyword for data seeding activities.
    ...    Step 1)
    #Run Keyword If    '${era_data}'=='${empty}'    Log    ERA Data Dictionary is empty. Returning from Keyword
    #Run Keyword If    '${shell_data}'=='${empty}'    Log    Shell Data Dictionary is empty. Returning from Keyword
    #Run Keyword If    '${era_data}'=='${empty}' OR '${shell_data}'=='${empty}'    Return From Keyword
    ${era_payload}=    Create ERA Payload Dict    ${era_data}    ${shell_data}
    ${era}=    Post Request    ERA    /assessments    headers=${ERA_HEADERS}    data=${era_payload}    allow_redirects=True
    ${era_json}=    String to json    ${era.content}
    ${eraid}=    Get From Dictionary    ${era_json}    id
    Set To Dictionary    ${era_data}    assessmentid    ${eraid}
    [Return]    ${era_data}

Create ERA Payload Dict
    [Arguments]    ${era_data}    ${shell_data}
    [Documentation]    TBD
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    id    00000000-0000-0000-0000-000000000000
    Run Keyword If    '${era_data["isConfidential"]}'!=''    Set To Dictionary    ${dict}    isConfidential    ${era_data["isConfidential"]}
    ...    ELSE IF    '${era_data["isConfidential"]}'==''    Set To Dictionary    ${dict}    isConfidential    ${empty}
    Run Keyword If    '${shell_data["name"]}'!=''    Set To Dictionary    ${dict}    name    ${shell_data["name"]}
    ...    ELSE IF    '${shell_data["name"]}'==''    Set To Dictionary    ${dict}    name    ${empty}
    Run Keyword If    '${shell_data["engagementid"]}'!=''    Set To Dictionary    ${dict}    engagementId    ${shell_data["engagementid"]}
    ...    ELSE IF    '${shell_data["engagementid"]}'==''    Set To Dictionary    ${dict}    engagementId    ${empty}
    Run Keyword If    '${shell_data["clientId"]}'!=''    Set To Dictionary    ${dict}    clientId    ${shell_data["clientId"]}
    ...    ELSE IF    '${shell_data["clientId"]}'==''    Set To Dictionary    ${dict}    clientId    ${empty}
    Run Keyword If    '${era_data["clientSize"]}'!=''    Set To Dictionary    ${dict}    clientSize    ${era_data["clientSize"]}
    ...    ELSE IF    '${era_data["clientSize"]}'==''    Set To Dictionary    ${dict}    clientSize    ${empty}
    Run Keyword If    '${era_data["clientLegalStructure"]}'!=''    Set To Dictionary    ${dict}    clientLegalStructure    ${era_data["clientLegalStructure"]}
    ...    ELSE IF    '${era_data["clientLegalStructure"]}'==''    Set To Dictionary    ${dict}    clientLegalStructure    ${empty}
    Run Keyword If    '${era_data["principalCountryJobCreated"]}'!=''    Set To Dictionary    ${dict}    principalCountryJobCreated    ${era_data["principalCountryJobCreated"]}
    ...    ELSE IF    '${era_data["principalCountryJobCreated"]}'==''    Set To Dictionary    ${dict}    principalCountryJobCreated    ${empty}
    Run Keyword If    '${era_data["principalCountryWorkPerformed"]}'!=''    Set To Dictionary    ${dict}    principalCountryWorkPerformed    ${era_data["principalCountryWorkPerformed"]}
    ...    ELSE IF    '${era_data["principalCountryWorkPerformed"]}'==''    Set To Dictionary    ${dict}    principalCountryWorkPerformed    ${empty}
    Run Keyword If    '${shell_data["engagementManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    engagementManagingDirectorId    ${shell_data["engagementManagingDirectorId"]}
    ...    ELSE IF    '${shell_data["engagementManagingDirectorId"]}'==''    Set To Dictionary    ${dict}    engagementManagingDirectorId    ${empty}
    Run Keyword If    '${shell_data["engagementManagerId"]}'!=''    Set To Dictionary    ${dict}    engagementManagerId    ${shell_data["engagementManagerId"]}
    ...    ELSE IF    '${shell_data["engagementManagerId"]}'==''    Set To Dictionary    ${dict}    engagementManagerId    ${empty}
    Run Keyword If    '${era_data["qrmManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    qrmManagingDirectorId    ${era_data["qrmManagingDirectorId"]}
    ...    ELSE    Set To Dictionary    ${dict}    qrmManagingDirectorId    ${NULL}
    Run Keyword If    '${era_data["qcManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    qcManagingDirectorId    ${era_data["qcManagingDirectorId"]}
    ...    ELSE    Set To Dictionary    ${dict}    qcManagingDirectorId    ${NULL}
    Run Keyword If    '${era_data["isMsaRequired"]}'!=''    Set To Dictionary    ${dict}    isMsaRequired    ${era_data["isMsaRequired"]}
    ...    ELSE IF    '${era_data["isMsaRequired"]}'==''    Set To Dictionary    ${dict}    isMsaRequired    ${empty}
    Run Keyword If    '${era_data["estimatedDuration"]}'!=''    Set To Dictionary    ${dict}    estimatedDuration    ${era_data["estimatedDuration"]}
    ...    ELSE IF    '${era_data["estimatedDuration"]}'==''    Set To Dictionary    ${dict}    estimatedDuration    ${empty}
    Run Keyword If    '${era_data["estimatedNetFees"]}'!=''    Set To Dictionary    ${dict}    estimatedNetFees    ${era_data["estimatedNetFees"]}
    ...    ELSE IF    '${era_data["estimatedNetFees"]}'==''    Set To Dictionary    ${dict}    estimatedNetFees    ${empty}
    Run Keyword If    '${era_data["estimatedContributionMargin"]}'!=''    Set To Dictionary    ${dict}    estimatedContributionMargin    ${era_data["estimatedContributionMargin"]}
    ...    ELSE IF    '${era_data["estimatedContributionMargin"]}'==''    Set To Dictionary    ${dict}    estimatedContributionMargin    ${empty}
    Set To Dictionary    ${dict}    qcmdSteps    ${steps}
    Set To Dictionary    ${dict}    rmapSteps    ${steps}
    Set Log Level    INFO
    [Return]    ${dict}

Update Part 1 & 2 questions
    [Arguments]    ${era_data}
    [Documentation]    TBD
    ${assessment}=    Get Request    ERA    /assessments/${era_data['assessmentid']}    headers=${ERA_HEADERS}    allow_redirects=True
    ${q}=    String to json    ${assessment.content}
    Set Log Level    NONE
    FOR    ${i}    IN    @{q_names}
        ${q_payload}=    Create ERA Questions Dict    ${q}[${i}]    ${era_data}[${i}]
        Put Request    ERA    /questions/${q}[${i}][id]    headers=${ERA_HEADERS}    data=${q_payload}    allow_redirects=True
    END
    Set Log Level    INFO

Create ERA Questions Dict
    [Arguments]    ${question_dict}    ${question_data}
    [Documentation]    TBD
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
