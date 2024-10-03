*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    ERA
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
# Obsolete because SalesForce link is no longer in ERA
TC131 - Save ERA with Invalid Format - Salesforce Opportunity - Obsolete
    Comment     Obsolete because SalesForce link is no longer in ERA
    [Tags]    Regression    error
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${dict}=    Get Data From CSV File    ${era_data}    TC131
    Set ERA Approval Locators    #${dict}
    #Click ERA Tile
    #Click Button    ${CREATE NEW ERA Btn}
    Create Draft Shell With All Data        #Runs function to create Shell with TC102 data
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    #Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    #Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${SF OPPORTUNITY ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${SF OPPORTUNITY ERROR MSG Label}    ${dict["onsrceen_msg"]}
    Wait Until Page Contains Element    ${BOTTOM ERROR MSG2 Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${BOTTOM ERROR MSG2 Label}    ${dict["onsrceen_msg2"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

*** Keywords ***
