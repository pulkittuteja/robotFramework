*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.
Library           SeleniumLibrary
Library           ExcelLibrary
Library           String
Library           FakerLibrary
Library           Collections
Library           CSVLib
Library           OperatingSystem
Library           Dialogs
Library           RequestsLibrary
Library           DatabaseLibrary
Library           DateTime
Library           JSONLibrary
Library           JsonValidator
Library           iBudgetCalculations.py
Resource          locators.robot
Resource          Keyword_Library_Assistant.robot
Resource          Keyword_Library_Shell.robot
Resource          Keyword_Library_ERA.robot
Resource          Keyword_Library_ERA_Questions.robot
Resource          Keyword_Library_ERA_Approval.robot
Resource          Keyword_Library_ChangeOrder.robot
Resource          Keyword_Library_iBudget_Requests.robot
Resource          Keyword_Library_iBudget.robot
Resource          Keyword_Library_iBudget_re-estimation.robot
Library           DateTime
Library           JSONLibrary
Library           JsonValidator
Library           Collections
Library           String

*** Variables ***
${PROD_URL}       TBD
${DEV_URL}        \
${TEST_URL}       \
${UAT_URL}        \
${STG_URL}        \
${CRM_URL}        \
${PROD_ERA_URL}    TBD
${DEV_ERA_URL}    \
${TEST_ERA_URL}    \
${UAT_ERA_URL}    TBD
${STG_ERA_URL}    TBD
${CRM_ERA_URL}    \
${iBudget_URL_DEV}    \
${ENV_ERROR_MSG}    The test environment "${ENV}" is not recognized. Must be either DEV, TEST, STG or PROD (not case sensitive). Please set the \${ENV} variable as a run command argument (ie -v ENV:test)
${ROLE_ERROR_MSG}    The ROLE is not recognized. Must be either EMD, EM, QRMMD, QCMD, GLMD, RMD or ADMIN (not case sensitive).
${Region_ERROR_MSG}    The Region "${Region}" provided is not Recognized. Must be either NA, APAC, AMEA (not case sensitive). Please set the \${Region} variable as a run command argument (ie -v Region:na)
${DELAY}          .5s
${ERA_DATA}       ${CURDIR}\\Data\\ERA_data.csv
${ERA_DEV_DATA}    ${CURDIR}\\Data\\ERA_DEV_data.csv
${ERA_UAT_DATA}    ${CURDIR}\\Data\\ERA_UAT_data.csv
${ERA_STG_DATA}    ${CURDIR}\\Data\\ERA_STG_data.csv
${SHELL_DATA_NA}    ${CURDIR}\\Data\\Shell_data_NA.csv
${SHELL_DATA_APAC}    ${CURDIR}\\Data\\Shell_data_APAC.csv
${SHELL_DATA_OLD}    ${CURDIR}\\Data\\shell_data_old.csv
${PASS_LOCAL}     ${CURDIR}\\Data\\Pass_Local.csv
${era_seed_data}    ${CURDIR}\\Data\\ERA_SEED_data.csv
${shell_seed_data}    ${CURDIR}\\Data\\SHELL_SEED.csv
${APPRV_DATA}     ${CURDIR}\\Data\\Approvers.csv
${SHELL_DICT_DATA}    ${CURDIR}\\Data\\shellDictData.csv
${SERVOFF_DATA}    ${CURDIR}\\Data\\ServiceOfferings.csv
${CO_DATA}        ${CURDIR}\\Data\\Change-Order_Data.csv
${SUB_BUDGET_DATA_NA}    ${CURDIR}\\Data\\sub-budget_data_File_NA.csv
${SUB_BUDGET_DATA_APAC}    ${CURDIR}\\Data\\sub-budget_data_File_APAC.csv
${IBUDGET_CONTRACT_RATE}    ${CURDIR}\\Data\\iBudget_Contract_Rate.csv
${IBUDGET RESOURCE DATA}    ${CURDIR}\\Data\\Sub-Budget Resource-Data.csv
${IBUDGET_RE-ESTIMATION_DATA}    ${CURDIR}\\Data\\iBudget_Re-estimation_data.csv
${LONG MSG}       NEW YORK
${HasSelOppBtn}    dev
${ts}             Get Timestamp
${DOMAIN}         NA
${SHELL_REQUEST_DATA}    ${CURDIR}\\Data\\Shell_request_data.csv
${SO_DATASHEET}    ${CURDIR}\\Data\\Shell_Opp_Service_Data.csv
${ERA_REQUEST_DATA}    ${CURDIR}\\Data\\ERA_request_questions_data.csv
${IBUDGET_LABOR_DATA}    ${CURDIR}\\Data\\iBudget_Request_Sub_Labor.csv
${IBUDGET_RATE_DATA}    ${CURDIR}\\Data\\iBudget_Request_Contract_Rate.csv
${LEAD_SOURCE_DATA}    ${CURDIR}\\Data\\lead_source_data.csv
${SFDC_DATA}      ${CURDIR}\\Data\\SFDCCredentials.csv
@{q_names}        q1a    q1b    q2    q3    q4a    q4a1    q4a2    q4a3    q4b    q4c    q5    q6a    q6b    q6c    q6d    q7    q8a
...               q8b    q9    q10    q11a    q11b    q11c    q12    q13    q14    q15    q16a    q16a1    q16a2    q16a3    q16a4    q16a5    q16a6
...               q16b    q17a    q17b    q18    q19    q20    q21
@{steps}          Step 1    Step 2    Step 3
${SFDC-ERA-URL-DEV}    https://protiviti--apptest.cs14.my.salesforce.com/a0Dtestedtested0016
${SFDC-ERA-URL-QA}    https://protiviti--qatest.cs96.my.salesforce.com/a0Dtestedtested0016

*** Keywords ***
Setup
    [Documentation]    Initial setup keyword to assign the environmental variables and path to the data sheets based on environment to be tested.
    Assign Environment Variables
    Assign Datasheet Path
    Assign Region Datasheet Path for iManage & iBudget
    #Open Browser To Home Page

Assign Environment Variables
    [Documentation]    Sets the environmental variables based on test environment selected. This keyword expects the variable \${ENV} to be set at launch.
    ...    \${ENV} must be either DEV, TEST, STG or PROD (not case sensitive)
    Set Log Level    NONE
    #${env_variables}=    Get Environment Variables
    #Set Suite Variable    ${COMPUTERNAME}    ${env_variables["COMPUTERNAME"]}
    Run Keyword If    '${ENV.upper()}' != 'TEST' and '${ENV.upper()}' != 'DEV' and '${ENV.upper()}' != 'UAT' and '${ENV.upper()}' != 'STG' and '${ENV.upper()}' != 'PROD' and '${ENV.upper()}' != 'CRM'    Set Log Level    INFO
    Run Keyword If    '${ENV.upper()}' != 'TEST' and '${ENV.upper()}' != 'DEV' and '${ENV.upper()}' != 'UAT' and '${ENV.upper()}' != 'STG' and '${ENV.upper()}' != 'PROD' and '${ENV.upper()}' != 'CRM'    Fatal Error    ${ENV_ERROR_MSG}
    ${ENV_URL}=    Set Variable If    "${ENV.upper()}" == "TEST"    ${TEST_URL}    "${ENV.upper()}" == "DEV"    ${DEV_URL}    "${ENV.upper()}" == "UAT"    ${UAT_URL}    "${ENV.upper()}" == "STG"    ${STG_URL}    "${ENV.upper()}" == "PROD"    ${PROD_URL}    "${ENV.upper()}" == "CRM"    ${CRM_URL}
    ${ENV_ERA_URL}=    Set Variable If    "${ENV.upper()}" == "TEST"    ${TEST_ERA_URL}    "${ENV.upper()}" == "DEV"    ${DEV_ERA_URL}    "${ENV.upper()}" == "UAT"    ${UAT_ERA_URL}    "${ENV.upper()}" == "STG"    ${STG_ERA_URL}    "${ENV.upper()}" == "PROD"    ${PROD_ERA_URL}    "${ENV.upper()}" == "CRM"    ${CRM_ERA_URL}
    Set Global Variable    ${ENV_URL}
    Set Global Variable    ${ENV_ERA_URL}
    Set Database Name for iManage & ibudget    ${ENV}
    Set Log Level    INFO

Set Database Name for iManage & ibudget
    [Arguments]    ${ENV}
    Set Log Level    NONE
    ${iManage_db}=    Set Variable If    "${ENV.upper()}" == "TEST"    imanagedb_qa    "${ENV.upper()}" == "DEV"    imanagedb
    ${iBudget_db}=    Set Variable If    "${ENV.upper()}" == "TEST"    ibudgetdb_qa    "${ENV.upper()}" == "DEV"    ibudgetdb
    Set Global Variable    ${iManage_db}
    Set Global Variable    ${iBudget_db}
    Set Log Level    INFO

Assign Datasheet Path
    [Documentation]    Sets the path to the data sheets based on test environment selected. This keyword expects the variable \${ENV} to be set at launch.
    ...    \${ENV} must be either DEV, TEST, STG or PROD (not case sensitive)
    Set Log Level    NONE
    #${env_variables}=    Get Environment Variables
    #Set Suite Variable    ${COMPUTERNAME}    ${env_variables["COMPUTERNAME"]}
    Run Keyword If    '${ENV.upper()}' != 'TEST' and '${ENV.upper()}' != 'DEV' and '${ENV.upper()}' != 'UAT' and '${ENV.upper()}' != 'STG' and '${ENV.upper()}' != 'PROD' and '${ENV.upper()}' != 'CRM'    Set Log Level    INFO
    Run Keyword If    '${ENV.upper()}' != 'TEST' and '${ENV.upper()}' != 'DEV' and '${ENV.upper()}' != 'UAT' and '${ENV.upper()}' != 'STG' and '${ENV.upper()}' != 'PROD' and '${ENV.upper()}' != 'CRM'    Fatal Error    ${ENV_ERROR_MSG}
    ${ERA_DATA}=    Set Variable If    "${ENV.upper()}" == "TEST"    ${ERA_DATA}    "${ENV.upper()}" == "DEV"    ${ERA_DATA}    "${ENV.upper()}" == "UAT"    ${ERA_UAT_DATA}    "${ENV.upper()}" == "STG"    ${ERA_STG_DATA}    "${ENV.upper()}" == "PROD"    TBD    "${ENV.upper()}" == "CRM"    ${ERA_DATA}
    Set Global Variable    ${ERA_DATA}
    Set Log Level    INFO

Assign Region Datasheet Path for iManage & iBudget
    [Documentation]    Sets the path to the data sheets based on region selected. This keyword expects the variable \${Region} to be set at launch.
    ...    \${Region} must be either NA, APAC or AMEA (not case sensitive)
    Set Log Level    NONE
    Run Keyword If    '${Region.upper()}' != 'NA' and '${Region.upper()}' != 'APAC' and '${Region.upper()}' != 'AMEA'    Fatal Error    ${Region_ERROR_MSG}
    ${iManage_Shell_Data}=    Set Variable If    "${Region.upper()}" == "NA"    ${SHELL_DATA_NA}    "${Region.upper()}" == "APAC"    ${SHELL_DATA_APAC}    "${Region.upper()}" == "AMEA"    TBD
    ${iBudget_sub_Data}=    Set Variable If    "${Region.upper()}" == "NA"    ${SUB_BUDGET_DATA_NA}    "${Region.upper()}" == "APAC"    ${SUB_BUDGET_DATA_APAC}    "${Region.upper()}" == "AMEA"    TBD
    Set Global Variable    ${iManage_Shell_Data}
    Set Global Variable    ${iBudget_sub_Data}
    Set Log Level    INFO

Open Browser To Home Page
    [Documentation]    Opens a browser based on the selected on \${BROWSER} selected at launch. this keyword requires 3-5 variables:
    ...    \${REMOTE} (Defaults to FALSE but can be overwritten as a execution param),
    ...    \${ENV_URL}(set in Assign Environment Variables keyword),
    ...    \${BROWSER} (set as a execution param).
    ...    If \${REMOTE} is TRUE then the keyword requires a port and host to the selenium grid.
    Random Sleep
    Run Keyword If    '${REMOTE.upper()}'=='FALSE'    Open Browser    ${ENV_URL}    ${BROWSER}    desired_capabilities=ie.ensureCleanSession:true
    Run Keyword If    '${REMOTE.upper()}'=='TRUE'    Open Browser    ${ENV_URL}    ${BROWSER}    remote_url=http://${HOST}:${PORT}/wd/hub    desired_capabilities=ie.ensureCleanSession:true
    Delete All Cookies
    #Set Window Size    1200    1000
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Scroll Page To Location
    [Arguments]    ${x_location}    ${y_location}
    Execute JavaScript    window.scrollTo(${x_location},${y_location})

Get Approver Roles
    [Arguments]    ${approver_row}
    [Documentation]    Creates a Global dictionary '\${APPROVERS}'
    Set Log Level    NONE
    ${APPROVERS}=    Get Data From CSV File    ${APPRV_DATA}    Role    ${approver_row}
    Set Global Variable    ${APPROVERS}
    Set Log Level    INFO

Login in as ${role}
    [Documentation]    Validates the role being entered (EM, EMD, QRMMD, QCMD, GLMD, RMD or ADMIN).
    Set Log Level    NONE
    Set Global Variable    ${ACTIVE_ROLE}    ${role}
    Open Browser To Home Page
    Run Keyword If    '${role.upper()}' != 'EMD' and '${role.upper()}' != 'EM' and '${role.upper()}' != 'QRMMD' and '${role.upper()}' != 'QCMD' and '${role.upper()}' != 'GLMD' and '${role.upper()}' != 'RMD' and '${role.upper()}' != 'ADMIN' and '${role.upper()}' != 'MINE'    Set Log Level    INFO
    Run Keyword If    '${role.upper()}' != 'EMD' and '${role.upper()}' != 'EM' and '${role.upper()}' != 'QRMMD' and '${role.upper()}' != 'QCMD' and '${role.upper()}' != 'GLMD' and '${role.upper()}' != 'RMD' and '${role.upper()}' != 'ADMIN' and '${role.upper()}' != 'MINE'    Fatal Error    ${ROLE_ERROR_MSG}
    ${role_email}=    Set Variable If    "${role.upper()}" == "EMD"    ${APPROVERS["EMDEMAIL"]}    "${role.upper()}" == "EM"    ${APPROVERS["EMEMAIL"]}    "${role.upper()}" == "QRMMD"    ${APPROVERS["QRMMDEMAIL"]}    "${role.upper()}" == "QCMD"    ${APPROVERS["QCMDEMAIL"]}    "${role.upper()}" == "GLMD"    ${APPROVERS["GLMDEMAIL"]}    "${role.upper()}" == "RMD"    ${APPROVERS["RMDEMAIL"]}    "${role.upper()}" == "ADMIN"    ${APPROVERS["ADMINEMAIL"]}    "${role.upper()}" == "MINE"
    ...    ${APPROVERS["MINEEMAIL"]}
    ${ACTIVEUSER}=    Set Variable If    "${role.upper()}" == "EMD"    ${APPROVERS["EMD"]}    "${role.upper()}" == "EM"    ${APPROVERS["EM"]}    "${role.upper()}" == "QRMMD"    ${APPROVERS["QRMMD"]}    "${role.upper()}" == "QCMD"    ${APPROVERS["QCMD"]}    "${role.upper()}" == "GLMD"    ${APPROVERS["GLMD"]}    "${role.upper()}" == "RMD"    ${APPROVERS["RMD"]}    "${role.upper()}" == "ADMIN"    ${APPROVERS["ADMIN"]}    "${role.upper()}" == "MINE"
    ...    ${APPROVERS["MINE"]}
    Set Global Variable    ${ACTIVEUSER}
    Set Log Level    INFO
    Login Setup
    ${pass}=    Get Password    ${role_email}
    Login to Microsoft    ${role_email}    ${pass}

Login Setup
    [Documentation]    Sets up the test to start from the azure login page
    Set Log Level    NONE
    Sleep    10s
    ${a}=    Run Keyword And Ignore Error    Page Should Contain Element    ${LOGOUT Link}    loglevel=NONE
    ${b}=    Run Keyword And Ignore Error    Page Should Contain Element    ${MSL BACK ARROW Btn}    loglevel=NONE
    ${c}=    Run Keyword And Ignore Error    Page Should Contain Element    ${MSL USERNAME Input}    loglevel=NONE
    ${d}=    Run Keyword And Ignore Error    Page Should Contain Element    ${MSL USE ANOTHER ACCOUNT}    loglevel=NONE
    Run Keyword If    '${a[0].upper()}'=='PASS'    Log User Out
    ...    ELSE IF    '${b[0].upper()}'=='PASS'    Run Keywords    Click Element    ${MSL BACK ARROW Btn}
    ...    AND    Wait Until Page Contains Element    ${MSL USE ANOTHER ACCOUNT}    5s
    ...    AND    Click Element    ${MSL USE ANOTHER ACCOUNT}
    ...    ELSE IF    '${d[0].upper()}'=='PASS'    Click Element    ${MSL USE ANOTHER ACCOUNT}
    Sleep    2s
    Set Log Level    INFO

Login to Microsoft
    [Arguments]    ${username}    ${pass}
    Set Selenium Speed    .25
    Set Log Level    NONE
    ${na_username}=    Fetch From Right    ${username}    @
    Set Suite Variable    ${na_username}    #this variable is to be used to handle the basic authentication popup when needed
    Wait Until Page Contains Element    ${MSL USERNAME Input}    5s
    Input Text    ${MSL USERNAME Input}    ${username}
    Click Element    ${MSL NEXT Btn}
    Sleep    5s
    Wait Until Page Contains Element    ${MSL PASSWORD Input}    5s
    Input Password    ${MSL PASSWORD Input}    ${pass}
    Click Element    ${MSL SIGN IN Btn}
    Run Keyword And Ignore Error    Run Keyword If    '${BROWSER.upper()}'=='CHROME'    Wait Until Page Contains Element    //input[@value='Yes']    30s    #required for Chrome, not for IE.
    Run Keyword And Ignore Error    Run Keyword If    '${BROWSER.upper()}'=='CHROME'    Click Element    //input[@value='Yes']    #required for Chrome, not for IE.
    Set Log Level    INFO
    Set Selenium Speed    ${DELAY}

Get Password
    [Arguments]    ${ID}
    ${PASS}=    Get Data From CSV File    ${PASS_LOCAL}    User    A1
    Log    ${PASS}
    [Return]    &{PASS}[${ID}]

Login to existing Shell
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click My Opp and Engage Tile

Log User Out
    Set Log Level    NONE
    Click Element    ${LOGOUT Link}
    Wait Until Page Contains Element    ${MSL SIGNOUT Txt}    30s
    Sleep    2s
    Go To    ${ENV_URL}
    Wait Until Page Contains Element    ${MSL USE ANOTHER ACCOUNT}    30s
    Click Element    ${MSL USE ANOTHER ACCOUNT}
    Set Log Level    INFO

Teardown
    Run Keyword And Ignore Error    Handle Alert    action=DISMISS    timeout=2s
    Close All Browsers

Test Teardown
    Set Log Level    NONE
    Go To    ${ENV_URL}
    Run Keyword And Ignore Error    Handle Alert    action=DISMISS    timeout=2s
    Set Log Level    INFO

Random Sleep
    ${r}=    Evaluate    random.randint(500, 4000)    random,sys
    Sleep    ${r}milliseconds

Random Picker
    [Arguments]    ${sheet}
    ${sheet}=    Convert To Uppercase    ${sheet}
    Open Excel    ${CREATEFILE}
    ${rc}=    Get Row Count    ${sheet}
    ${r}=    Evaluate    random.randint(0, ${rc}-1)    random,sys
    ${value}=    Read Cell Data By Coordinates    ${sheet}    0    ${r}
    [Return]    ${value}

Random Number
    ${r}=    Evaluate    random.randint(10000000, 99999999)    random,sys
    [Return]    ${r}

Combine Dictionaries
    [Arguments]    ${taget_dict}    ${source_dict}
    Set Log Level    NONE
    Set Selenium Speed    0
    ${keyslist}=    Get Dictionary Keys    ${source_dict}
    FOR    ${i}    IN    @{keyslist}
        Set To Dictionary    ${taget_dict}    ${i}    ${source_dict["${i}"]}
    END
    Set Selenium Speed    ${DELAY}
    Set Log Level    INFO
    [Return]    ${taget_dict}

Get TimeStamp
    [Documentation]    This keyword returns a timestamp variable. The main purpose is to append to Shell and ERA names to avoid duplication.
    ${timestamp}=    Evaluate    int(time.time())    time
    [Return]    ${timestamp}

Get Data From CSV File
    [Arguments]    ${datafile}    ${Key}    ${TestCaseNum}=${empty}
    [Documentation]    This keyword creates a data dictionary from a given line in a CSV file. Requires a valid datafile location and a test case number to execute.
    ...    The keyword will fail if no datafile path is given. The test case number defaults to EMPTY if a test case number is not given and the will exit from the
    ...    keyword without a failure. This is to accomadate the use of this keyword for data seeding activities.
    ...    Step 1) Evaluates the arguments and will exit if TC# is missing
    ...    Step 2) Reads the entire CSV file into memory as a list
    ...    Step 3) Sets the data read row variable based on the given TC#
    ...    Step 4) Gets the first row (index 0) from the list which are the column headers which will be used for the data dictionary keys
    ...    Step 5) Gets the data from the given read row which will be used for the data dictionary values
    ...    Step 6) Loops throught the length of the list and the key:value pairs to a data dictionary
    ...    Returns the data dictionary
    ...    NOTE: this needs to be updated to return an error msg if the given TC# is not found. Currently it will not fail and return the data from the last line of
    ...    data file.
    Run Keyword If    '${TestCaseNum}'=='${empty}'    Log    ERA Data Dictionary is empty. Returning from Keyword
    Run Keyword If    '${TestCaseNum}'=='${empty}'    Return From Keyword
    Run Keyword If    '${Key}'=='${empty}'    Log    ERA Data Dictionary Key is empty. Returning from Keyword
    Run Keyword If    '${Key}'=='${empty}'    Return From Keyword
    #Set Log Level    NONE
    ${dict}=    Read csv as dictionary    ${datafile}    ${Key}    ${TestCaseNum}
    #Set Log Level    INFO
    [Return]    ${dict}

Get Dictionary Data From CSV in Lateral Format
    [Arguments]    ${datafile}    ${TestCaseNum}
    Set Log Level    NONE
    ${d}=    Create Dictionary
    ${data}=    Read Csv As List    ${datafile}    ,
    ${readrow}=    Get Read Row    ${data}    ${TestCaseNum}
    ${col}=    Get From List    ${data}    0
    ${row}=    Get From List    ${data}    ${readrow}
    ${l}=    Get Length    ${col}
    FOR    ${i}    IN RANGE    1    ${l}
        ${k}=    Get From List    ${col}    ${i}
        ${v}=    Get From List    ${row}    ${i}
        Set To Dictionary    ${d}    ${k}    ${v.strip()}
    END
    Set Log Level    INFO
    [Return]    ${d}

Get Row Data From CSV
    [Arguments]    ${datafile}    ${TestCaseNum}
    #Set Log Level    NONE
    ${data}=    Read Csv As List    ${datafile}
    ${row}=    Get Read Row    ${data}    ${TestCaseNum}
    ${d}=    Get From List    ${data}    ${row}
    #Set Log Level    INFO
    [Return]    ${d}

Get Read Row
    [Arguments]    ${data}    ${TestCaseNum}
    ${l}=    Get Length    ${data}
    FOR    ${i}    IN RANGE    1    ${l}
        ${rr}=    Get From List    ${data}    ${i}
        ${tcnum}=    Get From List    ${rr}    0
        Log    ${TestCaseNum.upper()} Should Equal ${tcnum.upper()}
        ${rrow}=    Set Variable    ${i}
        Exit For Loop If    '${TestCaseNum.upper()}' == '${tcnum.upper()}'
    END
    [Return]    ${rrow}

Get Resource Details Dict
    [Arguments]    ${String}
    @{labor_resouces}=    Split String    ${String}    ;
    ${Resource_dict}=    Create Dictionary
    FOR    ${i}    IN    @{labor_resouces}
        ${data}=    Get Row Data From CSV    ${ibudget resource data}    ${i}
        Log    ${data}
        ${str}=    Set Variable    ${data[1]}
        ${len}=    Get Length    ${data}
        ${str}=    Get Catenate Content    ${len}    ${str}    ${data}
        ${final_str}=    Set Variable    ${EMPTY}
        ${final_str}=    Catenate    SEPARATOR=;    ${str}    ${final_str}
        ${final_str}=    Get Substring    ${final_str}    0    -1
        Set To Dictionary    ${Resource_dict}    ${i}    ${final_str}
    END
    #${final_str}=    Get Substring    ${final_str}    0    -1
    [Return]    ${Resource_dict}

Get Catenate Content
    [Arguments]    ${len}    ${str}    ${data}
    FOR    ${i}    IN RANGE    2    ${len}
        ${str}=    Run Keyword IF    '@{data}[${i}]'!=''    Catenate    SEPARATOR=;    ${str}    @{data}[${i}]
        ...    ELSE    Set Variable    ${str}
    END
    [Return]    ${str}

Click Save and Next Button2
    Sleep    3s
    Wait Until Page Contains Element    ${SAVE & NEXT Button}    30s
    Wait Until Keyword Succeeds    30s    2s    Click Button    ${SAVE & NEXT Button}
    #Click Button    ${SAVE & NEXT Button}

Click ${save} Button
    Set Log Level    NONE
    Run Keyword If    '${save.upper()}'!='SAVE' and '${save.upper()}'!='SAVE & NEXT' and '${save.upper()}'!='SAVE AND NEXT'    Set Log Level    INFO
    Run Keyword If    '${save.upper()}'!='SAVE' and '${save.upper()}'!='SAVE & NEXT' and '${save.upper()}'!='SAVE AND NEXT'    Fatal Error    [INSERT ERROR MESSAGE]
    Set Focus To Element    ${SAVE Button}
    Sleep    3s
    Run Keyword If    '${save.upper()}'=='SAVE'    Click Button    ${SAVE Button}
    Run Keyword If    '${save.upper()}'=='SAVE & NEXT'    Wait Until Page Contains Element    ${SAVE & NEXT Button}    30s
    Run Keyword If    '${save.upper()}'=='SAVE & NEXT'    Wait Until Keyword Succeeds    30s    2s    Click Button    ${SAVE & NEXT Button}
    Run Keyword If    '${save.upper()}'=='SAVE AND NEXT'    Wait Until Page Contains Element    ${SAVE & NEXT Button}    30s
    Run Keyword If    '${save.upper()}'=='SAVE AND NEXT'    Wait Until Keyword Succeeds    30s    2s    Click Button    ${SAVE & NEXT Button}
    Set Log Level    INFO

Click ERA Tile
    Set Log Level    NONE
    Wait Until Page Contains Element    ${ERA TILE Link}    30s
    Click Link    ${ERA TILE Link}
    Set Log Level    INFO

Click My Opp and Engage Tile
    Set Log Level    NONE
    Wait Until Page Contains Element    ${MY OPP&ENGAGE TILE Link}    30s
    Sleep    2s
    Click Element    ${MY OPP&ENGAGE TILE Link}
    Wait Until Page Contains Element    ${CREATE NEW SHELL Btn}    30s
    Set Log Level    INFO

Get TC Numbers
    [Arguments]    ${datafile}
    Set Log Level    NONE
    ${list}=    Create List
    ${data}=    Read Csv As List    ${datafile}    ,
    FOR    ${i}    IN    @{data}
        ${v}=    Get From List    ${i}    0
        Append To List    ${list}    ${v}
    END
    Remove From List    ${list}    0
    [Return]    ${list}

Grant User Permissions
    [Arguments]    ${name}
    [Documentation]    Grant user permissions to a Shell or ERA. Must pass a users name as an argument.
    Wait Until Page Contains Element    ${PERM GRANT USER Input}
    Input Text    ${PERM GRANT USER Input}    ${name}${\n}
    Sleep    2s
    Click Button    //td[text()='${name}']/preceding::td//button[text()='Add']

Remove User Permissions
    [Arguments]    ${name}
    [Documentation]    Remove user permissions to a Shell or ERA. Must pass a users name as an argument.
    Wait Until Page Contains Element    //td[text()='${name}']/preceding::td//button[text()='Remove']
    #Wait Until Page Contains Element    ${PERM REMOVE USER Input}
    #Input Text    ${PERM REMOVE USER Input}    ${name}${\n}
    #Sleep    2s
    Click Button    //td[text()='${name}']/preceding::td//button[text()='Remove']

Truncate Name
    [Arguments]    ${name}    ${trun_length}
    ${substring}=    Get Substring    ${name}    0    ${trun_length}
    ${t_name}=    Catenate    SEPARATOR=    ${substring}    ..
    [Return]    ${t_name}

Import Roles
    ${list}=    Read Csv File To List    ${ROLES}
    ${roles_dict}=    Convert To Dictionary    ${list}
    Set Global Variable    ${roles_dict}

Field Should Be Disabled
    [Arguments]    ${locator}
    [Documentation]    Captures the disabled property from the element. If the element is not disabled the attribute is not available and will return 'none'
    Set Log Level    NONE
    ${disabled}=    Get Element Attribute    ${locator}    disabled
    Set Log Level    INFO
    Run Keyword And Continue On Failure    Should Be True    '${disabled}'=='true'    Element should have been disabled but isn't.

Field Should Be Enabled
    [Arguments]    ${locator}
    [Documentation]    Captures the disabled property from the element. If the element is not disabled the attribute is not available and will return 'none'
    Set Log Level    NONE
    ${disabled}=    Get Element Attribute    ${locator}    disabled
    Set Log Level    INFO
    Run Keyword And Continue On Failure    Should Not Be True    '${disabled}'=='true'    Element should be enabled but isn't.

Normalize Currency Rates
    [Arguments]    ${Base_Currency}    ${Contract_Currency}
    #${cur_rates}=    Create Dictionary
    #Set To Dictionary    ${cur_rates}    USD    1.000000
    #Set To Dictionary    ${cur_rates}    AUD    0.71398839
    #Set To Dictionary    ${cur_rates}    EUR    1.21398839
    #Set To Dictionary    ${cur_rates}    CAD    0.74784136
    ${cur_rates}=    Get Currency Rates
    ${Normalize_factor}=    Set Variable    &{cur_rates}[${Base_Currency}]
    FOR    ${key}    IN    @{cur_rates.keys()}
        ${New_factorized}=    Evaluate    &{cur_rates}[${key}]/${Normalize_factor}
        Set To Dictionary    ${cur_rates}    ${key}    ${New_factorized}
    END
    Log    ${cur_rates}
    [Return]    ${cur_rates}

Get Currency Rates
    Connect To Database Using Custom Params    pyodbc    DRIVER='{SQL Server}', SERVER='imanagesqlserver01.database.windows.net',database='${iManage_db}', user='imanageadmin', password='Password$123'
    ${q}    Query    Select Code, ExchangeRate From Currencies Where IsDeleted = 0
    Disconnect From Database
    ${d}=    Create Dictionary
    Log    ${q}
    FOR    ${i}    IN    @{q}
        Set To Dictionary    ${d}    ${i[0]}    ${i[1]}
    END
    #Log Dictionary    ${d}
    [Return]    ${d}

Get currency codes
    [Arguments]    ${Currency}
    Connect To Database Using Custom Params    pyodbc    DRIVER='{SQL Server}', SERVER='imanagesqlserver01.database.windows.net',database='${iManage_db}', user='imanageadmin', password='Password$123'
    ${q}    Query    Select Code From Currencies Where IsDeleted = 0 and Name='${Currency}'
    Disconnect From Database
    [Return]    ${q}

Check For Opp Button
    [Arguments]    ${shell_dict["existing"]}
    Run Keyword If    '${ENV.upper()}' == 'TEST' or '${ENV.upper()}' == 'DEV'    Select Opportunity Form Type    ${shell_dict["existing"]}
    #Run Keyword If    '${ENV.upper()}' == '${HasSelOppBtn.upper()}'    Select Opportunity Form Type    ${shell_dict["existing"]}

Setup Suite
    #Set Log Level    NONE
    #${auth}=    Create List    ${DOMAIN}\\${USERNAME}    ${PASSWORD}
    #${headers}=    Create Dictionary    Content-type=application/json
    #Create Session    iBudget    https://dev.ibudget-tst.protiviti.com/odata    headers=${HEADERS}    verify=True
    #Set Log Level    INFO

Get JSON File
    [Arguments]    ${datafile}
    Set Log Level    NONE
    ${JSON}=    Get File    ${EXECDIR}\\Data\\${datafile}
    Set Log Level    INFO
    [Return]    ${JSON}

Modify JSON - Obsolete
    [Arguments]    ${json_string}
    ${json}=    evaluate    json.loads('''${json_string}''')    json
    [Return]    ${json}

Return Dict from JSON
    [Arguments]    ${data}    ${key}    ${value}
    ${r}=    evaluate    ([x for x in ${data['value']} if "${value}" in x['${key}']])
    ${n}=    Get Length    ${r[0]}
    [Return]    ${r[0]}

Check Main Budget Status
    [Arguments]    ${engagementid}
    [Documentation]    Checks the Main creation status every 2 sec until a return code of 3 (main created), 2 (error), or 2 minute timeout.
    Set Log Level    NONE
    FOR    ${i}    IN RANGE    99
        ${g}=    Get Request    Shell    /engagements/${engagementid}    allow_redirects=True
        ${json}=    String to json    ${g.content}
        Exit For Loop If    ${json['budgetStatus']} == 3
        Exit For Loop If    ${json['budgetStatus']} == 2
        Exit For Loop If    ${i} == 60
        Sleep    2s
    END
    Set Log Level    INFO
    [Return]    ${json['budgetStatus']}

Request Suite Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    ${COOKIES}=    Get Cookies
    Set Global Variable    ${COOKIES}
    ${HEADERS}=    Create Headers Dict    ${COOKIES}
    Set Global Variable    ${HEADERS}
    #Go To    ${ENV_ERA_URL}
    #${ERA_COOKIES}=    Get Cookies
    #Set Global Variable    ${ERA_COOKIES}
    #${ERA_HEADERS}=    Create Headers Dict    ${ERA_COOKIES}
    #Set Global Variable    ${ERA_HEADERS}
    #..........API Request Keywords

Send JSON request to API to create Shell
    [Arguments]    ${Data_File}    ${row}
    #.............Get Payload from file & POST req to create Shell
    ${shell_data}=    Get Data From CSV File    ${Data_File}    ${row}
    Create Session    Shell    ${ENV_URL}/api    headers=${HEADERS}    verify=True
    ${shell_payload}=    Create R2 Shell JSON Dict    ${shell_data}
    Set Global Variable    ${shell_payload}
    ${e}=    Post Request    Shell    /engagements    headers=${HEADERS}    data=${shell_payload}    allow_redirects=True
    [Return]    ${e}

Add Services to Shell
    [Arguments]    ${EngagementId}
    #.........Using Draft shell payload, adding services to complete shell
    Set To Dictionary    ${shell_payload}    engagementid    ${engagementid}
    ${op_serv_payload}=    Get Opp Service JSON Dict    ${engagementid}
    ${os}=    Post Request    Shell    /opportunityServices    headers=${HEADERS}    data=${op_serv_payload}    allow_redirects=True
    log to console    ${os.content}

Retrieve from response content
    [Arguments]    ${r}    ${field}
    ${json}=    Loads    ${r.content}
    ${val}=    Get From Dictionary    ${json}    ${field}
    #...... Shell creation Keywords
    [Return]    ${val}

Create a Draft New Shell
    [Arguments]    ${Data_File}    ${File_row}
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${Data_File}    ${File_row}
    Set Global Variable    ${shell_dict}
    Click My Opp and Engage Tile
    Wait Until Element Is Visible    ${CREATE NEW SHELL Btn}
    Sleep    5s
    Click Button    ${CREATE NEW SHELL Btn}
    Check For Opp Button    ${shell_dict["existing"]}
    ${shell_dict_empty}=    Get Shell Test Data and Element Locators    ${Data_File}    TC000
    New Opportunity Setup Form    ${shell_dict}    ${shell_dict_empty}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    [Return]    ${shell_dict["Opp/EngName"]}    ${shell_dict}

Complete New Shell creation from Draft
    [Arguments]    ${Data_File}    ${File_row}    ${draft_data_dict}
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${Data_File}    ${File_row}
    Set Global Variable    ${shell_dict}
    Update Main Client/Account Details    ${shell_dict["Client Name"]}
    New Opportunity Setup Form    ${shell_dict}    ${draft_data_dict}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    Sleep    3s
    [Return]    ${shell_dict["Opp/EngName"]}

Create a New Shell
    [Arguments]    ${Data_File}    ${File_row}
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${Data_File}    ${File_row}
    Set Global Variable    ${shell_dict}
    Update Main Client/Account Details    ${shell_dict["Client Name"]}
    Click My Opp and Engage Tile
    Wait Until Page Contains Element    ${CREATE NEW SHELL Btn}
    Scroll Element Into View    ${CREATE NEW SHELL Btn}
    Click Button    ${CREATE NEW SHELL Btn}
    Check For Opp Button    ${shell_dict["existing"]}
    ${shell_dict_empty}=    Get Shell Test Data and Element Locators    ${Data_File}    TC000
    New Opportunity Setup Form    ${shell_dict}    ${shell_dict_empty}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    [Return]    ${shell_dict["Opp/EngName"]}

Link Exiting opportuinty with complete Shell
    [Arguments]    ${Data_File}    ${File_row}
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${Data_File}    ${File_row}
    Set Global Variable    ${shell_dict}
    Update Main Client/Account Details    ${shell_dict["Client Name"]}
    Sleep    3s
    Click My Opp and Engage Tile
    Wait Until Page Contains Element    ${CREATE NEW SHELL Btn}
    Click Button    ${CREATE NEW SHELL Btn}
    Check For Opp Button    ${shell_dict["existing"]}
    #Run Keyword And Continue On Failure    Element Should Not Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${DELETE DRAFT Btn}
    Run Keyword And Continue On Failure    Element Should Not Be Visible    ${HAMBURGER Btn}
    Shell Setup Form    ${shell_dict}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    Run Keyword And Continue On Failure    Element Should Be Visible    ${PERM MANAGE PERMISSIONS Btn}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${DELETE DRAFT Btn}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${HAMBURGER Btn}
    [Return]    ${shell_dict["Opp/EngName"]}

Navigate to the ${ShellName} Shell
    Wait Until Element Is Visible    xpath=//span[@title="${ShellName}"]
    Click Element    xpath=//span[@title="${ShellName}"]

From Shell Navigate to ${ASSISTANT Link} further to ${ERA NAME}
    Open iManage Assistant
    Expand Assistant Section    ${ASSISTANT Link}
    ${ERA Name_New}    Get Substring    ${ERA NAME}    0    31
    Wait Until Element Is Visible    //a[contains(text(), '${ERA Name_New}')]    30s
    Click Element    //a[contains(text(), '${ERA Name_New}')]

From Assistant Navigate to ${ASSISTANT Link} further to ${Sub-Assistant Link}
    Expand Assistant Section    ${ASSISTANT Link}
    Wait Until Element Is Visible    ${ASSISTANT Link}/following-sibling::ul${Sub-Assistant Link}
    Click Element    ${ASSISTANT Link}/following-sibling::ul${Sub-Assistant Link}
    #.........ERA Keywords

Create an ERA via Shell
    [Arguments]    ${ERA_DATA}    ${row}
    ${ERA_dict}=    Get Data From CSV File    ${ERA_DATA}    TC#    ${row}
    Set Global Variable    ${ERA_dict}
    Set ERA Approval Locators
    Sleep    5s
    Wait Until Element Is Visible    ${ERA NAME Input}    30s
    Complete ERA Setup Form    ${ERA_dict}
    Click Button    ${SAVE Button}

iManage Change Order Creation
    [Arguments]    ${Data_File}    ${Shell_row}    ${CO_row}    ${OppName}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Wait Until Page Contains Element    ${ASSIST New Change Order Link}
    Click Element    ${ASSIST New Change Order Link}
    Wait Until Page Contains Element    //span[contains(normalize-space(.), '${OppName}') and contains(@id, 'shellname')]
    Run Keyword And Continue On Failure    Element Should Be Visible    ${CO OPPORTUNITY STATUS BAR}${CO OPPORTUNITY STATUS-INCOMPLETE SHELL}
    ${main_dict}=    Get Shell Test Data and Element Locators    ${Data_File}    ${Shell_row}
    ${CO_dict}=    Get Shell Test Data and Element Locators    ${Data_File}    ${CO_row}
    New Opportunity Setup Form    ${CO_dict}    ${main_dict}
    [Return]    ${CO_dict["Opp/EngName"]}

ERA with completed Part-1 and Part-2
    [Arguments]    ${era_data}    ${DataRow}
    Create an ERA via Shell    ${era_data}    ${DataRow}
    Click Save and Next Button
    Validate Part 1 Questions    ${ERA_dict}
    Click Save and Next Button
    Validate Part 2 Questions    ${ERA_dict}
    Verify Header Section Rating    ${ERA_dict}
    Click Save and Next Button

Close Opportunity
    [Arguments]    ${Closed Stage}    ${WinLoss Reason}    ${Proposal Used}
    Click Element    //label[@for='Closed']
    Wait Until Page Contains Element    //h4[contains(normalize-space(.), 'Close Opportunity')]
    Run Keyword If    '${Closed Stage}'!= ''    Shell Opportunity Stage    ${Closed Stage}
    ...    ELSE    Run Keyword    Log    Closed Stage is required in order to close Shell!
    Run Keyword If    "${WinLoss Reason}"!="" and "${Closed Stage}"!= "Closed - Unqualified"    Shell Primary Win/Lose Reason    ${WinLoss Reason}
    ...    ELSE    Run Keyword    Log    Primary Reason is required to close Opportunity Except for Closed Stage = 'Closed Unqualified'!
    Run Keyword If    '${Proposal Used}'!= ''    Run Keywords    Click Element    //dx-select-box[@id= 'isProposalUsed']//input[@type= 'text']
    ...    AND    Click Element    //div[@class= 'dx-scrollable-wrapper']//div[ text()= '${Proposal Used}']
    ...    ELSE    Run Keyword    Log    Proposal Is required to be filled in order to close the opportunity!
    Run Keyword If    "${WinLoss Reason}" =="" and "${Closed Stage}"== "Closed - Unqualified"    Shell Is Closed Successfully    ${Closed Stage}    ${WinLoss Reason}
    ...    ELSE IF    '${WinLoss Reason}' == ''    Page Should Contain Element    //div[div[text()='Primary Win / Loss Reason is required to save the form.']]    #ELSE    Shell Is Closed Successfully    ${Closed Stage}    ${WinLoss Reason}
    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${Save & Close}
    Run Keyword And Ignore Error    Click Element    ${Save & Close}
    Run Keyword And Ignore Error    Click Element    ${Close Opp Close Button}

ERA Summary Section
    [Arguments]    ${FRARSelect}
    Complete Summary Section    ${ERA_dict}    ${FRARSelect}

Submit the ERA for Approval
    Scroll Element Into View    ${SUBMIT TO EMD Button}
    Run Keyword And Continue On Failure    Element should be Visible    ${SUBMIT TO EMD Button}
    Comment    Page Should Contain Element    //div[@class= 'w DRAFT']    10s
    Click Button    ${SUBMIT TO EMD Button}
    #Wait Until Page Contains Element    ${TOP ERROR MSG Label}    10s
    Wait Until Page Contains Element    ${ApproveByADMIN}    30s
    Run Keyword And Continue On Failure    Page Should Contain Element    xpath=//span[contains(normalize-space(.), 'Approvals')]
    Wait Until Page Contains Element    ${ApproveByADMIN}    30s

ERA is successfully linked to the Shell in Assistant
    [Arguments]    ${ASSISTANT Link}    ${ERA}
    Open iManage Assistant
    Expand Assistant Section    ${ASSISTANT Link}
    ${ERA Name_New}    Get Substring    ${ERA}    0    30
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    ${ASSIST ERA UNLINK img}
    Run Keyword And Continue On Failure    Run Keyword If    '${ERA}'=='Salesforce ERA'    Element Should Be Visible    //a[contains(text(), '${ERA}')]
    Run Keyword And Continue On Failure    Run Keyword If    '${ERA}'!='Salesforce ERA'    Element Should Be Visible    //a[contains(text(), '${ERA Name_New}')]

Validate ERA is in EMD Awaiting Approval Tab
    [Arguments]    ${ERAType}
    Click Element    ${ERA HOME Link}
    Wait Until Element Is Visible    //tr[@aria-rowindex= '1']    30s
    Click Element    ${ERA AWAITING APPROVE Btn}
    Run Keyword If    '${ERAType}'=='Normal'    Wait Until Page Contains element    //span[contains(normalize-space(.),'${ERA NAME}')]    10s
    Run Keyword If    '${ERAType}'!='Normal'    Wait Until Page Contains element    //span[@title= '${ERA NAME}']    10s

Open Assistant and check Attached Parameters
    [Arguments]    ${ShellName}
    Open Assistant From Filter-List    ${ShellName}
    Validate Assistant Parameters on Shell Filter-List    ${ShellName}

Validate ERA is in Approved ERA Tab
    [Arguments]    ${ERAType}
    Click Element    ${ERA HOME Link}
    Wait Until Element Is Visible    //tr[@aria-rowindex= '1']    30s
    Click Element    ${APPROVED ERAS Btn}
    Run Keyword If    '${ERAType}'=='Normal'    Wait Until Page Contains element    //span[contains(normalize-space(.), '${ERA NAME}')]    10s
    Run Keyword If    '${ERAType}'!='Normal'    Wait Until Page Contains element    //span[@title= '${ERA NAME}']    10s

ERA Checklist should be checked on Opportunity Shell
    Sleep    5s
    Run Keyword And Continue On Failure    Page Should Contain Element    ${Checked ERA Created}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${Checked ERA Approved}

ERA Checklist should be unchecked on Opportunity Shell
    Sleep    5s
    Run Keyword And Continue On Failure    Page Should Contain Element    ${UnChecked ERA Created}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${UnChecked ERA Approved}

Add a Primary Key Buyer
    [Arguments]    ${opname}
    ${SFDC_dict}=    Get Data From CSV File    ${SFDC_DATA}    C-1
    ${sf}=    Create Salesforce Session    sf    ${SFDC_dict["sfinstance"]}    ${SFDC_dict["sfpwd"]}    ${SFDC_dict["sfuser"]}    ${SFDC_dict["sftoken"]}    ${SFDC_dict["sfdomain"]}
    ${op_json}=    query for opp by name    sf    ${opname}
    ${oppId}=    Get Opp ID    ${op_json}
    ${opp}=    Add Primary Key Buyer    sf    ${oppId}    ${SFDC_dict["pkbId"]}
    Delete All SalesForce Sessions

Get Opp ID
    [Arguments]    ${op_json}
    Set Log Level    NONE
    #Log    ${op_json}
    ${oppId}=    Get Value From Json    ${op_json}    $..Id
    ${oppId}=    Get From List    ${oppId}    0
    Set Log Level    INFO
    [Return]    ${oppId}

Change Client/Account Name and validate Locking Rule
    [Arguments]    ${clientname}    ${childname}
    Shell Select Child Client Name    ${clientname}    ${childname}
    Sleep    2s
    Click Button    ${N SAVE Button}
    Sleep    2s
    Run Keyword And Continue on Failure    Run Keyword If    '${clientname}'=='${childname}'    Page Should Contain Element    //div[@class='error-section']//div[contains(normalize-space(.), '${ErrorMsg_ApprovedERA}')]
    Run Keyword And Continue on Failure    Run Keyword If    '${clientname}'!='${childname}'    Page Should Not Contain Element    //div[@class='error-section']//div[contains(normalize-space(.), '${ErrorMsg_ApprovedERA}')]
    Sleep    5s
    Run Keyword And Continue On Failure    Page Should Contain Element    ${UnChecked ERA Created}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${UnChecked ERA Approved}

Link sub-budget to Main from sub-Budget
    [Arguments]    ${Main-Budget Name}    ${sub-budget Name}
    Click Element    ${sub-budget Create/Link with Main Link}
    Wait Until Element Is Visible    ${iBudget-Link Existing Main Tab}    30s
    Input Text    ${iBudget-Link Search Input Field}    ${Main-Budget Name}
    Sleep    2s
    Click Element    ${iBudget-Link Search Button}
    Wait Until Element Is Visible    //td[@title= '${Main-Budget Name}']    15s
    Sleep    3s
    Click Element    //td[@title= '${Main-Budget Name}']/preceding-sibling::td//span[text()= 'Link']
    Wait Until Page Contains Element    //label[contains(normalize-space(.), '${sub-budget Name}')]    30s

Link sub-budget to Main from Main
    [Arguments]    ${sub-budget Name}
    Wait Until Page Contains Element    ${ibudget Add sub-Budget Link}
    Scroll Element Into View    ${ibudget Add sub-Budget Link}
    Click Element    ${ibudget Add sub-Budget Link}
    Wait Until Page Contains Element    ${iBudget-Link Search Input Field}    30s
    Input Text    ${iBudget-Link Search Input Field}    ${sub-budget Name}
    Sleep    2s
    Click Element    ${iBudget-Link Search Button}
    Wait Until Element Is Visible    //td[@title= '${sub-budget Name}']
    Sleep    3s
    Click Element    //td[@title= '${sub-budget Name}']/preceding-sibling::td//span

Add copied sub-budget to Shell
    [Arguments]    ${New Budget Name}    ${copy budget_Name}
    Wait Until Page Contains Element    //li[@id= 'createBudgetTabs_SVA']    30s
    Wait Until Element Is Visible    ${copy budget Name input}
    Input Text    ${copy budget Name input}    ${New Budget Name}
    Input Text    ${copy budget Description Filter input}    ${copy budget_Name}${\n}
    Sleep    5s
    Wait Until Element Is Visible    //table[@id= 'gvCloneBudgets_DXMainTable']//td[text()= '${copy budget_Name}']
    Click Element    //table[@id= 'gvCloneBudgets_DXMainTable']//td[text()= '${copy budget_Name}']/preceding-sibling::td//span[text()= 'Copy']
    [Return]    ${New Budget Name}

Link a sub-budget to Shell via Assistant
    [Arguments]    ${sub-budget Name}
    Scroll Element Into View    ${Shell Save Button}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Click Element    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET LINK img}
    Wait Until Page Contains Element    ${iBudget-Link Search Input Field}    30s
    Input Text    ${iBudget-Link Search Input Field}    ${sub-budget Name}
    Sleep    2s
    Click Element    ${iBudget-Link Search Button}
    ${Status}=    Run Keyword And Return Status    Wait Until Element Is Visible    //td[@title= '${sub-budget Name}']/preceding-sibling::td//a[contains(normalize-space(.), 'Add to Main')]
    Sleep    3s
    ${VAR}=    Run Keyword If    '${Status}'=='True'    Set Variable    Sub-Budget Attached
    ...    ELSE    Set Variable    Sub-Budget Not Found
    Run Keyword If    '${Status}'=='True'    Click Element    //td[@title= '${sub-budget Name}']/preceding-sibling::td//a[contains(normalize-space(.), 'Add to Main')]
    ...    ELSE    Click Element    //a[text()= 'Go Back']
    [Return]    ${VAR}
