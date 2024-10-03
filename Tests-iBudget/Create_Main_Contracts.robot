*** Settings ***
Suite Setup       Setup Suite
Suite Teardown    Delete All Sessions
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
Create Main
    ${maindict}=    Create Main Budget JSON Dict
    Set Suite Variable    ${maindict}
    ${JSON}=    Convert Dictionary to JSON    ${maindict}
    ${r}=    POST Request    iBudget    /Contracts    data=${JSON}
    Log    ${r.headers}
    Log    ${r.content}

GET Main
    ${r}=    GET Request    iBudget    /Contracts(${maindict["Id"]})
    Log    ${r.headers}
    Log    ${r.content}

Create Contract Link
    #DOESN'T WORK
    ${ccl}=    Create Contract Link JSON Dict    ${maindict["Id"]}
    ${JSON}=    Convert Dictionary to JSON    ${ccl}
    ${r}=    POST Request    iBudget    /ContractsLinks    data=${JSON}
    Log    ${r.headers}
    Log    ${r.content}

Delete Main
    ${response}=    DELETE Request    iBudget    /Contracts(${maindict["Id"]})
    Log    ${r.headers}
    Log    ${r.content}

*** Keywords ***
