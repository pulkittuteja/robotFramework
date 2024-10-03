*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    DoNotRun
Resource          resource.robot

*** Variables ***

*** Test Cases ***
Shell Setup
    ${dict}=    Get Data From CSV File    ${shell_data}    TC002
    Set Shell Name Locators    ${dict}
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    Shell Setup Form    ${dict}
    Sleep    5s

Create New Shell and Link a New ERA
    ${dict}=    Get Data From CSV File    ${shell_data}    TC002
    Set Shell Name Locators    ${dict}
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    Shell Setup Form    ${dict}
    Sleep    5s

*** Keywords ***
