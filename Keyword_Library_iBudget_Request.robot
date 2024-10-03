*** Settings ***
Documentation     Keyword Library for iManage Assistant Functionality

*** Variables ***

*** Keywords ***
Create Sub
    [Arguments]         ${contractId}   ${emGuid}    ${emdGuid}
    ${subdict}=    Create Sub Budget JSON Dict  ${contractId}   ${emGuid}    ${emdGuid}
    Set Suite Variable    ${subdict}
    ${JSON}=    Convert Dictionary to JSON    ${subdict}
    ${r}=    POST Request    iBudget    /Budgets    data=${JSON}
    Log    ${r.headers}
    Log    ${r.content}

Update Sub
    [Arguments]         ${contractId}
    ${subdict}=    Create Sub Budget JSON Dict      ${contractId}
    #${r}=    GET Request    iBudget    /Budgets(${subdict["Id"]})
    ${data}=    Create Sub Update Budget JSON Dict
    ${JSON}=    Convert Dictionary to JSON    ${data}
    #${r}=    GET Request    iBudget    /Budgets(8bdc8e14-57a6-4957-b3e2-d6425bbd18cd)
    ${r}=    PATCH Request    iBudget    /Budgets(${contractId})    data=${JSON}
    Log    ${r.headers}
    Log    ${r.content}
    ${r1}=    GET Request    iBudget    /Budgets(${contractId})
    Log    ${r1.headers}
    Log    ${r1.content}

Clone Sub
    [Arguments]         ${contractId}
    #DOESN'T WORK
    ${r}=    POST Request    iBudget    /Budgets(${contractId})/BudgetService.Clone
    Log    ${r.headers}
    Log    ${r.content}

Get Sub
    [Arguments]         ${contractId}
    ${r1}=    GET Request    iBudget    /Budgets(${contractId})
    Log    ${r1.headers}
    Log    ${r1.content}

Create Sub Update Budget JSON Dict
    Set Log Level    NONE
    ${dict}=    Create Dictionary
    ${uuid4}=    Uuid 4
    ${ts}=    Get Timestamp
    ${0}=    Convert To Integer    0
    Set To Dictionary    ${dict}    @odata.type    \#Rhi.Protiviti.BudgetTool.API.Model.Dtos.BudgetDto
    Set To Dictionary    ${dict}    ProjectCode    10045106-02
    #${JSON}=    Dumps    ${dict}
    Set Log Level    INFO
    [Return]    ${dict}