*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC104a - Validate New Opportunity - Form EM EMD Fields (default behavior)
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC104a
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Employee Field Should Be Disabled    ${LEAD EMD Input}
    Employee Field Should Be Disabled    ${LEAD EM Input}
    Employee Field Should Be Disabled    ${OPP OWNER Input}
    Employee Field Should Be Disabled    ${OPP MD Input}
    Shell Select BU/Department    ${shell_dict["BU"]}    ${shell_dict["Dept"]}
    Employee Field Should Be Enabled    ${OPP OWNER Input}
    Employee Field Should Be Enabled    ${OPP MD Input}
    Employee Field Should Be Disabled    ${LEAD EMD Input}
    Employee Field Should Be Disabled    ${LEAD EM Input}
    Run Keyword If    '${shell_dict["OppMD"]}'!=''    Shell Select Opp MD    ${shell_dict["OppMD"]}
    Run Keyword If    '${shell_dict["OppOwner"]}'!=''    Shell Select Opp Owner    ${shell_dict["OppOwner"]}
    Employee Field Should Be Enabled    ${OPP OWNER Input}
    Employee Field Should Be Enabled    ${OPP MD Input}
    ${default_EMD}=    Get Value    ${LEAD EMD Input}
    ${default_EM}=    Get Value    ${LEAD EM Input}
    Should Be True    '${shell_dict["OppMD"]}'=='${default_EMD}'
    Should Be True    '${shell_dict["OppOwner"]}'=='${default_EM}'

TC104b - Validate New Opportunity - Form EM EMD Fields
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC104b
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    Shell Select BU/Department    ${shell_dict["BU"]}    ${shell_dict["Dept"]}
    Run Keyword If    '${shell_dict["OppMD"]}'!=''    Shell Select Opp MD    ${shell_dict["OppMD"]}
    Run Keyword If    '${shell_dict["OppOwner"]}'!=''    Shell Select Opp Owner    ${shell_dict["OppOwner"]}
    ${default_EMD}=    Get Value    ${LEAD EMD Input}
    ${default_EM}=    Get Value    ${LEAD EM Input}
    Should Be True    '${shell_dict["OppMD"]}'=='${default_EMD}'
    Should Be True    '${shell_dict["OppOwner"]}'=='${default_EM}'
    Run Keyword If    '${shell_dict["EMD"]}'!='' and '${shell_dict["EMD"]}'!='${shell_dict["OppMD"]}'    Shell Select EMD    ${shell_dict["EMD"]}
    Run Keyword If    '${shell_dict["EM"]}'!='' and '${shell_dict["EM"]}'!='${shell_dict["OppOwner"]}'    Shell Select EM    ${shell_dict["EM"]}

*** Keywords ***
