*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    Shell
Resource          ..\\resource.robot

*** Variables ***

*** Test Cases ***
TC302 - Create Draft Shell with all data
    [Tags]    Seeding
    Login in as juscol01@roberthalf.com
    ${datalist}=    Read Csv File To List    ${shell_seed_data}
    ${l}=    Get Length    ${datalist}
    Click My Opp and Engage Tile
    : FOR    ${i}    IN RANGE    1    ${l}
    \    ${shell_dict}=    Get Data From CSV File    ${shell_seed_data}    TC${i}
    \    Set Shell Name Locators    ${shell_dict}
    \    Click Button    ${CREATE NEW SHELL Btn}
    \    #Run Keyword And Continue On Failure    Element Should Not Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    \    #Run Keyword And Continue On Failure    Element Should Not Be Visible    ${DELETE DRAFT Btn}
    \    #Run Keyword And Continue On Failure    Element Should Not Be Visible    ${HAMBURGER Btn}
    \    Shell Setup Form    ${shell_dict}
    \    Sleep    1s
    \    #Cancel Basic Authentication
    \    #Run Keyword And Continue On Failure    Element Should Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    \    #Run Keyword And Continue On Failure    Element Should Be Visible    ${DELETE DRAFT Btn}
    \    #Run Keyword And Continue On Failure    Element Should Be Visible    ${HAMBURGER Btn}
    \    Sleep    2s
    \    Click Element    //span[text()="My Opportunities & Engagements"]

*** Keywords ***
