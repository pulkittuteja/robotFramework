*** Settings ***
Documentation     a
Suite Setup       Setup
Suite Teardown    Teardown
Test Teardown     Test Teardown
Force Tags        ITPRO    testall    DoNotRun
Resource          resource.robot

*** Variables ***

*** Test Cases ***
TC001 - Save Draft ERA
    [Tags]    Smoke
    ${dict}=    Get Data From CSV File    ${era_data}    TC001
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    #Verify Filter List - By ERA Name    ${ERA NAME}    Draft

TC002 - Normal ERA Complete
    [Tags]    Smoke
    ${dict}=    Get Data From CSV File    ${era_data}    TC002
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}

TC010 - Save ERA with Only data filled in Client Info & Part 1 Tab - 6c - YES
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC010
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE Button}
    Verify Header Section Rating    ${dict}

TC011 - Save ERA with Only data filled in Client Info & Part 1 Tab - 6c - NO
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC011
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE Button}
    Verify Header Section Rating    ${dict}

TC012 - ERA with Estimated Net fees with Less than $500k
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC012
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    #Validate Part 1 Questions    ${dict}
    #Click Button    ${SAVE Button}
    Verify Header Section Rating    ${dict}

TC013 - ERA with Estimated Duration is between 6-12 months
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC013
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    #Validate Part 1 Questions    ${dict}
    #Click Button    ${SAVE Button}
    Verify Header Section Rating    ${dict}

TC014 - ERA with High - New Client YES
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC014
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC015 - ERA with High - Existing Client YES
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC015
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC016 - ERA with Normal - Existing Client - NO
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC016
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC017 - ERA with High - Conflict of Interest - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC017
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC018 - ERA with High - Known Other Reasons - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC018
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC019 - ERA with Normal - Engagment Mgmt Team - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC019
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC020 - ERA with Increased - Engagement Mgmt Team - NoYes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC020
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC021 - ERA with High - Engagement Mgmt Team -NoNo
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC021
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC022 - ERA with Normal - PCI - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC022
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Wait Until Keyword Succeeds    60s    2s    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC023 - ERA with Increased - PCI - NoYes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC023
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC024 - ERA with High - PCI - NoNo
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC024
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC025 - ERA with Normal - Financial Model Validation Engagement - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC025
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC026 - ERA with Increased - Financial Model Validation Engagement - NoYes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC026
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC027 - ERA with High -Financial Model Validation Engagement - NoNo
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC027
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC028 - ERA with Normal -M&A - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC028
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC029 - ERA with Increased - M&A - NoYes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC029
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC030 - ERA with High - M&A - NoNo
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC030
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC031 - ERA with Normal - Eng Mgmt - Ind Comp - YesYes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC031
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC032 - ERA with Increased - Eng Mgmt - Ind Comp - NoYes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC032
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC033 - ERA with High - Eng Mgmt - Ind Comp - NoNo
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC033
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC034 - ERA with High -Ven & Pen Test
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC034
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC035 - ERA with Increased - New Tech Tools Use or Procurement of IT- Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC035
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC036 - ERA with High - Outsourcing HR Transaction - YES
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC036
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC037 - ERA with High - Loan Staff - No
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC037
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC038 - ERA with Normal - Loan Staff - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC038
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC039 - ERA with High - Software Resale - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC039
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC040 - ERA with Increased - Reporting Rating- Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC040
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC041 - ERA with Increased - Cross Border - 8a - No
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC041
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC042 - ERA with Normal - Cross Border - 8a - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC042
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC043 - ERA with Increased - Cross Border - 8b - No
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC043
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC044 - ERA with Normal - Cross Border - 8b- Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC044
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC045 - ERA with Increased - Unrealistic Restrictions - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC045
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC046 - ERA with Increased - 3rd Party Impacts - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC046
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC047 - ERA with High - Fraud Atorney Eng - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC047
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC048 - ERA with Increased - Expert Witness - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC048
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC049 - ERA with Increased - Regulatory Risk - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC049
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC050 - ERA with Increased - Govt Eng - Yes
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC050
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC051 - ERA with High - Govt Contract Review - No
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC051
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC052 - ERA with Increased -Non Standard Fee Arrangements - Yes (13)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC052
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC053 - ERA with Increased - People Risk - Yes (5)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC053
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC054 - ERA with Increased - Specialized Contract Provision - Yes (15)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC054
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC055 - ERA with High - Responsibility of Information - Yes (16a-1)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC055
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC056 - ERA with High - Distribution of Deliverables - Yes (16a-2)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC056
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC057 - ERA with High - Indemnification - Yes (16a-3)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC057
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC058 - ERA with High - Limitation of Liability - Yes ( 16a-4)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC058
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC059 - ERA with High - Warranties - Yes (16a-5)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC059
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC060 ERA with High - Proprietary Rights in Deliverables & Data - Yes (16a-6)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC060
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC061 - ERA with Increased - Restrictions on Services for Others - Yes (16b)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC061
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC062 - ERA with High - Data Security/Privacy/ Retention Req - Yes (17a)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC062
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC063 - ERA with High - PII/PHI/ Sensitive Data Access - Yes (17b)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC063
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC064 - ERA with High - Deliverables Access w/o NDA - Yes (18)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC064
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC065 - ERA with Increased - Use of Sub Contractors - Yes (19)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC065
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC066 - ERA with Increased - Negative Impacts on Parties w/o Liability Release- Yes (20)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC066
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC067 - ERA with Increased - Special Regulatory or Legal Issues - Yes (21)
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC067
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 1 Questions    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Validate Part 2 Questions    ${dict}
    Verify Header Section Rating    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete RMAP Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete QCMD Plan Section    ${dict}
    Click Button    ${SAVE & NEXT Button}
    Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Approve ERA    ${dict}
    Sleep    2s

TC101 - Save Draft ERA with Missing Required Data - ERA Name
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC101
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    Wait Until Page Contains Element    ${BOTTOM ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${BOTTOM ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE

TC102 - Save Draft ERA with Missing Required Data - Client Name
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC102
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    Wait Until Page Contains Element    ${BOTTOM ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${BOTTOM ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE

TC103 -Save Draft ERA with Missing Required Data - EMD
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC103
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    Wait Until Page Contains Element    ${BOTTOM ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${BOTTOM ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE

TC104 -Save Draft ERA with Missing Required Data - EM
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC104
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Button    ${SAVE Button}
    Wait Until Page Contains Element    ${BOTTOM ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${BOTTOM ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE

TC105 - Submit ERA with Missing Data - Client Legal Structure
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC105
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC106 - Submit ERA with Missing Data - Client Size
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC106
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC107 - Submit ERA with Missing Data - Engagement Desc
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC107
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC108 - Submit ERA with Missing Data - Salesforce Opportunity
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC108
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC109 - Submit ERA with Missing Data - Principal Country- Job Contracted
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC109
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC110 - Submit ERA with Missing Data - Principal Country- Work Performed
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC110
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC111 - Submit ERA with Missing Data - MSA Required
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC111
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC112 - Submit ERA with Missing Data - Statement of Work Required
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC112
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC113 - Submit ERA with Missing Data - Estimated Duration
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC113
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC114 - Submit ERA with Missing Data - Contribution Margin Percentage
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC114
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    #Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC115 - Submit ERA with Missing Data - Estimated Net Fees
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC115
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC116 - Submit ERA with Director as EMD - QC MD should be required
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC116
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC117 - Submit ERA with Sr. Director as EMD - QC MD should be required
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC117
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC118 - Save Draft ERA with alpha character in Contribution Margin Percentage field
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC118
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    #Click Save and Next Button
    #Validate Part 1 Questions    ${dict}
    #Click Save and Next Button
    #Validate Part 2 Questions    ${dict}
    #Click Save and Next Button
    #Complete RMAP Section    ${dict}
    #Click Save and Next Button
    #Complete QCMD Plan Section    ${dict}
    #Click Save and Next Button
    #Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    #Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC119 - Save Draft ERA with value >100 in Contribution Margin Percentage field
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC119
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    #Click Save and Next Button
    #Validate Part 1 Questions    ${dict}
    #Click Save and Next Button
    #Validate Part 2 Questions    ${dict}
    #Click Save and Next Button
    #Complete RMAP Section    ${dict}
    #Click Save and Next Button
    #Complete QCMD Plan Section    ${dict}
    #Click Save and Next Button
    #Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    #Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC120 - Save Draft ERA with -ve value in Contribution Margin Percentage field
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC120
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    #Click Save and Next Button
    #Validate Part 1 Questions    ${dict}
    #Click Save and Next Button
    #Validate Part 2 Questions    ${dict}
    #Click Save and Next Button
    #Complete RMAP Section    ${dict}
    #Click Save and Next Button
    #Complete QCMD Plan Section    ${dict}
    #Click Save and Next Button
    #Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    #Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

?? TC121 - Save Draft ERA with 0 value in Contribution Margin Percentage field
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC121
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    #Click Save and Next Button
    #Validate Part 1 Questions    ${dict}
    #Click Save and Next Button
    #Validate Part 2 Questions    ${dict}
    #Click Save and Next Button
    #Complete RMAP Section    ${dict}
    #Click Save and Next Button
    #Complete QCMD Plan Section    ${dict}
    #Click Save and Next Button
    #Complete Summary Section    ${dict}
    Click Button    ${SAVE Button}
    #Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    #Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC122 - Submit ERA with 0 value in Contribution Margin Percentage field
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC122
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC123 - Submit ERA with incomplete Form - Part 1
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC123
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC124 - Submit ERA with incomplete Form - Part 2
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC124
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC125 - Submit ERA with incomplete Form - RMAP
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC125
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC126 - Submit ERA with incomplete Form - QCMD Plan
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC126
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC127 - Submit ERA with incomplete Form - Final Summary QCMD
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC127
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC128 - Submit ERA with incomplete Form - Final Summary QRM MD
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC128
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC129 - Submit ERA after changing Final Summary
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC129
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC130 - Submit ERA after changing Final Summary but not entering any comments
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC130
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    Click Save and Next Button
    Validate Part 1 Questions    ${dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${dict}
    Click Save and Next Button
    Complete RMAP Section    ${dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${dict}
    Click Save and Next Button
    Complete Summary Section    ${dict}
    Input Text    ${FRAR Textarea}    ${EMPTY}
    #Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Element should be Enabled    ${SUBMIT TO EMD Button}
    Click Button    ${SUBMIT TO EMD Button}
    Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Run Keyword And Continue On Failure    Element Should Contain    ${TOP ERROR MSG Label}    ${dict["onsrceen_msg"]}
    ##Run Keyword And Continue On Failure    Page Should Contain    ${dict["onsrceen_msg"]}    loglevel=NONE
    #Approve ERA    ${dict}

TC131 - Save ERA with Invalid Format - Salesforce Opportunity
    [Tags]    Regression
    ${dict}=    Get Data From CSV File    ${era_data}    TC131
    Set ERA Approval Locators    ${dict}
    Click ERA Tile
    Click Button    ${CREATE NEW ERA Btn}
    Wait Until Page Contains Element    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${dict}
    #Click Save and Next Button
    #Validate Part 1 Questions    ${dict}
    #Click Save and Next Button
    #Validate Part 2 Questions    ${dict}
    #Click Save and Next Button
    #Complete RMAP Section    ${dict}
    #Click Save and Next Button
    #Complete QCMD Plan Section    ${dict}
    #Click Save and Next Button
    #Complete Summary Section    ${dict}
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
Click Save and Next Button
    Wait Until Page Contains Element    ${SAVE & NEXT Button}    30s
    Wait Until Keyword Succeeds    30s    2s    Click Button    ${SAVE & NEXT Button}
    #Click Button    ${SAVE & NEXT Button}
