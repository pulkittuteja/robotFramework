*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC105a - Validate New Opportunity - Form Opportunity Currency - Opp Currency same as BU Currency
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC105a
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    New Opportunity Setup Form    ${shell_dict}
    ${srv_opp_cur}=    Get Value    ${SERVICE AMOUNT OPP CUR input}
    ${srv_bu_cur}=    Get Value    ${SERVICE AMOUNT BASE CUR input}
    ${srv_opp_cur_val}=    Fetch From Left    ${srv_opp_cur}    ${SPACE}
    ${srv_bu_cur_val}=    Fetch From Left    ${srv_bu_cur}    ${SPACE}
    ${srv_opp_cur_code}=    Fetch From Right    ${srv_opp_cur}    ${SPACE}
    ${srv_bu_cur_code}=    Fetch From Right    ${srv_bu_cur}    ${SPACE}
    Should Be True    ${srv_opp_cur_val}==100000
    Should Be True    ${srv_bu_cur_val}==100000
    Should Be True    '${srv_opp_cur_code}'=='${shell_dict["OppCur"]}'
    Should Be True    '${srv_bu_cur_code}'=='${shell_dict["BaseCur"]}'

TC105b - Validate New Opportunity - Form Opportunity Currency - Different Opp Currency from BU Currency
    [Tags]    Regression    Smoke
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC105b
    ${cur_rates}=    Get Currency Rates
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button            ${shell_dict["existing"]}
    New Opportunity Setup Form    ${shell_dict}
    Sleep    3s
    ${srv_opp_cur}=    Get Value    ${SERVICE AMOUNT OPP CUR input}
    ${srv_bu_cur}=    Get Value    ${SERVICE AMOUNT BASE CUR input}
    ${srv_opp_cur_val}=    Fetch From Left    ${srv_opp_cur}    ${SPACE}
    ${srv_bu_cur_val}=    Fetch From Left    ${srv_bu_cur}    ${SPACE}
    ${srv_opp_cur_code}=    Fetch From Right    ${srv_opp_cur}    ${SPACE}
    ${srv_bu_cur_code}=    Fetch From Right    ${srv_bu_cur}    ${SPACE}
    ${convert_rate}=    Evaluate    100000*${cur_rates["${shell_dict["OppCur"]}"]}
    ${convert_rate}=    Convert to Integer    ${convert_rate}
    Run Keyword and Continue On Failure     Should Be True    ${srv_opp_cur_val}==100000
    Run Keyword and Continue On Failure     Should Be True    '${srv_bu_cur_val}'=='${convert_rate}'
    Run Keyword and Continue On Failure     Should Be True    '${srv_opp_cur_code}'=='${shell_dict["OppCur"]}'
    Run Keyword and Continue On Failure     Should Be True    '${srv_bu_cur_code}'=='${shell_dict["BaseCur"]}'

*** Keywords ***
