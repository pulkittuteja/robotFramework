*** Settings ***
Documentation     Keyword file for executing shell request scripts

*** Variables ***

*** Keywords ***
Create iManage Engagement Shell
    [Arguments]    ${shell_data}
    [Documentation]    Requires a dictionary of shell data. Sets up the proper service offering format for R1 or R2 shell form. R1 requires the
    ...    service offereing ID be part of the shell data payload while R2 uses a separate api call to populate one or more service offerings.
    ...    Step 1) If the serviceOfferingScenarioNums value is not EMPTY then it pulls creates a list of service offering dictionaries.
    ...    Step 2) If the shell type is 0 then the service offering ID is set to the shell_data dictionary. Otherwise the step is ignored.
    ...    Step 3) Creates a shell payload based on the type of shell.
    ...    Step 4) performs a POST request and captures the reponse data
    ...    Step 5) Extracts the engagement ID and sets it to the shell data dictionary
    ...    Step 6) If the shell type is 1 (R2) then the shell data and the list of service offering dictionaries are passed into the 'Post Opp Services' keyword
    ...    Step 7) Returns the updated shell data dictionary
    ${opp_serv_payloads}=    Run Keyword If    '${shell_data["serviceOfferingScenarioNums"]}'!=''    Get Opp Service Dict    ${shell_data["serviceOfferingScenarioNums"]}
    Run Keyword If    '${shell_data["Type"]}'=='0'    Set To Dictionary    ${shell_data}    serviceOfferingId    ${opp_serv_payloads[0]['serviceOfferingId']}
    ${shell_payload}=    Run Keyword If    '${shell_data["Type"]}'=='0'    Create R1 Shell Payload Dict    ${shell_data}
    ...    ELSE IF    '${shell_data["Type"]}'=='1'    Create R2 Shell Payload Dict    ${shell_data}
    Log    ${shell_payload}
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    log    ${e.content}
    ${json}=    String to json    ${e.content}
    ${engagementid}=    Get From Dictionary    ${json}    id
    Set To Dictionary    ${shell_data}    engagementid    ${engagementid}
    Run Keyword If    '${shell_data["Type"]}'=='1'    Post Opp Services    ${shell_data}    ${opp_serv_payloads}
    [Return]    ${shell_data}

Create R1 Shell Payload Dict
    [Arguments]    ${data}
    [Documentation]    Creates a data payload for the engagement POST.
    ...    Step 1) Creates an empty dictionary
    ...    Step 2) Creates a timestamp that is appended to the shell name variable to avoid duplicate names
    ...    Step 3) Sets a date variable 2 day in the future to set as the plannedClosedDate
    ...    Step 4) Sets the key:value items to the dictionary based on the shell data sheet
    ...    Step 5) Returns a payload dictionary
    #Set Log Level    NONE
    Log Dictionary    ${data}
    ${dict}=    Create Dictionary
    ${ts}=    Get Timestamp
    ${date}=    Future Date    +2d
    Set To Dictionary    ${dict}    id    00000000-0000-0000-0000-000000000000
    Run Keyword If    '${data["businessUnitId"]}'!=''    Set To Dictionary    ${dict}    businessUnitId    ${data["businessUnitId"]}
    ...    ELSE IF    '${data["businessUnitId"]}'==''    Set To Dictionary    ${dict}    businessUnitId    ${empty}
    Run Keyword If    '${data["clientId"]}'!=''    Set To Dictionary    ${dict}    clientId    ${data["clientId"]}
    ...    ELSE IF    '${data["clientId"]}'==''    Set To Dictionary    ${dict}    clientId    ${empty}
    Run Keyword If    '${data["departmentId"]}'!=''    Set To Dictionary    ${dict}    departmentId    ${data["departmentId"]}
    ...    ELSE IF    '${data["departmentId"]}'==''    Set To Dictionary    ${dict}    departmentId    ${empty}
    Run Keyword If    '${data["description"]}'!=''    Set To Dictionary    ${dict}    description    ${data["description"]}
    ...    ELSE IF    '${data["description"]}'==''    Set To Dictionary    ${dict}    description    ${empty}
    Run Keyword If    '${data["engagementManagerId"]}'!=''    Set To Dictionary    ${dict}    engagementManagerId    ${data["engagementManagerId"]}
    ...    ELSE IF    '${data["engagementManagerId"]}'==''    Set To Dictionary    ${dict}    engagementManagerId    ${empty}
    Run Keyword If    '${data["engagementManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    engagementManagingDirectorId    ${data["engagementManagingDirectorId"]}
    ...    ELSE IF    '${data["engagementManagingDirectorId"]}'==''    Set To Dictionary    ${dict}    engagementManagingDirectorId    ${empty}
    Run Keyword If    '${data["IaNaturalOfWork"]}'!=''    Set To Dictionary    ${dict}    IaNaturalOfWork    ${data["IaNaturalOfWork"]}
    ...    ELSE IF    '${data["IaNaturalOfWork"]}'==''    Set To Dictionary    ${dict}    IaNaturalOfWork    ${empty}
    Run Keyword If    '${data["isConfidential"]}'!=''    Set To Dictionary    ${dict}    isConfidential    ${data["isConfidential"]}
    ...    ELSE IF    '${data["isConfidential"]}'==''    Set To Dictionary    ${dict}    isConfidential    ${empty}
    Run Keyword If    '${data["isDigital"]}'!=''    Set To Dictionary    ${dict}    isDigital    ${data["isDigital"]}
    ...    ELSE IF    '${data["isDigital"]}'==''    Set To Dictionary    ${dict}    isDigital    ${empty}
    Run Keyword If    '${data["isManagedService"]}'!=''    Set To Dictionary    ${dict}    isManagedService    ${data["isManagedService"]}
    ...    ELSE IF    '${data["isManagedService"]}'==''    Set To Dictionary    ${dict}    isManagedService    ${empty}
    Run Keyword If    '${data["name"]}'!=''    Set To Dictionary    ${dict}    name    ${data["name"]} ${ts}
    ...    ELSE IF    '${data["name"]}'==''    Set To Dictionary    ${dict}    name    ${empty}
    Run Keyword If    '${data["opportunityURL"]}'!=''    Set To Dictionary    ${dict}    opportunityURL    ${data["opportunityURL"]}
    ...    ELSE IF    '${data["opportunityURL"]}'==''    Set To Dictionary    ${dict}    opportunityURL    ${empty}
    Set To Dictionary    ${dict}    plannedClosedDate    ${date}T01:46:39.844Z
    Run Keyword If    '${data["serviceOfferingId"]}'!=''    Set To Dictionary    ${dict}    serviceOfferingId    ${data["serviceOfferingId"]}
    ...    ELSE IF    '${data["serviceOfferingId"]}'==''    Set To Dictionary    ${dict}    serviceOfferingId    ${empty}
    Run Keyword If    '${data["TransactionService"]}'!=''    Set To Dictionary    ${dict}    TransactionService    ${data["TransactionService"]}
    ...    ELSE IF    '${data["TransactionService"]}'==''    Set To Dictionary    ${dict}    TransactionService    ${empty}
    Run Keyword If    '${data["Type"]}'!=''    Set To Dictionary    ${dict}    Type    ${data["Type"]}
    ...    ELSE IF    '${data["Type"]}'==''    Set To Dictionary    ${dict}    Type    ${empty}
    Set Log Level    INFO
    [Return]    ${dict}

Create R2 Shell Payload Dict
    [Arguments]    ${data}
    [Documentation]    Creates a data payload for the engagement POST.
    ...    Step 1) Creates an empty dictionary
    ...    Step 2) Creates a timestamp that is appended to the shell name variable to avoid duplicate names
    ...    Step 3) Create a Lead Source payload dictionary based off of the business unit ID. This is set to the parent shell payload.
    ...    Step 4) Sets a date variable 2 day in the future to set as the plannedClosedDate
    ...    Step 5) Sets the key:value items to the dictionary based on the shell data sheet
    ...    Step 6) Returns a payload dictionary
    ...    *** NOTE: need to figure out the revenue schedule data
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    ${ts}=    Get Timestamp
    ${leadsource}=    Get Lead Source Payload Dict    ${data["businessUnitId"]}
    ${date}=    Future Date    +2d
    Set To Dictionary    ${dict}    id    00000000-0000-0000-0000-000000000000
    Run Keyword If    '${data["businessUnitId"]}'!=''    Set To Dictionary    ${dict}    businessUnitId    ${data["businessUnitId"]}
    ...    ELSE IF    '${data["businessUnitId"]}'==''    Set To Dictionary    ${dict}    businessUnitId    ${empty}
    Run Keyword If    '${data["clientId"]}'!=''    Set To Dictionary    ${dict}    clientId    ${data["clientId"]}
    ...    ELSE IF    '${data["clientId"]}'==''    Set To Dictionary    ${dict}    clientId    ${empty}
    Run Keyword If    '${data["departmentId"]}'!=''    Set To Dictionary    ${dict}    departmentId    ${data["departmentId"]}
    ...    ELSE IF    '${data["departmentId"]}'==''    Set To Dictionary    ${dict}    departmentId    ${empty}
    Run Keyword If    '${data["description"]}'!=''    Set To Dictionary    ${dict}    description    ${data["description"]}
    ...    ELSE IF    '${data["description"]}'==''    Set To Dictionary    ${dict}    description    ${empty}
    Run Keyword If    '${data["engagementManagerId"]}'!=''    Set To Dictionary    ${dict}    engagementManagerId    ${data["engagementManagerId"]}
    ...    ELSE IF    '${data["engagementManagerId"]}'==''    Set To Dictionary    ${dict}    engagementManagerId    ${empty}
    Run Keyword If    '${data["engagementManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    engagementManagingDirectorId    ${data["engagementManagingDirectorId"]}
    ...    ELSE IF    '${data["engagementManagingDirectorId"]}'==''    Set To Dictionary    ${dict}    engagementManagingDirectorId    ${empty}
    Set To Dictionary    ${dict}    hasRevenueSchedule    true    #FIGURE OUT WHAT NEEDS TO GO ON HERE
    Run Keyword If    '${data["IaNaturalOfWork"]}'!=''    Set To Dictionary    ${dict}    IaNaturalOfWork    ${data["IaNaturalOfWork"]}
    ...    ELSE IF    '${data["IaNaturalOfWork"]}'==''    Set To Dictionary    ${dict}    IaNaturalOfWork    ${empty}
    Run Keyword If    '${data["isConfidential"]}'!=''    Set To Dictionary    ${dict}    isConfidential    ${data["isConfidential"]}
    ...    ELSE IF    '${data["isConfidential"]}'==''    Set To Dictionary    ${dict}    isConfidential    ${empty}
    Run Keyword If    '${data["isDigital"]}'!=''    Set To Dictionary    ${dict}    isDigital    ${data["isDigital"]}
    ...    ELSE IF    '${data["isDigital"]}'==''    Set To Dictionary    ${dict}    isDigital    ${empty}
    Run Keyword If    '${data["isManagedService"]}'!=''    Set To Dictionary    ${dict}    isManagedService    ${data["isManagedService"]}
    ...    ELSE IF    '${data["isManagedService"]}'==''    Set To Dictionary    ${dict}    isManagedService    ${empty}
    Run Keyword If    '${data["leadSourceId"]}'!=''    Set To Dictionary    ${dict}    leadSourceId    ${data["leadSourceId"]}
    ...    ELSE IF    '${data["leadSourceId"]}'==''    Set To Dictionary    ${dict}    leadSourceId    ${empty}
    Set To Dictionary    ${dict}    leadSource    ${leadsource}
    Run Keyword If    '${data["name"]}'!=''    Set To Dictionary    ${dict}    name    ${data["name"]} ${ts}
    ...    ELSE IF    '${data["name"]}'==''    Set To Dictionary    ${dict}    name    ${empty}
    Set To Dictionary    ${dict}    opportunityHasPrimaryKeyBuyer    False
    Run Keyword If    '${data["opportunityOwnerId"]}'!=''    Set To Dictionary    ${dict}    opportunityOwnerId    ${data["opportunityOwnerId"]}
    ...    ELSE IF    '${data["opportunityOwnerId"]}'==''    Set To Dictionary    ${dict}    opportunityOwnerId    ${empty}
    Run Keyword If    '${data["opportunityCurrencyId"]}'!=''    Set To Dictionary    ${dict}    opportunityCurrencyId    ${data["opportunityCurrencyId"]}
    ...    ELSE IF    '${data["opportunityCurrencyId"]}'==''    Set To Dictionary    ${dict}    opportunityCurrencyId    ${empty}
    Run Keyword If    '${data["opportunityCurrencyCode"]}'!=''    Set To Dictionary    ${dict}    opportunityCurrencyCode    ${data["opportunityCurrencyCode"]}
    ...    ELSE IF    '${data["opportunityCurrencyCode"]}'==''    Set To Dictionary    ${dict}    opportunityCurrencyCode    ${empty}
    Run Keyword If    '${data["OpportunityManagingDirectorId"]}'!=''    Set To Dictionary    ${dict}    OpportunityManagingDirectorId    ${data["OpportunityManagingDirectorId"]}
    ...    ELSE IF    '${data["OpportunityManagingDirectorId"]}'==''    Set To Dictionary    ${dict}    OpportunityManagingDirectorId    ${empty}
    Run Keyword If    '${data["opportunityStageId"]}'!=''    Set To Dictionary    ${dict}    opportunityStageId    ${data["opportunityStageId"]}
    ...    ELSE IF    '${data["opportunityStageId"]}'==''    Set To Dictionary    ${dict}    opportunityStageId    ${empty}
    Set To Dictionary    ${dict}    plannedClosedDate    ${date}T01:46:39.844Z
    Set To Dictionary    ${dict}    opportunityCloseDate    ${date}T01:46:39.844Z
    Run Keyword If    '${data["serviceOfferingId"]}'!=''    Set To Dictionary    ${dict}    serviceOfferingId    ${data["serviceOfferingId"]}
    ...    ELSE IF    '${data["serviceOfferingId"]}'==''    Set To Dictionary    ${dict}    serviceOfferingId    ${empty}
    Run Keyword If    '${data["ecosystem"]}'!=''    Set To Dictionary    ${dict}    ecosystem    ${data["ecosystem"]}
    ...    ELSE IF    '${data["ecosystem"]}'==''    Set To Dictionary    ${dict}    ecosystem    ${empty}
    Run Keyword If    '${data["Type"]}'!=''    Set To Dictionary    ${dict}    Type    ${data["Type"]}
    ...    ELSE IF    '${data["Type"]}'==''    Set To Dictionary    ${dict}    Type    ${empty}
    Run Keyword If    '${data["probability"]}'!=''    Set To Dictionary    ${dict}    probability    ${data["probability"]}
    ...    ELSE IF    '${data["probability"]}'==''    Set To Dictionary    ${dict}    probability    ${empty}
    Run Keyword If    '${data["opportunityHasPrimaryKeyBuyer"]}'!=''    Set To Dictionary    ${dict}    opportunityHasPrimaryKeyBuyer    ${data["opportunityHasPrimaryKeyBuyer"]}
    ...    ELSE IF    '${data["opportunityHasPrimaryKeyBuyer"]}'==''    Set To Dictionary    ${dict}    opportunityHasPrimaryKeyBuyer    ${empty}
    Run Keyword If    '${data["primaryWinLossReasonId"]}'!=''    Set To Dictionary    ${dict}    primaryWinLossReasonId    ${data["primaryWinLossReasonId"]}
    ...    ELSE IF    '${data["primaryWinLossReasonId"]}'==''    Set To Dictionary    ${dict}    primaryWinLossReasonId    ${empty}
    Run Keyword If    '${data["opportunityPrimaryKeyBuyerId"]}'!=''    Set To Dictionary    ${dict}    opportunityPrimaryKeyBuyerId    ${data["opportunityPrimaryKeyBuyerId"]}
    ...    ELSE IF    '${data["opportunityPrimaryKeyBuyerId"]}'==''    Set To Dictionary    ${dict}    opportunityPrimaryKeyBuyerId    ${empty}
    Set Log Level    INFO
    [Return]    ${dict}

Get Lead Source Payload Dict
    [Arguments]    ${lead_souce_line_num}
    [Documentation]    Creates a Lead Source data payload to be included in the shell data payload.
    ...    Step 1) Creates an empty dictionary
    ...    Step 2) Gets the lead source data from the file based off of the number
    ...    Step 5) Sets the key:value items to the dictionary based on the lead source data pull from the sheet
    ...    Step 6) Returns a payload dictionary
    ${dict}=    Create Dictionary
    ${data}=    Get Data From CSV File     ${LEAD_SOURCE_DATA}       LS#      ${lead_souce_line_num}
    Run Keyword If    '${data["leadSourceId"]}'!=''    Set To Dictionary    ${dict}    id    ${data["leadSourceId"]}
    ...    ELSE IF    '${data["leadSourceId"]}'==''    Set To Dictionary    ${dict}    id    ${empty}
    Run Keyword If    '${data["leadSourceId"]}'!=''    Set To Dictionary    ${dict}    leadSourceId    ${data["leadSourceId"]}
    ...    ELSE IF    '${data["leadSourceId"]}'==''    Set To Dictionary    ${dict}    leadSourceId    ${empty}
    Run Keyword If    '${data["sourceDetailId"]}'!=''    Set To Dictionary    ${dict}    sourceDetailId    ${data["sourceDetailId"]}
    ...    ELSE IF    '${data["sourceDetailId"]}'==''    Set To Dictionary    ${dict}    sourceDetailId    ${empty}
    Run Keyword If    '${data["referralSourceId"]}'!=''    Set To Dictionary    ${dict}    referralSourceId    ${data["referralSourceId"]}
    ...    ELSE IF    '${data["referralSourceId"]}'==''    Set To Dictionary    ${dict}    referralSourceId    ${empty}
    Run Keyword If    '${data["leadSource"]}'!=''    Set To Dictionary    ${dict}    leadSource    ${data["leadSource"]}
    ...    ELSE IF    '${data["leadSource"]}'==''    Set To Dictionary    ${dict}    leadSource    ${empty}
    Run Keyword If    '${data["sourceDetail"]}'!=''    Set To Dictionary    ${dict}    sourceDetail    ${data["sourceDetail"]}
    ...    ELSE IF    '${data["sourceDetail"]}'==''    Set To Dictionary    ${dict}    sourceDetail    ${empty}
    Run Keyword If    '${data["referralSource"]}'!=''    Set To Dictionary    ${dict}    referralSource    ${data["referralSource"]}
    ...    ELSE IF    '${data["referralSource"]}'==''    Set To Dictionary    ${dict}    referralSource    ${empty}
    Run Keyword If    '${data["displayName"]}'!=''    Set To Dictionary    ${dict}    displayName    ${data["displayName"]}
    ...    ELSE IF    '${data["displayName"]}'==''    Set To Dictionary    ${dict}    displayName    ${empty}
    Run Keyword If    '${data["displayCode"]}'!=''    Set To Dictionary    ${dict}    displayCode    ${data["displayCode"]}
    ...    ELSE IF    '${data["displayCode"]}'==''    Set To Dictionary    ${dict}    displayCode    ${empty}
    Run Keyword If    '${data["parentId"]}'!=''    Set To Dictionary    ${dict}    parentId    ${data["parentId"]}
    ...    ELSE IF    '${data["parentId"]}'==''    Set To Dictionary    ${dict}    parentId    ${empty}
    Run Keyword If    '${data["isParent"]}'!=''    Set To Dictionary    ${dict}    isParent    ${data["isParent"]}
    ...    ELSE IF    '${data["isParent"]}'==''    Set To Dictionary    ${dict}    isParent    ${empty}
    [Return]    ${dict}

Get Opp Service Dict
    [Arguments]    ${serviceOfferingScenarioNums}
    [Documentation]    This keyword requires a string of comma delinated Opp Service Scenario numbers from the Shell Requests Datasheet.
    ...    Step 1) Creates an empty list that will eventually contain a collection of one or more Opp Service payload dictionaries.
    ...    Step 2) Splits the comma delinated string into a collection of Opp service scenario numbers to be looped through
    ...    Step 3) Creates a variable \${ordinal} initally set at 0
    ...    Step 4) Begins loop
    ...    Step 5) Inside the loop a dictionary created based on the opp service scenario number. the info is retrieved from the Opp service data sheet
    ...    Step 6) The ordinal number is set to the dictionary
    ...    Step 7) The dictionary is appended to the list that will be returned
    ...    Step 8) The ordinal number is incremented up by 1 to be used if multiple service offereing are being created
    ...    Step 9) Returns the list of service offereing payload dictionaries
    #Set Log Level    NONE
    ${list}=    Create List
    @{so_scenarios_list}=    Split String    ${serviceOfferingScenarioNums}    ,
    ${ordinal}=    Set Variable    0
    FOR    ${i}    IN    @{so_scenarios_list}
        ${so_data_dict}=    Get Data From CSV File    ${SO_DATASHEET}       SCENARIO#      ${i}
        Set To Dictionary    ${so_data_dict}    ordinal    ${ordinal}
        Log         ${so_data_dict}
        Append To List    ${list}    ${so_data_dict}
        ${ordinal}=    Evaluate    ${ordinal}+1
    END
    #Set Log Level    INFO
    [Return]    ${list}

Get Pursuit Team Payload Dict
    ${v}=    Set Variable    {"EmployeeIds": ["a1b8965e-c90a-477a-933a-83a08f7901f3"]}
    [Return]    ${v}

Post Opp Services
    [Arguments]    ${shell_data}    ${opp_serv_payloads}
    [Documentation]    This keyword is for R2 shells only and requires a dictionary of shell data and the Opp Service payload list.
    ...    The Opp Service list is a list of Opp Service
    ...    Step 1) Loops through each item in the Opp Service list.
    ...    Step 2) Inside the loop the EngagementID from the shell data dictionary is set to the Opp Service payload dictionary.
    ...    Step 3) Makes a POST request to the opportunityServices API.
    ...    This keyword does not return any info.
    #Set Log Level    NONE
    #${c}=    Set Variable    0
    FOR    ${i}    IN    @{opp_serv_payloads}
        Set To Dictionary    ${i}    EngagementId    ${shell_data['engagementid']}
        Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${i}    allow_redirects=True
        #${c}=    Evaluate    ${c}+1
    END
    #Set Log Level    INFO
