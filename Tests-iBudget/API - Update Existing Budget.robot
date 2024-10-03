*** Settings ***
Suite Setup       Setup Suite
Suite Teardown    Delete All Sessions
Resource          ..\\resource.robot
Resource          ..\\Keyword_Library_iBudget.robot

*** Variables ***
${contractId}=          2bd914a9-b442-45b2-99e9-0078a24bd819
${emGuid}=      A1B8965E-C90A-477A-933A-83A08F79020F
${emdGuid}=     21363178-8ACC-44EC-8925-C6A7B4296EDE
*** Test Cases ***
TC001 - Create Sub Budget in Main Budget
    Update Sub    ${contractId}   ${emGuid}    ${emdGuid}
*** Keywords ***