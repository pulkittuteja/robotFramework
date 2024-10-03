*** Settings ***
Documentation     Keyword Library for iManage Assistant Functionality

*** Variables ***

*** Keywords ***
Get Main Information
    [Arguments]    ${id}
    ${r}=    GET Request    iBudget    /Contracts(${id})
    Should Be Equal    '${r}'    '<Response [200]>'
    [Return]    ${r}

Create Sub Budget Contract Rate
    [Arguments]    ${budgetid}    ${job_func_code}
    ${rate_dict}=    Create Contract Rate Dict    ${budgetid}    ${job_func_code}
    ${rate_json}=    Format Dictionary to iBudget Json    ${rate_dict}
    ${r}=    POST Request    iBudget    /ContractRates    data=${rate_json}
    #Log    ${r.headers}
    #Log    ${r.content}
    [Return]    ${rate_dict}

Create Contract Rate Dict
    [Arguments]    ${budgetid}    ${job_func_code}
    Set Log Level    NONE
    ${data}=    Get Data From CSV File    ${IBUDGET_RATE_DATA}    ${job_func_code}
    ${dict}=    Create Dictionary
    ${uuid4}=    Uuid 4
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.ContractRateDto
    Set To Dictionary    ${dict}    BudgetId    ${budgetid}
    Run Keyword If    '${data["ExchangedRate"]}'!=''    Set To Dictionary    ${dict}    ExchangedRate    ${data["ExchangedRate"]}
    ...    ELSE IF    '${data["ExchangedRate"]}'==''    Set To Dictionary    ${dict}    ExchangedRate    ${null}
    #Set To Dictionary    ${dict}    ExchangedRate    ${null}
    Set To Dictionary    ${dict}    Id    ${uuid4}
    Run Keyword If    '${data["IsLocked"]}'!=''    Set To Dictionary    ${dict}    IsLocked    ${data["IsLocked"].lower()}
    ...    ELSE IF    '${data["IsLocked"]}'==''    Set To Dictionary    ${dict}    IsLocked    ${false}
    #Set To Dictionary    ${dict}    IsLocked    ${false}
    Run Keyword If    '${data["JobFunctionId"]}'!=''    Set To Dictionary    ${dict}    JobFunctionId    ${data["JobFunctionId"]}
    ...    ELSE IF    '${data["JobFunctionId"]}'==''    Set To Dictionary    ${dict}    JobFunctionId    ${null}
    #Set To Dictionary    ${dict}    JobFunctionId    096aa4ad-b0e8-4bbc-8620-c0780e4e8ed5
    Run Keyword If    '${data["Name"]}'!=''    Set To Dictionary    ${dict}    Name    ${data["Name"]}
    ...    ELSE IF    '${data["Name"]}'==''    Set To Dictionary    ${dict}    Name    ${null}
    #Set To Dictionary    ${dict}    Name    ${null}
    Run Keyword If    '${data["Rate"]}'!=''    Set To Dictionary    ${dict}    Rate    ${${data["Rate"]}}
    ...    ELSE IF    '${data["Rate"]}'==''    Set To Dictionary    ${dict}    Rate    ${null}
    #Set To Dictionary    ${dict}    Rate    ${200}
    Run Keyword If    '${data["ResourceNameId"]}'!=''    Set To Dictionary    ${dict}    ResourceNameId    ${data["ResourceNameId"]}
    ...    ELSE IF    '${data["ResourceNameId"]}'==''    Set To Dictionary    ${dict}    ResourceNameId    ${null}
    #Set To Dictionary    ${dict}    ResourceNameId    ${null}
    Run Keyword If    '${data["SpecificEmployeeId"]}'!=''    Set To Dictionary    ${dict}    SpecificEmployeeId    ${data["SpecificEmployeeId"]}
    ...    ELSE IF    '${data["SpecificEmployeeId"]}'==''    Set To Dictionary    ${dict}    SpecificEmployeeId    ${null}
    #Set To Dictionary    ${dict}    SpecificEmployeeId    21363178-8acc-44ec-8925-c6a7b4296ede
    Run Keyword If    '${data["TargetRate"]}'!=''    Set To Dictionary    ${dict}    TargetRate    ${data["TargetRate"]}
    ...    ELSE IF    '${data["TargetRate"]}'==''    Set To Dictionary    ${dict}    TargetRate    ${null}
    #Set To Dictionary    ${dict}    TargetRate    ${null}
    Set Log Level    INFO
    [Return]    ${dict}

Create Sub Budget under Main
    [Arguments]    ${main_dict}
    ${sub_dict}=    Create Sub Budget JSON Dict    ${main_dict}
    Set To Dictionary    ${sub_dict}    ProjectCode    ${main_dict['ProjectCode']}\-01
    ${sub_json}=    Format Dictionary to iBudget Json    ${sub_dict}
    #${sub_json}=    Convert Dictionary to JSON    ${sub_dict}
    ${r}=    POST Request    iBudget    /Budgets    data=${sub_json}
    #Log    ${r.headers}
    #Log    ${r.content}
    [Return]    ${sub_dict}

Add contract info to Main
    [Arguments]    ${main_dict}
    ${conlink_dict}=    Create Contract Link JSON Dict    ${main_dict['Id']}
    ${conlink_json}=    Format Dictionary to iBudget Json    ${conlink_dict}
    Sleep    2s
    ${p}=    POST Request    iBudget    /ContractLinks    data=${conlink_json}
    Log    ${p.content}
    #Log    ${p.headers}

Change Main Project Code
    [Arguments]    ${main_dict}
    [Documentation]    Changes the auto assigned project code on the Main to a iTrac like project code. Requires a dictionary of the Main data.
    ...    Returns the updated Main data dictionary
    Sleep    10s
    ${main_pcode}=    Create Random iBudget Project Number
    ${main_pcode}=    Convert to string    ${main_pcode}
    Set To Dictionary    ${main_dict}    ProjectCode    ${main_pcode}
    Set To Dictionary    ${main_dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.ContractDto
    Remove From Dictionary    ${main_dict}    \@odata.context
    Log Dictionary    ${main_dict}
    ${main_json}=    Format Dictionary to iBudget Json    ${main_dict}
    Sleep    5s
    ${p}=    PATCH Request    iBudget    /Contracts(${main_dict['Id']})    data=${main_json}    #json=json
    Log    ${p.content}
    Log    ${p.headers}
    [Return]    ${main_dict}

Format Dictionary to iBudget Json
    [Arguments]    ${dict}
    Set Log Level    NONE
    ${str}=    Convert To String    ${dict}
    ${str}=    Replace String    ${str}    '    "
    ${str}=    Replace String    ${str}    None    null
    ${str}=    Replace String    ${str}    True    true
    ${json}=    Replace String    ${str}    False    false
    Pretty Print Json    ${json}
    #Log    ${json}
    Set Log Level    INFO
    [Return]    ${json}

Create Sub Budget Labor Row Dict
    [Arguments]    ${budgetid}    ${lab_row_name}
    Set Log Level    NONE
    ${data}=    Get Data From CSV File    ${IBUDGET_LABOR_DATA}    ${lab_row_name}
    ${dict}=    Create Dictionary
    ${uuid4}=    Uuid 4
    ${date}=    Get Time    year-month-day
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.LaborResourceDto
    Set To Dictionary    ${dict}    ActualBillings    ${null}
    Set To Dictionary    ${dict}    ActualContractCurrencyBillings    ${null}
    Set To Dictionary    ${dict}    ActualCost    ${null}
    Set To Dictionary    ${dict}    ActualQuantity    ${null}
    Set To Dictionary    ${dict}    BillingsVariance    ${null}
    Set To Dictionary    ${dict}    BillRate    ${null}
    Set To Dictionary    ${dict}    BillRateContractCurrency    ${null}
    Set To Dictionary    ${dict}    BudgetId    ${budgetid}
    Run Keyword If    '${data["BudgetSectionId"]}'!=''    Set To Dictionary    ${dict}    BudgetSectionId    ${data["BudgetSectionId"]}
    ...    ELSE IF    '${data["BudgetSectionId"]}'==''    Set To Dictionary    ${dict}    BudgetSectionId    ${empty}
    Set To Dictionary    ${dict}    Burden    ${null}
    Set To Dictionary    ${dict}    CmPercentage    ${null}
    Set To Dictionary    ${dict}    ContractRateId    ${null}
    Set To Dictionary    ${dict}    CostRate    ${0}
    Set To Dictionary    ${dict}    CostVariance    ${null}
    Set To Dictionary    ${dict}    Currency    ${null}
    Set To Dictionary    ${dict}    DepartmentName    ${null}
    Run Keyword If    '${data["DeptId"]}'!=''    Set To Dictionary    ${dict}    DeptId    ${data["DeptId"]}
    ...    ELSE IF    '${data["DeptId"]}'==''    Set To Dictionary    ${dict}    DeptId    ${null}
    Set To Dictionary    ${dict}    EacBillableQuantity    ${null}
    Set To Dictionary    ${dict}    EacBillableTargetBillings    ${null}
    Set To Dictionary    ${dict}    EacBillings    ${null}
    Set To Dictionary    ${dict}    EacCost    ${null}
    Run Keyword If    '${data["EacQuantity"]}'!=''    Set To Dictionary    ${dict}    EacQuantity    ${${data["EacQuantity"]}}
    ...    ELSE IF    '${data["EacQuantity"]}'==''    Set To Dictionary    ${dict}    EacQuantity    ${null}
    Set To Dictionary    ${dict}    EacTargetBillings    ${null}
    Set To Dictionary    ${dict}    EmployeeId    ${null}
    Set To Dictionary    ${dict}    EtcBillings    ${null}
    Set To Dictionary    ${dict}    EtcCost    ${null}
    Set To Dictionary    ${dict}    EtcQuantity    ${null}
    Set To Dictionary    ${dict}    Id    ${uuid4}
    Set To Dictionary    ${dict}    IsLocked    false
    Set To Dictionary    ${dict}    IsReestimating    false
    Set To Dictionary    ${dict}    IsUnitBased    false
    Run Keyword If    '${data["JobFunction"]}'!=''    Set To Dictionary    ${dict}    JobFunction    ${data["JobFunction"]}
    ...    ELSE IF    '${data["JobFunction"]}'==''    Set To Dictionary    ${dict}    JobFunction    ${null}
    Set To Dictionary    ${dict}    LastApprovedBillableQuantity    ${null}
    Set To Dictionary    ${dict}    LastApprovedBillableTargetBillings    ${null}
    Set To Dictionary    ${dict}    LastApprovedBillings    ${null}
    Set To Dictionary    ${dict}    LastApprovedCost    ${null}
    Set To Dictionary    ${dict}    LastApprovedQuantity    ${null}
    Set To Dictionary    ${dict}    LastApprovedTargetBillings    ${null}
    Run Keyword If    '${data["LineOfBusiness"]}'!=''    Set To Dictionary    ${dict}    LineOfBusiness    ${data["LineOfBusiness"]}
    ...    ELSE IF    '${data["LineOfBusiness"]}'==''    Set To Dictionary    ${dict}    LineOfBusiness    ${null}
    Run Keyword If    '${data["Notes"]}'!=''    Set To Dictionary    ${dict}    Notes    ${data["Notes"]}
    ...    ELSE IF    '${data["Notes"]}'==''    Set To Dictionary    ${dict}    Notes    ${null}
    Run Keyword If    '${data["OperationUnit"]}'!=''    Set To Dictionary    ${dict}    OperationUnit    ${data["OperationUnit"]}
    ...    ELSE IF    '${data["OperationUnit"]}'==''    Set To Dictionary    ${dict}    OperationUnit    ${null}
    Set To Dictionary    ${dict}    Ordinal    ${0}
    Run Keyword If    '${data["PayRate"]}'!=''    Set To Dictionary    ${dict}    PayRate    ${${data["PayRate"]}}
    ...    ELSE IF    '${data["PayRate"]}'==''    Set To Dictionary    ${dict}    PayRate    ${null}
    Set To Dictionary    ${dict}    QuantityVariance    ${null}
    Run Keyword If    '${data["ResourceName"]}'!=''    Set To Dictionary    ${dict}    ResourceName    ${data["ResourceName"]}
    ...    ELSE IF    '${data["ResourceName"]}'==''    Set To Dictionary    ${dict}    ResourceName    ${null}
    Set To Dictionary    ${dict}    TargetRate    ${null}
    Run Keyword If    '${data["Task"]}'!=''    Set To Dictionary    ${dict}    Task    ${data["Task"]}
    ...    ELSE IF    '${data["Task"]}'==''    Set To Dictionary    ${dict}    Task    ${null}
    Set Log Level    INFO
    Log    ${dict}
    [Return]    ${dict}

Create Random iBudget Project Number
    ${r}=    Evaluate    random.randint(30000000, 99999999)    random,sys
    [Return]    ${r}

Create Headers Dict
    [Arguments]    ${cookies}
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    Accept    application/json,text/html,application/xhtml\+xml,application/xml;q\=0.9,image/webp,image/apng,*/*;q\=0.8,application/signed-exchange;v\=b3
    Set To Dictionary    ${dict}    Accept-Encoding    gzip, deflate, br
    Set To Dictionary    ${dict}    Accept-Language    en-US,en;q\=0.9
    Set To Dictionary    ${dict}    Content-Type    application/json
    Set To Dictionary    ${dict}    User-Agent    Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.86 Safari/537.36
    Set To Dictionary    ${dict}    Cookie    ${cookies}
    Set Log Level    INFO
    [Return]    ${dict}

Create Submit Headers Dict
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    OData-Version    4.0
    Set To Dictionary    ${dict}    OData-MaxVersion    4.0
    Set To Dictionary    ${dict}    Content-Type    application/json;odata.metadata\=minimal
    Set To Dictionary    ${dict}    Accept    application/json;odata.metadata\=minimal
    Set To Dictionary    ${dict}    User-Agent    Microsoft.OData.Client/7.4.4
    Set To Dictionary    ${dict}    Host    devibudget.protiviti.com:1111
    Set To Dictionary    ${dict}    Content-Length    42
    Set To Dictionary    ${dict}    Expect    100-continue
    Set Log Level    INFO
    [Return]    ${dict}

Create Review Headers Dict
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    OData-Version    4.0
    Set To Dictionary    ${dict}    OData-MaxVersion    4.0
    Set To Dictionary    ${dict}    Content-Type    application/json;odata.metadata\=minimal
    Set To Dictionary    ${dict}    Accept    application/json;odata.metadata\=minimal
    Set To Dictionary    ${dict}    Accept-Charset    UTF-8
    Set To Dictionary    ${dict}    User-Agent    Microsoft.OData.Client/7.4.4
    Set To Dictionary    ${dict}    Host    devibudget.protiviti.com:1111
    Set To Dictionary    ${dict}    Content-Length    131
    Set To Dictionary    ${dict}    Expect    100-continue
    Set Log Level    INFO
    [Return]    ${dict}

Create Sub Budget JSON Dict
    [Arguments]    ${main_dict}
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    ${uuid4}=    Uuid 4
    ${ts}=    Get Timestamp
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.BudgetDto
    Set To Dictionary    ${dict}    ActualDate    ${null}
    Set To Dictionary    ${dict}    ApprovedDate    ${null}
    Set To Dictionary    ${dict}    Assigned    ${null}
    Set To Dictionary    ${dict}    BusinessUnit    200
    Set To Dictionary    ${dict}    Client    JC Client
    Set To Dictionary    ${dict}    ContractCurrency    ${null}
    Set To Dictionary    ${dict}    ContractFeeType    Hourly
    Set To Dictionary    ${dict}    ContractId    ${main_dict['Id']}
    Set To Dictionary    ${dict}    CreatedDate    0001-01-01T00:00:00Z
    Set To Dictionary    ${dict}    Creator    ${null}
    Set To Dictionary    ${dict}    Currency    ${null}
    Set To Dictionary    ${dict}    CurrentStatus    ${0}
    Set To Dictionary    ${dict}    DeptId    10040
    Set To Dictionary    ${dict}    DiscountExplanation    ${null}
    Set To Dictionary    ${dict}    DiscountReason    ${null}
    Set To Dictionary    ${dict}    EacDate    0001-01-01T00:00:00Z
    Set To Dictionary    ${dict}    EngagementManagerId    ${main_dict['EngagementManagerId']}
    Set To Dictionary    ${dict}    EngagementManagingDirectorId    ${main_dict['EngagementManagingDirectorId']}
    Set To Dictionary    ${dict}    FscReviewerId    ${null}
    Set To Dictionary    ${dict}    Id    ${uuid4}
    Set To Dictionary    ${dict}    IsConversion    false
    Set To Dictionary    ${dict}    IsReestimating    false
    Set To Dictionary    ${dict}    IsUnitBased    false
    Set To Dictionary    ${dict}    iTracStatus    ${0}
    Set To Dictionary    ${dict}    LastWorkflowAction    ${0}
    Set To Dictionary    ${dict}    ModifiedDate    0001-01-01T00:00:00Z
    Set To Dictionary    ${dict}    Modifier    ${null}
    Set To Dictionary    ${dict}    Name    JC Budget ${ts}
    Set To Dictionary    ${dict}    OperationUnit    BPI
    Set To Dictionary    ${dict}    Permissions    ${0}
    Set To Dictionary    ${dict}    ProjectCode    ${null}
    Set To Dictionary    ${dict}    RevisedDiscount    ${0}
    Set To Dictionary    ${dict}    ServiceOffering    CPC Assessment & Roadmap Development
    Set To Dictionary    ${dict}    SolutionSegment    Capital Project Consulting
    Set To Dictionary    ${dict}    WasBusinessDeveloperInvolved    ${false}
    Set To Dictionary    ${dict}    WasEnterpriseSolutionInvolved    ${false}
    Set Log Level    INFO
    Log    ${dict}
    [Return]    ${dict}

Create Contract Link JSON Dict
    [Arguments]    ${contractid}
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    ${uuid4}=    Uuid 4
    ${date}=    Get Time    year-month-day
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.ContractLinkDto
    Set To Dictionary    ${dict}    ContractFeeType    ${null}
    Set To Dictionary    ${dict}    ContractForm    JAL
    Set To Dictionary    ${dict}    ContractId    ${contractid}
    Set To Dictionary    ${dict}    ContractVersion    Original
    Set To Dictionary    ${dict}    CreatedDate    ${date[0]}-${date[1]}-${date[2]}T00:00:01Z
    Set To Dictionary    ${dict}    HyperLink    http://ishare.protiviti.com
    Set To Dictionary    ${dict}    Id    ${uuid4}
    Set Log Level    INFO
    [Return]    ${dict}

Create Main Budget JSON Dict
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    ${uuid4}=    Uuid 4
    ${ts}=      Get Timestamp
    ${0}=    Convert To Integer    0
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.ContractDto
    Set To Dictionary    ${dict}    BusinessUnit    200
    Set To Dictionary    ${dict}    Client    JC Client
    Set To Dictionary    ${dict}    ContractHyperlink    ${null}
    Set To Dictionary    ${dict}    CreatedDate    ${ts}
    Set To Dictionary    ${dict}    Creator    ${null}
    Set To Dictionary    ${dict}    Currency    ${null}
    Set To Dictionary    ${dict}    CurrentStatus    ${0}
    Set To Dictionary    ${dict}    DeptId    10040
    Set To Dictionary    ${dict}    EngagementManagerId    03e86a2d-bbd6-4fa7-bb7d-117b2573a610
    Set To Dictionary    ${dict}    EngagementManagingDirectorId    7617778f-a7b5-4e8a-9354-4674830eabd9
    Set To Dictionary    ${dict}    EraHyperlink    ${null}
    Set To Dictionary    ${dict}    FscReviewerId    ${null}
    Set To Dictionary    ${dict}    IaNatureOfWork    Yes - Full Outsourcing
    Set To Dictionary    ${dict}    Id    ${uuid4}
    Set To Dictionary    ${dict}    ModifiedDate    ${ts}
    Set To Dictionary    ${dict}    Modifier    ${null}
    Set To Dictionary    ${dict}    Name    JC Main ${ts}
    Set To Dictionary    ${dict}    Permissions    ${0}
    Set To Dictionary    ${dict}    ProjectCode    ${null}
    Set To Dictionary    ${dict}    RateLockedDate    ${null}
    Set To Dictionary    ${dict}    RevisedDiscount    ${0}
    Set To Dictionary    ${dict}    TransactionService    Not Applicable
    #${JSON}=    Dumps    ${dict}
    Set Log Level    INFO
    [Return]    ${dict}

Create Full Shell JSON Dict
    [Arguments]    ${emGuid}    ${emdGuid}
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    ${uuid4}=    Uuid 4
    ${ts}=    Get Timestamp
    ${0}=    Convert To Integer    0
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.BudgetDto
    Set To Dictionary    ${dict}    BudgetStatus    0
    Set To Dictionary    ${dict}    Budgets    ${null}
    Set To Dictionary    ${dict}    BusinessUnit    200
    Set To Dictionary    ${dict}    BusinessUnitId    3f6bb5fd-322f-41e2-a718-82099a86357f
    Set To Dictionary    ${dict}    CanCreateOpportunity    ${false}
    Set To Dictionary    ${dict}    CanCreatePKICRequest    ${false}
    Set To Dictionary    ${dict}    CanDelete    ${false}
    Set To Dictionary    ${dict}    CanManage    ${false}
    Set To Dictionary    ${dict}    CanUnlinkERA    ${false}
    Set To Dictionary    ${dict}    CanUpdate    ${false}
    Set To Dictionary    ${dict}    CanUpdateClient    ${false}
    Set To Dictionary    ${dict}    Client    ${null}
    Set To Dictionary    ${dict}    ClientId    4b38b466-7590-4da6-e0c3-08d5e2c3cd78
    Set To Dictionary    ${dict}    ClosedDate    2019-01-01T00:00:00Z
    Set To Dictionary    ${dict}    Contract    ${null}
    Set To Dictionary    ${dict}    CreatedDate    0001-01-01T00:00:00Z
    Set To Dictionary    ${dict}    Creator    ${null}
    Set To Dictionary    ${dict}    Department    ${null}
    Set To Dictionary    ${dict}    DepartmentId    491d4e20-3037-4c1d-8a83-82f0bb075ae9
    Set To Dictionary    ${dict}    Description    'Create Draft Opportunity with all data'
    Set To Dictionary    ${dict}    EngagementManager    ${null}
    Set To Dictionary    ${dict}    EngagementManagerId    a1b8965e-c90a-477a-933a-83a08f7901f4
    Set To Dictionary    ${dict}    EngageemntManagingDirector    ${null}
    Set To Dictionary    ${dict}    EngageemntManagingDirector    a1b8965e-c90a-477a-933a-83a08f7901f2
    Set To Dictionary    ${dict}    EnterpriseCollaborators    ${null}
    Set To Dictionary    ${dict}    IaNaturalOfWork    'No - Consulting'
    Set To Dictionary    ${dict}    IsConfidential    ${false}
    Set To Dictionary    ${dict}    IsDeleted    ${false}
    Set To Dictionary    ${dict}    IsDigital    ${true}
    Set To Dictionary    ${dict}    IsManagedService    ${true}
    Set To Dictionary    ${dict}    LeadSource    ${null}
    Set To Dictionary    ${dict}    LeadSourceId    ${null}
    Set To Dictionary    ${dict}    ModifiedDate    0001-01-01T00:00:00Z
    Set To Dictionary    ${dict}    Modifier    ${null}
    Set To Dictionary    ${dict}    Name    'Test Shell'
    Set To Dictionary    ${dict}    OperationUnit    ${null}
    Set To Dictionary    ${dict}    OpportunityCloseDate    2019-01-01T00:00:00Z
    Set To Dictionary    ${dict}    OpportunityCurrency    ${null}
    Set To Dictionary    ${dict}    OpportunityCurrencyId    438aec34-ef7d-4df3-8075-c0c87485c509
    Set To Dictionary    ${dict}    OpportunityHasPrimaryKeyBuyer    ${false}
    Set To Dictionary    ${dict}    OpportunityId    ${null}
    Set To Dictionary    ${dict}    OpportunityManagingDirector    ${null}
    Set To Dictionary    ${dict}    OpportunityManagingDirectorId    a1b8965e-c90a-477a-933a-83a08f7901f2
    Set To Dictionary    ${dict}    OpportunityMessage    ${null}
    Set To Dictionary    ${dict}    OpportunityOwner    ${null}
    Set To Dictionary    ${dict}    OpportunityServices    ${null}
    Set To Dictionary    ${dict}    OpportunityStage    ${null}
    Set To Dictionary    ${dict}    OpportunityStageId    b5a282f8-1fbe-44a1-a217-da8122b7d788
    Set To Dictionary    ${dict}    OpportunityStatus    0
    Set To Dictionary    ${dict}    OpportunityUrl    ${null}
    Set To Dictionary    ${dict}    PlannedClosedDate    2019-04-15T00:00:00Z
    Set To Dictionary    ${dict}    PrimaryWinLossReasonId    ${null}
    Set To Dictionary    ${dict}    Probability    0
    Set To Dictionary    ${dict}    ProjectCode    ${null}
    Set To Dictionary    ${dict}    PursuitTeams    ${null}
    Set To Dictionary    ${dict}    RiskAssessment    ${null}
    Set To Dictionary    ${dict}    RiskAssessmentId    ${null}
    Set To Dictionary    ${dict}    RiskAssessmentUrl    ${null}
    Set To Dictionary    ${dict}    SaveCloseOppFirstTime    ${null}
    Set To Dictionary    ${dict}    ServiceAmount    ${null}
    Set To Dictionary    ${dict}    ServiceBaseCurrencyAmount    ${null}
    Set To Dictionary    ${dict}    ServiceOfferingId    f396be63-b232-40bf-a067-58403e07ddfb
    Set To Dictionary    ${dict}    Status    ${null}
    Set To Dictionary    ${dict}    TeamMessage    ${null}
    Set To Dictionary    ${dict}    TeamStatus    0
    Set To Dictionary    ${dict}    TeamUrl    ${null}
    Set To Dictionary    ${dict}    TransactionService    'Mergers, Acquisitions & Divestitures (M&A)'
    Set To Dictionary    ${dict}    Type    1
    Set To Dictionary    ${dict}    Url    ${null}
    #${JSON}=    Dumps    ${dict}
    Set Log Level    INFO
    [Return]    ${dict}

Create Contract Link Dict
    [Arguments]    ${ContractID}
    ${dict}=    Create Dictionary
    ${date}=    Get Time    year-month-day
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.ContractLinkDto
    Set To Dictionary    ${dict}    ContractID    ${ContractID}
    Set To Dictionary    ${dict}    ContractForm    JAL
    Set To Dictionary    ${dict}    ContractVersion    Original
    Set To Dictionary    ${dict}    HyperLink    http://www.google.com
    Set To Dictionary    ${dict}    ContractFeeType    ${NULL}
    Set To Dictionary    ${dict}    CreatedDate    ${date[0]}-${date[1]}-${date[2]}T00:00:01Z
    [Return]    ${dict}

Submit Sub Budget
    [Arguments]    ${sub_dict}
    ${submit_header}=    Create Submit Headers Dict
    ${workflow_dict}=    Submit Sub Dict    ${sub_dict['Id']}
    ${workflow_json}=    Convert Dictionary to JSON    ${workflow_dict}
    ${wf}=    POST Request    iBudget    /Budgets(${sub_dict['Id']})/BudgetService.Submit    headers=${submit_header}    data=${workflow_json}
    #Log    ${wf.headers}
    #Log    ${wf.content}

Get Main Data
    [Arguments]    ${engagementid}
    [Documentation]    Captures the Main data and returns a dictionary. Requires the engagement guid to reference the main.
    ${main_status}=    Check Main Budget Status    ${engagementid}
    ${g}=    Get Request    iBudget    /Contracts(${engagementid})
    Log    ${g.content}
    ${main_dict}=    Convert iBudget Response Json to Dictionary    ${g.content}
    [Return]    ${main_dict}

Submit Sub Dict
    [Arguments]    ${budgetID}
    ${dict}=    Create Dictionary
    Set To Dictionary    ${dict}    CommentForEmd    Test Comment
    Set To Dictionary    ${dict}    Comment    W Test Comment
    [Return]    ${dict}

Convert iBudget Response Json to Dictionary
    [Arguments]    ${response_json}
    ${str}=    Convert To String    ${response_json}
    ${json}=    Convert String to JSON    ${str}
    ${dict}=    Convert To Dictionary    ${json}
    [Return]    ${dict}
