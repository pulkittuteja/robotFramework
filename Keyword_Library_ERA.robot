*** Settings ***
Documentation     Keyword file for ERA specific keywords and tests.
Resource          locators.robot

*** Variables ***
${ERA Name_New}    QA TEST Normal ERA 68689496

*** Keywords ***
Open ERA From Filter List
    [Arguments]    ${era_name}    ${ERA_Type}
    Wait Until Page Contains Element    ${ERA NAME FILTER Input}    30s
    Sleep    2s
    Input Text    ${ERA NAME FILTER Input}    ${eraname}${\n}
    Run Keyword And Continue On Failure    Run Keyword If    '${ERA_Type}'=='Normal'    Click Element    //span[contains(normalize-space(.),'${ERA Name_New}')]
    Run Keyword And Continue On Failure    Run Keyword If    '${ERA_Type}'!='Normal'    Click Element    //span[@title='${eraname}']
    #Wait Until Page Contains Element    ${Link Opp Button}
    #Click Element    ${Link Opp Button}

Search ERA From Filter List by Name
    [Arguments]    ${eraname}
    Wait Until Page Contains Element    ${ERA NAME FILTER Input}    30s
    Input Text    ${ERA NAME FILTER Input}    ${eraname}${\n}

Hide / Show Ratings Ribbon
    [Arguments]    ${x}
    [Documentation]    Use Arguments 'Hide' or 'Show' with this keyword
    Log    ${x.upper()}
    Run Keyword If    '${x.upper()}' != 'HIDE' and '${x.upper()}' != 'SHOW'    Fatal Error    keyword must use arguments 'Hide' or 'Show' Is using ${x.upper()}
    ${sym}=    Set Variable If    "${x.upper()}" == "HIDE"    -    "${x.upper()}" == "SHOW"    +
    Wait Until Element Is Visible    //secnav//button[contains(normalize-space(.), '${sym}')]    30s
    Scroll Element Into View    //secnav//button[contains(normalize-space(.), '${sym}')]
    Sleep    3s
    Click Element    //secnav//button[contains(normalize-space(.), '${sym}')]

Complete ERA Setup Form
    [Arguments]    ${data_dict}
    [Documentation]    Keyword fills out the ERA setup form based on the data provided in the data provided.
    ...    Requires a valid data dictionary as an argument created from an individual row of the ERA data sheet.
    ...    To avoid duplicate ERA names the keyword appends a random number to the ERA name. NOTE: the appending
    ...    a random number may need to be modified for tests that require linking of ERA to Shells.
    Set Selenium Speed    0.5
    ${t}=    Random Number
    Set Global Variable    ${ERA NAME}    ${data_dict["ERA Name"]} ${t}
    ${ERA Name_New}    Get Substring    ${ERA NAME}    0    31
    Set Global variable    ${ERA Name_New}
    Comment    Hide / Show Ratings Ribbon    Hide
    Sleep    3s
    Run Keyword If    '${data_dict["ERA Name"]}'!=''    Input Text    ${ERA NAME Input}    ${ERA NAME}
    #Run Keyword If    '${data_dict["Salesforce Opportunity"]}'!=''    Input Text    ${SF OPPORTUNITY Input}    ${data_dict["Salesforce Opportunity"]}
    Run Keyword If    '${data_dict["isNewClient"].upper()}'=='T'    Select Checkbox    ${NEW CLIENT chkbox}
    Run Keyword If    '${data_dict["isPciEngagement"].upper()}'=='T'    Select Checkbox    ${PCI ENGAGE chkbox}
    Run Keyword If    '${data_dict["isFinancialModelEngagement"].upper()}'=='T'    Select Checkbox    ${FINANCIAL MODEL chkbox}
    Run Keyword If    '${data_dict["isDueDillgenceEngagement"].upper()}'=='T'    Select Checkbox    ${M&A DUE DIL ENGAGE chkbox}
    Run Keyword If    '${data_dict["isSocialEngineeringEngagement"].upper()}'=='T'    Select Checkbox    ${VUL PEN SOL ENG ENGAGE chkbox}
    Run Keyword If    '${data_dict["isLoanStaff"].upper()}'=='T'    Select Checkbox    ${LOAN STAFF chkbox}
    Run Keyword If    '${data_dict["isSoftwareResell"].upper()}'=='T'    Select Checkbox    ${SOFTWARE RESELL chkbox}
    Run Keyword If    '${data_dict["isCrossBorderTravel"].upper()}'=='T'    Select Checkbox    ${CROSS BORDER TRAVEL chkbox}
    Run Keyword If    '${data_dict["isGovernmentEngagement"].upper()}'=='T'    Select Checkbox    ${GOV ENGAGE chkbox}
    Run Keyword If    '${data_dict["isContractorUsed"].upper()}'=='T'    Select Checkbox    ${USE CONTRACTORS chkbox}
    Run Keyword If    '${data_dict["Client Size"]}'!=''    Select From iManage List    ${CLIENT SIZE Select}    ${data_dict["Client Size"]}
    Run Keyword If    '${data_dict["Client Legal Structure"]}'!=''    Select From iManage List    ${CLIENT LEGAL STRUCTURE Select}    ${data_dict["Client Legal Structure"]}
    Run Keyword If    '${data_dict["Engagement Description"]}'!=''    Input Text    ${ENGAGE DESCRIPT Textarea}    ${data_dict["Engagement Description"]}
    Run Keyword If    '${data_dict["Principal Country- Job Contracted"]}'!=''    Select From iManage List    ${PCOUNTRY JOB CONTRACTED Select}    ${data_dict["Principal Country- Job Contracted"]}
    Run Keyword If    '${data_dict["Principal Country - Work Performed"]}'!=''    Input Text    ${PCOUNTRY WORK PERFORMED Input}    ${data_dict["Principal Country - Work Performed"]}
    Run Keyword If    '${data_dict["isMsaRequired"]}'!=''    Select From iManage List    ${MSA REQUIRED Select}    ${data_dict["isMsaRequired"]}
    Run Keyword If    '${data_dict["Estimated Duration"]}'!=''    Select From iManage List    ${EST DURATION Select}    ${data_dict["Estimated Duration"]}
    Run Keyword If    '${data_dict["Estimation Net Fees"]}'!=''    Select From iManage List    ${EST NET FEES Select}    ${data_dict["Estimation Net Fees"]}
    Run Keyword If    '${data_dict["Estimated Contribution Margin Percentage"]}'!=''    Input Text    ${EST CONT MARGIN Input}    ${data_dict["Estimated Contribution Margin Percentage"]}
    Sleep    .5s
    Set Selenium Speed    ${DELAY}

Select Client Name
    [Arguments]    ${clientname}    ${clientcode}
    [Documentation]    Keyword selects the Client name based on data provided in the ERA data sheet. Requires the
    ...    Client Name and Client ID as arguments. Keyword clicks on the Client name input box to display the client
    ...    pick list, then filters the list by client name to avoid having to page up. Once teh list is filtered the
    ...    keyword click on the arrow icon to display the second level which contains the Client number. The keyword
    ...    then clicks the client number.
    ...    ENHANCEMENT REQUIRED: verify client name and client number are displayed on teh form after selection.
    Wait Until Keyword Succeeds    30s    2s    Click Element    ${CLIENT NAME Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    Set Focus To Element    //td[@aria-label="Column Name, Filter cell"]//input
    Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${clientname}${\n}
    Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
    Sleep    1s
    Wait Until Page Contains Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div    10s
    Click Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div
    Wait Until Page Contains Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${clientname}')])[3]    10s
    Click Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${clientname}')])[3]

Select Child Client Name
    [Arguments]    ${clientname}    ${childname}
    Wait Until Keyword Succeeds    30s    2s    Click Element    ${CLIENT NAME Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    Set Focus To Element    //td[@aria-label="Column Name, Filter cell"]//input
    Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${clientname}${\n}
    Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
    Sleep    1s
    Wait Until Page Contains Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div    10s
    Click Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div
    Wait Until Page Contains Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${childname}')])[2]    10s
    Click Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${childname}')])[2]

Select EMD Name
    [Arguments]    ${EMD NAME}
    Click Element    ${EMD Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${EMD NAME}${\n}
    Sleep    2s
    Click Element    ${EMD SELECT NAME}

Select EM Name
    [Arguments]    ${EM NAME}
    Click Element    ${EM Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${EM NAME}${\n}
    Sleep    2s
    Click Element    ${EM SELECT NAME}

Select QCMD Name
    [Arguments]    ${QCMD NAME}
    Return From Keyword If    '${QCMD NAME}'==''
    Click Element    ${eQA SEARCH img}    #${QCMD SEARCH img}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${QCMD NAME}${\n}
    Sleep    1s
    Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
    Scroll Element Into View    ${QCMD SELECT NAME}
    Click Element    ${QCMD SELECT NAME}

Select QRMMD Name
    [Arguments]    ${QRMMD NAME}
    Return From Keyword If    '${QRMMD NAME}'==''
    Click Element    ${QRMMD SEARCH img}
    Wait Until Page Contains Element    ${QRMMD SELECT NAME}    30s
    #Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${QRMMD NAME}${\n}
    Sleep    1s
    Click Element    ${QRMMD SELECT NAME}

Select From iManage List
    [Arguments]    ${locator}    ${value}
    Scroll Element Into View    ${locator}
    Click Element    ${locator}
    Wait Until Page Contains Element    (//div[text()='${value}'])[last()]    30s
    Click Element    (//div[text()='${value}'])[last()]

ERA Select Is Engagement Sensitive
    [Arguments]    ${conf}
    Return From Keyword If    '${conf.upper()}'=='NO'    #Since NO is the default value I'm leaving this field be. This is a temp fix as NO is not selectable in IE. I'll examine a more reliable fix
    Click Element    ${CONFIDENTIAL Select}
    Wait Until Page Contains Element    //div[text()='${conf}']    30s
    Click Element    //div[text()='${conf}']

Verify Summary Section
    [Arguments]    ${data_dict}
    Wait Until Page Contains Element    ${SUMMARY Header}    30s
    #---- Verify Summary Rating
    Run Keyword And Continue On Failure    Element Text Should Be    ${CERA RATING Text}    Rating: ${data_dict["CERARate"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART1 RATING Text}    Rating: ${data_dict["Part1Rate"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART2 RATING Text}    Rating: ${data_dict["Part2Rate"]}
    #---- Verify Summary Status
    Run Keyword And Continue On Failure    Element Text Should Be    ${CERA STATUS Text}    ${data_dict["CERAStatus"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART1 STATUS Text}    ${data_dict["Part1Status"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART2 STATUS Text}    ${data_dict["Part2Status"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${RMAP STATUS Text}    ${data_dict["RMAPStatus"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${eQA Lead STATUS Text}    ${data_dict["QCMDStatus"]}    #${QCMD STATUS Text}
    #----
    Run Keyword And Continue On Failure    Element Should Contain    ${CRAR VALUE text}    ${data_dict["CRAR"]}    #Element text has leading and trailing spaces. Use Element Should Contain to verify substring.
    Run Keyword And Continue On Failure    List Selection Should Be    ${FRAR Select}    ${data_dict["FRAR"]}

Summary Section FRAR when selected as ${FRARChange}
    [Documentation]    Validate final risk selected process {Normal, Increased, High}
    Set Selenium Speed    0.5
    Wait Until Page Contains Element    ${SUMMARY Header}    30s
    Log    ${FRARChange}
    ${CRAR Actual Value}=    Get Text    ${CRAR VALUE text}
    ${CRAR Actual Value}=    Set Variable    ${CRAR Actual Value.strip()}
    ${FRAR Selected Value}=    Get Selected List Value    ${FRAR Select}
    Run Keyword And Continue On Failure    Run Keyword If    '${FRAR Selected Value}'!='${FRARChange}'    Select From List By Value    ${FRAR Select}    ${FRARChange}
    Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value}'!='${FRARChange}'    Input Text    ${FRAR Textarea}    ${FRARChange}
    Run Keyword And Continue On Failure    Run Keyword If    '${FRARChange}'=='Increased' or '${FRARChange}'=='High'    Page Should Contain Element    ${Section:RMAP}/following-sibling::div${FieldRequired}
    Run Keyword And Continue On Failure    Run Keyword If    '${FRARChange}'=='Increased' or '${FRARChange}'=='High'    Page Should Contain Element    ${Section:RMAP}/following-sibling::div${FieldStatus}
    Run Keyword And Continue On Failure    Run Keyword If    '${FRARChange}'=='High'    Page Should Contain Element    ${Section: eQA Lead Plan}/following-sibling::div${FieldRequired}    #${Section: QC MD}/following-sibling::div${FieldRequired}
    Run Keyword And Continue On Failure    Run Keyword If    '${FRARChange}'=='High'    Page Should Contain Element    ${Section: eQA Lead Plan}/following-sibling::div${FieldStatus}    #${Section: QC MD}/following-sibling::div${FieldStatus}
    Click Button    ${SAVE Button}

Complete Summary Section
    [Arguments]    ${data_dict}
    Set Selenium Speed    0.5
    Wait Until Page Contains Element    ${SUMMARY Header}    30s
    #---- MOVE THE BELOW STEPS TO VERIFY SUMMARY SECTION ----
    #
    #Verify Summary Rating    ${data_dict}
    #Verify Summary Status    ${data_dict}
    #Run Keyword And Continue On Failure    Element Should Contain    ${CRAR VALUE text}    ${data_dict["CRAR"]}    #Element text has leading and trailing spaces. Use Element Should Contain to verify substring.
    #Run Keyword And Continue On Failure    List Selection Should Be    ${FRAR Select}    ${data_dict["FRAR"]}
    #
    #---- MOVE THE ABOVE STEPS TO VERIFY SUMMARY SECTION ----
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["ChangeRiskRating"].upper()}'=='Y'    Select From List    ${FRAR Select}    ${data_dict["FRAR(new)"]}
    #
    #Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T' or '${data_dict["isPciEngagement"].upper()}'=='T'    Element Text Should Be    ${SUMMARY STATUS Text}    Incomplete
    #ELSE    Element Text Should Be    ${SUMMARY STATUS Text}    ${data_dict["SummaryStatus"]}    # This validation will need some work needs to capture that summary is incomplete when the user first goes to the summary page. Work with samina to determine the conditions
    #
    ${CRAR Actual Value}=    Get Text    ${CRAR VALUE text}
    ${CRAR Actual Value}=    Set Variable    ${CRAR Actual Value.strip()}
    ${FRAR Selected Value}=    Get Selected List Value    ${FRAR Select}
    Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value}'!='${FRAR Selected Value}'    Input Text    ${FRAR Textarea}    ${data_dict["RateDiffDesc"]}
    #
    #Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value.upper()}'=='HIGH'    Element Should Be Visible    ${GLMD SECTION HEAD}
    #Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value.upper()}'=='HIGH'    Element Text Should Be    ${GLMD NAME text}    ${data_dict["GLMD"]}
    #Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value.upper()}'=='HIGH'    Element Should Be Visible    ${RMD SECTION HEAD}
    #Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value.upper()}'=='HIGH'    Element Text Should Be    ${RMD NAME text}    ${data_dict["RMD"]}
    Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value.upper()}'=='HIGH'    Element Should Be Visible    ${QRMMD SECTION HEAD}
    Run Keyword And Continue On Failure    Run Keyword If    '${CRAR Actual Value.upper()}'=='HIGH' and '${data_dict["QRMMD"]}'!=''    Select QRMMD Name    ${APPROVERS["QRMMD"]}
    Run Keyword And Continue On Failure    Run Keyword If    '${FRAR Selected Value.upper()}'=='HIGH' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T'    Element Should Be Visible    ${eQA Plan SECTION HEAD}    #${QCMD SECTION HEAD}
    log    ${APPROVERS["QCMD"]}
    log    ${data_dict["QCMD"]}
    Run Keyword And Continue On Failure    Run Keyword If    '${FRAR Selected Value.upper()}'=='HIGH' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T' and '${data_dict["QCMD"]}'!=''    Select QCMD Name    ${APPROVERS["QCMD"]}
    Click Button    ${SAVE Button}
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    //label[contains(normalize-space(.), 'Form Saved')]
    Run Keyword And Continue On Failure    Element Text Should Be    ${SUMMARY STATUS Text}    ${data_dict["SummaryStatus"]}

Verify Header Section Rating
    [Arguments]    ${data_dict}
    Set Selenium Speed    0
    Comment    Hide / Show Ratings Ribbon    Show
    Run Keyword And Continue On Failure    Element Text Should Be    ${HEADER CERA RATING Text}    Rating: ${data_dict["CERARate"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${HEADER PART1 RATING Text}    Rating: ${data_dict["Part1Rate"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${HEADER PART2 RATING Text}    Rating: ${data_dict["Part2Rate"]}

Verify Summary Rating
    [Arguments]    ${data_dict}
    Run Keyword And Continue On Failure    Element Text Should Be    ${CERA RATING Text}    Rating: ${data_dict["CERARate"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART1 RATING Text}    Rating: ${data_dict["Part1Rate"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART2 RATING Text}    Rating: ${data_dict["Part2Rate"]}

Verify Summary Status
    [Arguments]    ${data_dict}
    Run Keyword And Continue On Failure    Element Text Should Be    ${CERA STATUS Text}    ${data_dict["CERAStatus"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART1 STATUS Text}    ${data_dict["Part1Status"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${PART2 STATUS Text}    ${data_dict["Part2Status"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${RMAP STATUS Text}    ${data_dict["RMAPStatus"]}
    Run Keyword And Continue On Failure    Element Text Should Be    ${eQA Lead STATUS Text}    ${data_dict["QCMDStatus"]} #${QCMD STATUS Text}

Complete RMAP Section
    [Arguments]    ${data_dict}
    Set Selenium Speed    0
    Wait Until Page Contains Element    ${RMAP Header}    30s
    Run Keyword If    '${data_dict["RMAPsteps"]}'==''    Log    No data for this section in the datasheet
    Return From Keyword If    '${data_dict["RMAPsteps"]}'==''
    @{RMAP_list}=    Split String    ${data_dict["RMAPsteps"]}    ;
    Wait Until Page Contains Element    ${STEP Input}    30s
    ${l}=    Get Length    ${RMAP_list}
    ${xc}=    Get Element Count    ${STEP Input}
    ${diff}=    Evaluate    ${l}-${xc}
    ${c}=    Set Variable    1
    Run Keyword If    ${xc} < ${l}    Repeat Keyword    ${diff}    Click Button    ${ADD Button}
    FOR    ${i}    IN    @{RMAP_list}
        Input Text    xpath=(${STEP Input})[${c}]    ${i}
        ${c}=    Evaluate    ${c}+1
    END
    Sleep    1s

Complete QCMD Plan Section
    [Arguments]    ${data_dict}
    Set Selenium Speed    0
    Wait Until Page Contains Element    ${eQA Lead Plan Header}    30s    #${QCMD Plan Header}
    Run Keyword If    '${data_dict["QCMDsteps"]}'==''    Log    No data for this section in the datasheet
    Return From Keyword If    '${data_dict["QCMDsteps"]}'==''
    @{QCMD_list}=    Split String    ${data_dict["QCMDsteps"]}    ;
    Wait Until Page Contains Element    ${STEP Input}    30s
    ${l}=    Get Length    ${QCMD_list}
    ${xc}=    Get Element Count    ${STEP Input}
    ${diff}=    Evaluate    ${l}-${xc}
    ${c}=    Set Variable    1
    Run Keyword If    ${xc} < ${l}    Repeat Keyword    ${diff}    Click Button    ${ADD Button}
    FOR    ${i}    IN    @{QCMD_list}
        Input Text    xpath=(${STEP Input})[${c}]    ${i}
        ${c}=    Evaluate    ${c}+1
    END
    Sleep    1s

Verify Filter List - By ERA Name
    [Arguments]    ${era_name}    ${filter_list}    ${exp_status}
    Click Link    ${ERA Link}
    Log    ${filter_list.upper()}
    Run Keyword If    '${filter_list.upper()}' != 'DRAFT' and '${filter_list.upper()}' != 'AWAITING' and '${filter_list.upper()}' != 'APPROVED'    Fatal Error    \${filter_list} value needs to be Draft, Awaiting, or Approved only
    Run Keyword If    '${exp_status.upper()}' != 'DRAFT' and '${exp_status.upper()}' != 'SUBMITTED' and '${exp_status.upper()}' != 'EMD REVIEW' and '${exp_status.upper()}' != 'APPROVED'    Fatal Error    \${filter_list} value needs to be Draft, Awaiting, or Approved only
    Run Keyword If    '${filter_list.upper()}' == 'DRAFT'    Click Button    ${DRAFT ERA Btn}
    ...    ELSE IF    '${filter_list.upper()}' == 'AWAITING'    Click Button    ${ERA AWAITING APPROVE Btn}
    ...    ELSE IF    '${filter_list.upper()}' == 'APPROVED'    Click Button    ${APPROVED ERAS Btn}
    Input Text    ${ERA NAME FILTER Input}    ${era_name}
    Wait Until Page Contains Element    ${FILTER Btn}    30s
    Click Element    ${FILTER Btn}
    Sleep    2s
    Page Should Contain Element    //td[@aria-label='Column ERA Name, Value ${era_name}']
    Page Should Contain Element    //td[@aria-label='Column Status, Value ${exp_status.upper()}']

Link Approved ERA
    Navigate to ERA link Page
    Wait Until Element Is Visible    ${ApprovedERALink}
    ${ApprovedERAName}    Get Element Attribute    //tbody[@role='presentation']//a    title
    Click Element    ${ApprovedERALink}
    [Return]    ${ApprovedERAName}

Unlink ERA
    Click Element    ${ASSIST ERA UNLINK img}    #User Unlinks the Approved ERA
    Wait Until Element Is Visible    ${ASSIST ERA Unlink Confirmation OK}
    Click Element    ${ASSIST ERA Unlink Confirmation OK}

Link SFDC ERA
    [Arguments]    ${SFDC URL DEV}    ${SFDC URL QA}
    Navigate to ERA link Page
    Click Element    ${Salerforce ERA Button}
    Run Keyword If    '${ENV.upper()}' == 'TEST'    Input Text    //div[@class='saleforceView ng-star-inserted']//input    ${SFDC URL QA}
    Run Keyword If    '${ENV.upper()}' == 'DEV'    Input Text    //div[@class='saleforceView ng-star-inserted']//input    ${SFDC URL DEV}
    Click Element    ${SFDC Save Button}

Navigate to ERA link Page
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA CREATE img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA LINK img}
    Click Element    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA LINK img}
    Wait Until Element Is Visible    ${IManageERA Button}    10s
    Wait Until Element Is Visible    ${Salerforce ERA Button}    10s
    Run Keyword And Continue On Failure    Page Should Contain Element    ${Salerforce ERA Button}

Navigate To ERA Approval Link from filter-list
    Wait Until Element Is Visible    ${APPROVALS Link}    30s
    Sleep    5s
    Click Element    ${APPROVALS Link}

User Selects Different Client name on ERA
    [Arguments]    ${Client_Name}    ${Expected_Message}
    Set Selenium Speed    1s
    Select Client Name    ${Client_Name}    ${Client_Name}
    Click Button    ${SAVE Button}
    Sleep    2s
    Run Keyword And Continue on Failure    Page Should Contain Element    //label[contains(normalize-space(.), "Form Saved")]
    Set Selenium Speed    ${Delay}

User Selects Different Child Client Name on ERA
    [Arguments]    ${Client_Name}    ${Child_Name}
    Set Selenium Speed    1s
    Set Focus To Element    ${ERA NAME Input}
    Select Child Client Name    ${Client_Name}    ${Child_Name}
    #Set Focus To Element    ${EST CONT MARGIN Input}
    Click Button    ${SAVE Button}
    Sleep    2s
    Run Keyword And Continue on Failure    Page Should Contain Element    //label[contains(normalize-space(.), "Form Saved")]
    Set Selenium Speed    ${Delay}

Export eQA Lead Plan
    Wait until Page Contains Element    ${EXPORT eQA Lead Plan Button}
    Click Element    ${EXPORT eQA Lead Plan Button}
