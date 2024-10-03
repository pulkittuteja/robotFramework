*** Settings ***
Documentation     A resource file for page element locators.

*** Variables ***
${Inde}           0
${title}          ${EMPTY}
${retries}        3
#${Total Services}    1

*** Keywords ***
Get Shell Test Data and Element Locators
    [Arguments]    ${datasheet}    ${tcnum}
    [Documentation]    This keyword creates a test data dictionary and sets up dynamic element locators.
    ...    The keyword accepts 2 arguments: datasheet location and test cases number
    ...    which it uses to select the correct data row to read from
    Set Log Level    NONE
    ${shell_dict}=    Get Data From CSV File    ${datasheet}    TC#    ${tcnum}
    ${t}=    Get TimeStamp
    Set Test Variable    ${t}
    Run Keyword If    '${shell_dict["Opp/EngName"]}'!=''    Set To Dictionary    ${shell_dict}    Opp/EngName    ${shell_dict["Opp/EngName"]} ${t}
    Set Shell Name Locators    ${shell_dict}
    Set Log Level    INFO
    [Return]    ${shell_dict}

Open Shell From Filter List
    [Arguments]    ${shell_name}
    Wait Until Page Contains Element    ${SHELL OPP/ENG FILTER input}    30s
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    ${SHELL OPP/ENG FILTER input}    ${shell_name}${\n}
        Press Key    ${SHELL OPP/ENG FILTER input}    \\13
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    //a[span[@title='${shell_name}']]    30s
        Exit for loop if    ${status} == True
    END
    Sleep    10s
    Click Element    //a[span[@title='${shell_name}']]
    Wait Until Page Contains Element    //span[@id='shellname']

Navigate to iManage Shell Page
    Click Element    ${IMANAGE HOME Link}
    Sleep    5s
    Click My Opp and Engage Tile

Search Shell From Filter List by Name
    [Arguments]    ${shell_name}
    Wait Until Page Contains Element    ${SHELL OPP/ENG FILTER input}    30s
    Input Text    ${SHELL OPP/ENG FILTER input}    ${shell_name}${\n}

Shell Setup Form
    [Arguments]    ${data_dict}
    Run Keyword If    '${data_dict["Client Name"]}'!=''    Shell Select Client Name    ${data_dict["Client Name"]}    ${data_dict["ClientID"]}
    Run Keyword If    '${data_dict["Opp/EngName"]}'!=''    Input Text    ${OPPORT/ENGAGE NAME Input}    ${data_dict["Opp/EngName"]}
    Run Keyword If    '${data_dict["Confidential"]}'!=''    Shell Select Is Engagement Sensitive    ${data_dict["Confidential"]}
    Run Keyword If    '${data_dict["Desc"]}'!=''    Input Text    ${DESCRIPTION Textarea}    ${data_dict["Desc"]}
    Run Keyword If    '${data_dict["BU"]}'!=''    Shell Select BU/Department    ${data_dict["BU"]}    ${data_dict["Dept"]}
    Run Keyword If    ${data_dict["ServiceOffLines"]} > 0    Set Service Offering Data    ${data_dict["ServiceOffLines"]}    ${data_dict["existing"]}    ${Inde}    ${data_dict["SerOffAmt"]}
    Run Keyword If    '${data_dict["EMD"]}'!=''    Shell Select EMD    ${data_dict["EMD"]}
    Run Keyword If    '${data_dict["EM"]}'!=''    Shell Select EM    ${data_dict["EM"]}
    Run Keyword If    '${data_dict["NatureofWork"]}'!=''    Shell Select Nature of Work    ${data_dict["NatureofWork"]}
    Run Keyword If    '${data_dict["Ecosystem"]}'!=''    Shell Select Ecosystem    ${data_dict["Ecosystem"]}
    Run Keyword If    '${data_dict["ManagedServices"]}'!=''    Shell Select Managed Services    ${data_dict["ManagedServices"]}
    Run Keyword If    '${data_dict["Digital"]}'!=''    Shell Select Digital    ${data_dict["Digital"]}
    Run Keyword If    '${data_dict["Salesforce Opportunity"]}'!=''    Input Text    ${OPP SF OPPORTUNITY Input}    ${data_dict["Salesforce Opportunity"]}
    Scroll Element Into View    ${Shell Save Button}
    Click Button    ${Shell Save Button}
    Add Attribute to the Assistant Attribute Dict    ${data_dict["Opp/EngName"]}    Main Budget    ${data_dict["Opp/EngName"]}

New Opportunity Setup Form
    [Arguments]    ${data_dict}    ${existing_data_dict}
    # temporary using to complete shell until data/csv is updated (Lead Source, Opportunity Stage, Proability, Opportunity Close Date)
    Run Keyword If    '${data_dict["Opportunity Stage"]}'!=''    Click Element    //label[contains(normalize-space(.), '${data_dict["Opportunity Stage"]}')]
    Wait until Page Contains Element    //div[@class='dx-dropdowneditor-icon']
    Click Element    //div[@class='dx-dropdowneditor-icon']
    Click Element    //span[contains(normalize-space(.), '29')]
    Click Element    //input[@id='leadSourceSelect']
    Input Text    //input[@id="leadSourceSelect"]    Board Member
    Press Keys    //input[@id="leadSourceSelect"]    RETURN
    Run Keyword If    '${data_dict["Client Name"]}'!='' and '${existing_data_dict["Client Name"]}'==''    Shell Select Client Name    ${data_dict["Client Name"]}    ${data_dict["ClientID"]}
    Run Keyword If    ('${data_dict["PrimaryKeyBuyerContactName"]}'!='' or '${data_dict["PrimaryKeyBuyerTitle"]}'!='') and '${data_dict["PKBrequired"].upper()}'=='YES'    Shell add primary Key buyer    ${data_dict["PrimaryKeyBuyerContactName"]}    ${data_dict["PrimaryKeyBuyerTitle"]}
    Run Keyword If    '${data_dict["Opp/EngName"]}'!=''    Input Text    ${OPPORT/ENGAGE NAME Input}    ${data_dict["Opp/EngName"]}
    Run Keyword If    '${data_dict["Confidential"]}'!='' and '${existing_data_dict["Confidential"]}'==''    Shell Select Is Engagement Sensitive    ${data_dict["Confidential"]}
    Run Keyword If    '${data_dict["Desc"]}'!=''    Input Text    ${DESCRIPTION Textarea}    ${data_dict["Desc"]}
    Run Keyword If    ('${data_dict["BU"]}'!='' and '${existing_data_dict["BU"]}'=='') or '${data_dict["Dept"]}'!='${existing_data_dict["Dept"]}'    Shell Select BU/Department    ${data_dict["BU"]}    ${data_dict["Dept"]}
    Run Keyword If    ('${data_dict["OppCur"]}'!='' and '${existing_data_dict["OppCur"]}'=='') or '${data_dict["OppCur"]}'!='${existing_data_dict["OppCur"]}'    Shell Select Opportuniy Currency    ${data_dict["OppCur"]}
    Run Keyword If    ('${data_dict["OppMD"]}'!='' and '${existing_data_dict["OppMD"]}'=='') or '${data_dict["OppMD"]}'!='${existing_data_dict["OppMD"]}'    Shell Select Opp MD    ${data_dict["OppMD"]}
    Run Keyword If    ('${data_dict["OppOwner"]}'!='' and '${existing_data_dict["OppOwner"]}'=='') or '${data_dict["OppOwner"]}'!='${existing_data_dict["OppOwner"]}'    Shell Select Opp Owner    ${data_dict["OppOwner"]}
    Run Keyword If    (('${data_dict["EMD"]}'!='' and '${data_dict["EMD"]}'!='${data_dict["OppMD"]}') and '${existing_data_dict["EMD"]}'=='') or '${data_dict["EMD"]}'!='${existing_data_dict["EMD"]}'    Shell Select EMD    ${data_dict["EMD"]}
    Run Keyword If    (('${data_dict["EM"]}'!='' and '${data_dict["EM"]}'!='${data_dict["OppOwner"]}') and '${existing_data_dict["EM"]}'=='') or '${data_dict["EM"]}'!='${existing_data_dict["EM"]}'    Shell Select EM    ${data_dict["EM"]}
    Run Keyword If    '${data_dict["OpportunityType"]}'=='ChangeOrder' or (${data_dict["ServiceOffLines"]} > 0 and '${existing_data_dict["ServiceOffLines"]}'=='0')    Set Service Offering Data    ${data_dict["ServiceOffLines"]}    ${data_dict["existing"]}    ${Inde}    ${data_dict["SerOffAmt"]}    ## Needs service amount..
    Run Keyword If    '${data_dict["NatureofWork"]}'!='' and '${existing_data_dict["NatureofWork"]}'==''    Shell Select Nature of Work    ${data_dict["NatureofWork"]}
    Run Keyword If    '${data_dict["Ecosystem"]}'!='' and '${existing_data_dict["Ecosystem"]}'==''    Shell Select Ecosystem    ${data_dict["Ecosystem"]}
    Run Keyword If    '${data_dict["ManagedServices"]}'!='' and '${existing_data_dict["ManagedServices"]}'==''    Shell Select Managed Services    ${data_dict["ManagedServices"]}
    Run Keyword If    '${data_dict["Digital"]}'!='' and '${existing_data_dict["Digital"]}'==''    Shell Select Digital    ${data_dict["Digital"]}
    Click Button    ${Shell Save Button}
    Run Keyword If    '${data_dict["AddPur"]}'!='' and '${data_dict["AddPurRH"]}'!=''    Shell Add Pursuit Team Members    ${data_dict}
    ##

Add Members From Manage Permission
    [Arguments]    ${Members}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}
    #Set Focus To Element    ${PERM MANAGE PERMISSIONS Btn}
    Click Button    ${PERM MANAGE PERMISSIONS Btn}
    Wait Until Page Contains Element    //h4[text()='Manage Permissions']    10s
    Shell Selects Users To Share Shell    ${Members}
    Scroll Element Into View    //modal-container//button[@class='close']
    Click Element    //modal-container//button[@class='close']

Shell Selects Users To Share Shell
    [Arguments]    ${userNames}
    Set Selenium Speed    1s
    @{userNames}=    Split String    ${userNames}    ;
    Sleep    2s
    FOR    ${i}    IN    @{userNames}
        Input Text    ${APT NAME FILTER input}    ${i}
        Sleep    1s
        Input Text    //td[@aria-label="Column Job Function, Filter cell"]//input    ${\n}
        Wait Until Page Contains Element    //td[text()='${i}']/preceding-sibling::td//img    15s
        Click Element    //td[text()='${i}']/preceding-sibling::td//img
        Sleep    2s
        Run Keyword And Continue On Failure    Page Should Contain Element    //table//td[text()= '${i}']
    END
    Set Selenium Speed    ${DELAY}
    Sleep    2s

Delete Members From Manage Permission
    [Arguments]    ${Members}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}
    Set Focus To Element    ${PERM MANAGE PERMISSIONS Btn}
    Click Button    ${PERM MANAGE PERMISSIONS Btn}
    Wait Until Page Contains Element    //h4[text()='Manage Permissions']    10s
    Delete Members    ${Members}
    Scroll Element Into View    //modal-container//button[@class='close']
    Click Element    //modal-container//button[@class='close']

Delete Members
    [Arguments]    ${userNames}
    Set Selenium Speed    1s
    @{userNames}=    Split String    ${userNames}    ;
    Sleep    2s
    FOR    ${i}    IN    @{userNames}
        Sleep    1s
        Wait Until Page Contains Element    //table//td[text()= '${i}']    15s
        Click Element    //td[text()='${i}']/preceding-sibling::td//img
        Sleep    2s
        Run Keyword And Continue On Failure    Page Should Not Contain Element    //table//td[text()= '${i}']
    END
    Set Selenium Speed    ${DELAY}
    Sleep    2s

Shell Add Pursuit Team Members
    [Arguments]    ${data_dict}
    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}
    Wait Until Page Contains Element    ${MANAGE PURSUIT button}    10s
    Scroll Element Into View    ${ADD SERVICE OFFERING btn}
    Click Button    ${MANAGE PURSUIT button}
    Wait Until Page Contains Element    //h4[text()='Manage Pursuit Team']    10s
    Run Keyword And Continue On Failure    Page Should Contain Element    //td[text()='${data_dict["OppMD"]}']
    Run Keyword And Continue On Failure    Page Should Contain Element    //td[text()='${data_dict["OppOwner"]}']
    #Run Keyword And Continue On Failure    Page Should Contain Element    //td[text()='${data_dict["EMD"]}']/following-sibling::td//img
    #Run Keyword And Continue On Failure    Page Should Contain Element    //td[text()='${data_dict["EM"]}']/following-sibling::td//img
    Run Keyword If    '${data_dict["AddPur"]}'!=''    Shell Add Pursuit Team Members Select Employees    ${data_dict["AddPur"]}
    Click Element    //img[@src= '/assets/edit_icon.png']
    Sleep    3s
    Run Keyword If    '${data_dict["AddPurRH"]}'!=''    Input Text    ${OTHER PURSUIT INPUT textarea}    ${data_dict["AddPurRH"]}
    Scroll Element Into View    //modal-container//button[@class='close']
    Sleep    5s
    Run Keyword And Ignore Error    Click Button    //modal-container//button[@class='close']
    Run Keyword And Ignore Error    Click Button    //modal-container//button[@class='close']
    Sleep    3s
    Wait Until Page Contains Element    ${ADDITIONAL PURSUIT textarea}    10s
    ${v}=    Get Value    ${ADDITIONAL PURSUIT textarea}
    Validate Additional Pursuit Team    ${v}    ${data_dict["AddPur"]}    ${data_dict["AddPurRH"]}
    Sleep    1s

Validate Additional Pursuit Team
    [Arguments]    ${pursuit_str}    ${pursuit_emp}    ${pursuit_rh}
    Log    ${pursuit_rh}
    Run Keyword And Continue On Failure    Should Contain    ${pursuit_str}    ${pursuit_rh}
    Log    ${pursuit_emp}
    Return From Keyword If    '${pursuit_emp}'==''
    @{pursuit_emp}=    Split String    ${pursuit_emp}    ;
    FOR    ${i}    IN    @{pursuit_emp}
        Run Keyword And Continue On Failure    Should Contain    ${pursuit_str}    ${i}
    END

Shell Add Pursuit Team Members Select Employees
    [Arguments]    ${add_pur_emp}
    Set Selenium Speed    1s
    Run Keyword If    '${add_pur_emp}'==''    Log    No data for this section in the datasheet
    Return From Keyword If    '${add_pur_emp}'==''
    @{add_pur_emp}=    Split String    ${add_pur_emp}    ;
    FOR    ${i}    IN    @{add_pur_emp}
        Input Text    ${APT NAME FILTER input}    ${i}
        Sleep    1s
        Input Text    //td[@aria-label="Column Job Function, Filter cell"]//input    ${\n}
        Wait Until Page Contains Element    //td[text()='${i}']/preceding-sibling::td//img    15s
        Click Element    //td[text()='${i}']/preceding-sibling::td//img
    END
    Set Selenium Speed    ${DELAY}
    Sleep    1s

Shell Select Client Name
    [Arguments]    ${clientname}    ${clientID}
    Click Element    ${ACCOUNT/CLIENT Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${clientname}${\n}
        Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div    10s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div
    Sleep    1s
    Wait Until Page Contains Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${clientname}')])[3]    10s
    Click Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${clientname}')])[3]

Shell Select Child Client Name
    [Arguments]    ${clientname}    ${childname}
    Click Element    ${ACCOUNT/CLIENT Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${clientname}${\n}
        Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div    10s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[contains(normalize-space(.), '${clientname}')]/preceding-sibling::td/div
    Sleep    1s
    Wait Until Page Contains Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${childname}')])[2]    10s
    Scroll Element Into View    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${childname}')])[2]
    Click Element    xpath=(//td[@role="gridcell" and contains(normalize-space(.), '${childname}')])[2]

Shell add primary Key buyer
    [Arguments]    ${ContactName}    ${Title}
    Click Element    ${Primary Key Buyer Input}
    Run Keyword If    '${ContactName}'!=''    Select PKB with Contact Name    ${ContactName}
    ...    ELSE    Select PKB with title    ${Title}

Select PKB with Contact Name
    [Arguments]    ${ContactName}
    Wait Until Page Contains Element    //td[@aria-label="Column Contact Name, Filter cell"]//input    10s
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Contact Name, Filter cell"]//input    ${ContactName}${\n}
        Press Key    //td[@aria-label="Column Contact Name, Filter cell"]//input    \\13
        Sleep    3s
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    (//td[contains(normalize-space(.), '${ContactName}')])[2]
        Exit for loop if    ${status} == True
    END
    Click Element    (//td[contains(normalize-space(.), '${ContactName}')])[2]
    Sleep    3s

Select PKB with title
    [Arguments]    ${Title}
    Wait Until Page Contains Element    //td[@aria-label="Column Title, Filter cell"]//input    10s
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Title, Filter cell"]//input    ${Title}${\n}
        Sleep    3s
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    (//td[contains(normalize-space(.), '${Title}')])[2]
        Exit for loop if    ${status} == True
    END
    Click Element    (//td[contains(normalize-space(.), '${Title}')])[2]
    Sleep    3s

Get Random Service Offering Data
    [Arguments]    ${data}
    ${d}=    Create Dictionary
    ${l}=    Get Length    ${data}
    ${readrow}=    Evaluate    random.randint(1, ${l}-1)    random,sys
    ${col}=    Get From List    ${data}    0
    ${row}=    Get From List    ${data}    ${readrow}
    ${l}=    Get Length    ${col}
    FOR    ${i}    IN RANGE    0    ${l}
        ${k}=    Get From List    ${col}    ${i}
        ${v}=    Get From List    ${row}    ${i}
        Set To Dictionary    ${d}    ${k}    ${v.strip()}
    END
    [Return]    ${d}

Set Service Offering Data
    [Arguments]    ${num_of_lines}    ${existing}    ${startingIndex}    ${ServiceAmount}
    ${data}=    Read Csv As List    ${SERVOFF_DATA}
    FOR    ${i}    IN RANGE    ${startingIndex}    ${num_of_lines}
        Log    ${i}
        Log    ${num_of_lines}
        ${xpath_index}=    Evaluate    ${i}+1
        ${ServiceOffering_dict}=    Get Random Service Offering Data    ${data}
        Shell Select Solution/Segment/Service Offering    ${ServiceOffering_dict["Solution"]}    ${ServiceOffering_dict["SolutionSegment"]}    ${ServiceOffering_dict["ServiceOffering"]}    ${xpath_index}
        Run Keyword If    '${existing.upper()}'!='YES'    Set Opportunty Service Amount    ${xpath_index}    ${ServiceAmount}
        Exit For Loop If    ${xpath_index}==${num_of_lines}
        Click Button    ${ADD SERVICE OFFERING btn}
    END

Shell Select Solution/Segment/Service Offering
    [Arguments]    ${solution}    ${solutionsegment}    ${serviceoffering}    ${index}
    Click Element    (${SERVICE OFFERING Select})[${index}]
    Wait Until Element Is Visible    //td[@aria-label="Column Service Offering, Filter cell"]//input    30s
    Get Horizontal Position    //td[@aria-label="Column Service Offering, Filter cell"]//input
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Service Offering, Filter cell"]//input    ${serviceoffering}
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    //td[text()='${serviceoffering}']    30s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[text()='${serviceoffering}']

Set Opportunty Service Amount
    [Arguments]    ${index}    ${Amount}
    Sleep    2s
    Input Text    (${SERVICE AMOUNT OPP CUR input})[${index}]    ${Amount}

Shell Select BU/Department
    [Arguments]    ${bu}    ${dept}
    Click Element    ${BU/DEPT Select}
    Sleep    1s
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //dx-data-grid[@id='businessUnitGrid']//td[@aria-label="Column Department ID, Filter cell"]//input    ${dept}
        Sleep    2s
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    //td[contains(normalize-space(.), 'Business Unit: ${bu}')]/preceding-sibling::td/div    30s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[contains(normalize-space(.), 'Business Unit: ${bu}')]/preceding-sibling::td/div
    Sleep    2s
    Wait Until Page Contains Element    //td[text()='${dept}']    30s
    Scroll Element Into View    //td[text()='${dept}']
    Click Element    //td[text()='${dept}']

Shell Select Opportuniy Currency
    [Arguments]    ${oppcur}
    Click Element    ${OPP CURRENCY Select}
    Sleep    2s
    Wait Until Page Contains Element    (//*[@id='opportunityCurrencyGrid']//input)[1]    10s
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    (//*[@id='opportunityCurrencyGrid']//input)[1]    ${oppcur}${\n}
        ${status}=    Run Keyword And Return Status    Wait Until Page Contains Element    //*[@id='opportunityCurrencyGrid']//td[text()='${oppcur}']    10s
        Exit for loop if    ${status} == True
    END
    Click Element    //*[@id='opportunityCurrencyGrid']//td[text()='${oppcur}']

Shell Select Opp MD
    [Arguments]    ${oppmd}
    Scroll Element Into View    ${OPP MD Input}
    Click Element    ${OPP MD Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${oppmd}${\n}
        Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
        Sleep    2s
        ${status}=    Run Keyword And Return Status    Wait until Element Is Visible    //td[text()='${oppmd}']    10s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[text()='${oppmd}']

Shell Select Opp Owner
    [Arguments]    ${oppowner}
    Click Element    ${OPP OWNER Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${oppowner}${\n}
        Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
        Sleep    4s
        ${status}=    Run Keyword And Return Status    Wait until Element Is Visible    //td[text()='${oppowner}']    10s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[text()='${oppowner}']

Shell Select EMD
    [Arguments]    ${emd}
    Click Element    ${LEAD EMD Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${emd}${\n}
        Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
        Sleep    5s
        ${status}=    Run Keyword And Return Status    Wait until Element Is Visible    //td[text()='${emd}']    10s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[text()='${emd}']

Shell Select EM
    [Arguments]    ${em}
    Click Element    ${LEAD EM Input}
    Wait Until Page Contains Element    //td[@aria-label="Column Name, Filter cell"]//input
    FOR    ${i}    IN RANGE    0    ${retries}
        Input Text    //td[@aria-label="Column Name, Filter cell"]//input    ${em}${\n}
        Press Key    //td[@aria-label="Column Name, Filter cell"]//input    \\13
        Sleep    5s
        ${status}=    Run Keyword And Return Status    Wait until Element Is Visible    //td[text()='${em}']    10s
        Exit for loop if    ${status} == True
    END
    Click Element    //td[text()='${em}']

Shell Select Nature of Work
    [Arguments]    ${now}
    Click Element    ${IA NATURE Input}
    Wait Until Page Contains Element    //div[text()='${now}']    30s
    Click Element    //div[text()='${now}']

Shell Select Transaction Services
    [Arguments]    ${ts}
    Click Element    ${TRANS SERVICES Input}
    Wait Until Page Contains Element    //div[text()='${ts}']    30s
    Click Element    //div[text()='${ts}']

Shell Select Ecosystem
    [Arguments]    ${ECO-Val}
    Click Element    ${ECOSYSTEM Input}
    Wait Until Element Is Visible    //td[@aria-label="Column Ecosystem, Filter cell"]//input
    Scroll Element Into View    //td[@aria-label="Column Ecosystem, Filter cell"]//input
    Input Text    //td[@aria-label="Column Ecosystem, Filter cell"]//input    ${ECO-Val}
    Wait Until Page Contains Element    //td[text()= '${ECO-Val}']
    Click Element    //td[text()= '${ECO-Val}']

Shell Select Digital
    [Arguments]    ${dig}
    Set Focus To Element    ${DIGITAL Input}
    Click Element    ${DIGITAL Input}
    Wait Until Page Contains Element    (//div[text()='${dig}'])[last()]    30s
    Click Element    (//div[text()='${dig}'])[last()]

Shell Select Managed Services
    [Arguments]    ${ms}
    ${IsElementVisible}=    Run Keyword And Return Status    Element Should Be Visible    ${MANAGED SERVICES Input}
    Run Keyword If    ${IsElementVisible}    Click Element    ${MANAGED SERVICES Input}
    ...    ELSE    Click Element    ${MANAGED Solutions Input}
    Wait Until Page Contains Element    (//div[text()='${ms}'])[last()]    30s
    Click Element    (//div[text()='${ms}'])[last()]

Shell Select Is Engagement Sensitive
    [Arguments]    ${conf}
    Return From Keyword If    '${conf.upper()}'=='NO'    #Since NO is the default value I'm leaving this field be. This is a temp fix as NO is not selectable in IE. I'll examine a more reliable fix
    Click Element    ${CONFIDENTIAL Select}
    Wait Until Page Contains Element    //div[text()= '${conf}']    30s
    Click Element    //div[text()= '${conf}']

Shell Opportunity Stage
    [Arguments]    ${oppstg}
    Set Focus To Element    ${OPP STAGE Input}
    Click Element    ${OPP STAGE Input}
    Wait Until Page Contains Element    (//div[text()='${oppstg}'])[last()]    30s
    Click Element    (//div[text()='${oppstg}'])[last()]

Shell Opportunity Close Date
    [Arguments]    ${oppclosedate}
    ## May Not Need
    Click Element    ${data_dict["OppCloseDate"]}
    Wait Until Page Contains Element    (//div[text()='${oppclosedate}'])[last()]    30s
    Click Element    (//div[text()='${dig}'])[last()]

Shell Primary Win/Lose Reason
    [Arguments]    ${prirea}
    Set Focus To Element    ${PRIMARY REASON Input}
    Click Element    ${PRIMARY REASON Input}
    Wait Until Page Contains Element    (//div[text()='${prirea}'])[last()]    30s
    Click Element    (//div[text()='${prirea}'])[last()]

Shell Is Closed Successfully
    [Arguments]    ${Stage}    ${PrimaryReason}
    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${OPPORTUNITY STATUS BAR}//span[contains(normalize-space(.), '${Stage}')]
    Run Keyword And Ignore Error    Wait Until Page Contains Element    ${CO OPPORTUNITY STATUS BAR}//span[contains(normalize-space(.), '${Stage}')]
    Click Element    ${OPPORTUNITY STATUS MAX/MIN BUTTON}
    Run Keyword And Continue On Failure    Page Should Contain Element    (${OPPORUNITY DETAIL CLOSED STAGE}//div[contains(normalize-space(.), '${Stage}')])[last()]
    Run Keyword And Continue On Failure    Page Should Contain Element    (${OPPORUNITY DETAIL CLOSED STAGE}//div[contains(normalize-space(.), '${PrimaryReason}')])[last()]

Validate ERA Fields Populated With Shell Data
    [Arguments]    ${data_dict}
    [Documentation]    Validate the required data from the shell form is populated on the ERA form.
    #Set Log Level    NONE
    Sleep    3s
    Wait Until Element Is Visible    ${ERA NAME Input}    30s
    ${act_eraname}=    Get Element Attribute    ${ERA NAME Input}    ng-reflect-model
    #Run Keyword And Continue On Failure    Should Be True    '${act_eraname}'=='${data_dict["Opp/EngName"]} ${t}'    Need to fix this validation. element only captures the first 30 chararters but displays the entire name giving a false error.
    ${act_clientname}=    Get Element Attribute    ${CLIENT NAME Input}    ng-reflect-model
    Run Keyword And Continue On Failure    Should Be True    '${act_clientname}'=='${Shell_Client}'
    ${act_clientcode}=    Get Element Attribute    ${CLIENT CODE Input}    ng-reflect-model
    #Run Keyword And Continue On Failure    Should Be True    '${act_clientcode}'=='${data_dict["ClientID"]}'
    ${act_emd}=    Get Element Attribute    ${EMD Input}    ng-reflect-model
    Run Keyword And Continue On Failure    Should Be True    '${act_emd}'=='${data_dict["EMD"]}'
    ${act_em}=    Get Element Attribute    ${EM Input}    ng-reflect-model
    Run Keyword And Continue On Failure    Should Be True    '${act_em}'=='${data_dict["EM"]}'
    ${isConf}=    Set Variable If    '${data_dict["Confidential"].upper()}'=='YES'    true    '${data_dict["Confidential"].upper()}'=='NO'    false
    ${act_ites}=    Get Element Attribute    ${ERA CONFIDENTIAL Select}    value
    Run Keyword And Continue On Failure    Should Be True    '${act_ites}'=='${isConf}'
    Set Log Level    INFO

Select Opportunity Form Type
    [Arguments]    ${opp type}
    [Documentation]    Temporary keyword to select the type of opportunity for to test. Pass in the value from the existing column of the data sheet.
    Wait Until Element Is Visible    ${OPP CREATE NEW btn}    30s
    Run Keyword If    '${opp type.upper()}' == 'YES'    Open Link Opportunity Form
    ...    ELSE IF    '${opp type.upper()}' == 'NO'    Click Button    ${OPP CREATE NEW btn}

Open Link Opportunity Form
    Click Button    ${OPP LINK EXISTING btn}
    Wait Until ELement Is Visible    ${OPP LINK EXISTING CONFIRM HEADER}
    Click Element    ${OPP LINK EXISTING CONFIRM text}

Create Draft Shell With All Data
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${shell_data}    TC102
    Click My Opp and Engage Tile
    Click Button    ${CREATE NEW SHELL Btn}
    # Checks if server environment has Opportunity button
    Check For Opp Button    ${shell_dict["existing"]}
    New Opportunity Setup Form    ${shell_dict}
    Wait Until Page Contains Element    ${PERM MANAGE PERMISSIONS Btn}    15s
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Wait Until Page Contains Element    ${ASSIST ERA CREATE img}
    Click Element    ${ASSIST ERA CREATE img}

Add Services to the Created Shell
    [Arguments]    ${NumberOfServices}
    Click Button    ${ADD SERVICE OFFERING btn}
    ${Total Services}=    Evaluate    ${shell_dict["ServiceOffLines"]}+${NumberOfServices}
    Set Global Variable    ${Total Services}
    #${StartingIndex}=    Evaluate    ${Total Services}-2
    Set Service Offering Data    ${Total Services}    ${shell_dict["existing"]}    ${shell_dict["ServiceOffLines"]}    10000
    Click Button    ${N SAVE Button}

Add Revenue Schedule To All Services
    [Arguments]    ${Month Span}
    FOR    ${i}    IN RANGE    0    ${Total Services}
        ${Rev-Index}=    Evaluate    ${i}+1
        Scroll Element Into View    (${Revenue Schedule Link})[${Rev-Index}]
        Click Element    (${Revenue Schedule Link})[${Rev-Index}]
        Calculate Revenue Schedule    ${Month Span}
        Run Keyword And Continue On Failure    Page Should Contain Element    ${Revenue Schedule Clear Schedule}
        Scroll Element Into View    //button[@class= 'close']
        Click Element    //button[@class= 'close']
    END

Calculate Revenue Schedule
    [Arguments]    ${Months}
    Click Element    ${Revenue Schedule Start Date Link}
    Sleep    2s
    Wait Until Element Is Visible    //div[@class= 'dx-calendar-views-wrapper']//span[text()= '28']
    Click Element    //div[@class= 'dx-calendar-views-wrapper']//span[text()= '28']
    Input Text    ${Revenue Schedule Number of months input}    ${Months}
    Wait until page Contains Element    ${Revenue Schedule Calculate button}
    Click Element    ${Revenue Schedule Calculate button}

Validate Revenue Schedule is added successfully
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    //div[@ng-reflect-name='primaryServices']
    FOR    ${i}    IN RANGE    0    ${Total Services}
        ${Tick-Index}=    Evaluate    ${i}+1
        Run Keyword And Continue On Failure    Page Should Contain Element    //div[@ng-reflect-name='primaryServices']/div[${Tick-Index}]//fa[@name='check']
    END

Check for the conversion Service Amount Fields
    [Arguments]    ${cur_rates}    ${Service-Amount}    ${No-of-Services}
    FOR    ${i}    IN RANGE    0    ${No-of-Services}
        ${R-Index}=    Evaluate    ${i}+1
        ${srv_opp_cur}=    Get Value    (${SERVICE AMOUNT OPP CUR input})[${R-Index}]
        ${srv_bu_cur}=    Get Value    (${SERVICE AMOUNT BASE CUR input})[${R-Index}]
        ${srv_opp_cur_val}=    Fetch From Left    ${srv_opp_cur}    ${SPACE}
        ${srv_bu_cur_val}=    Fetch From Left    ${srv_bu_cur}    ${SPACE}
        ${srv_opp_cur_code}=    Fetch From Right    ${srv_opp_cur}    ${SPACE}
        ${srv_bu_cur_code}=    Fetch From Right    ${srv_bu_cur}    ${SPACE}
        ${convert_rate}=    Evaluate    ${Service-Amount}*${cur_rates["${shell_dict["OppCur"]}"]}
        ${convert_rate}=    Convert to Integer    ${convert_rate}
        Run Keyword and Continue On Failure    Should Be True    ${srv_opp_cur_val}==${Service-Amount}
        Run Keyword and Continue On Failure    Should Be True    ${srv_bu_cur_val}==${convert_rate}
        Run Keyword and Continue On Failure    Should Be True    '${srv_opp_cur_code}'=='${shell_dict["OppCur"]}'
        Run Keyword and Continue On Failure    Should Be True    '${srv_bu_cur_code}'=='${shell_dict["BaseCur"]}'
    END

User Selects Different Client Name
    [Arguments]    ${Client_Name}    ${Expected_Message}    ${ExistingOpp}    ${PKBContact}
    Set Selenium Speed    1s
    #Shell Select Client Name    ${Client_Name}    ${Client_Name}
    Shell Select Client Name    ${Client_Name}    ${Client_Name}
    Run Keyword If    '${ExistingOpp.upper()}'!='YES'    Shell add primary Key buyer    ${PKBContact}    ${title}
    Set Focus To Element    ${Shell Save Button}
    Click Button    ${Shell Save Button}
    Sleep    2s
    Run Keyword And Continue on Failure    Run Keyword If    '${ExistingOpp.upper()}'!='YES'    Page Should Contain Element    ${ErrorSectionPath}//div[text()= '${Expected_Message}']
    Run Keyword And Continue on Failure    Page Should Contain Element    ${WrapperErrorSectionPath}//div[text()= '${Expected_Message}']
    Update Main Client/Account Details    ${Client_Name}
    #Run Keyword And Continue on Failure    Run Keyword If    '${Expected_Message}'== 'Form Saved'    Update Main Client/Account Details    ${Client_Name}
    Set Selenium Speed    ${Delay}

User Selects Different Child Client Name
    [Arguments]    ${Client_Name}    ${Child_Name}    ${ExistingOpp}    ${PKBContact}
    Set Selenium Speed    1s
    Shell Select Child Client Name    ${Client_Name}    ${Child_Name}
    Run Keyword If    '${ExistingOpp.upper()}'!='YES'    Shell add primary Key buyer    ${PKBContact}    ${title}
    Set Focus To Element    ${Shell Save Button}
    Click Button    ${Shell Save Button}
    Sleep    2s
    #Run Keyword And Continue on Failure    Wait Until Element Is Visible    ${ErrorSectionPath}//div[text()= 'Form Saved']
    Run Keyword And Continue on Failure    Run Keyword If    '${ExistingOpp.upper()}'!='YES'    Page Should Contain Element    ${ErrorSectionPath}//div[text()= 'Form Saved']
    Run Keyword And Continue on Failure    Page Should Contain Element    ${WrapperErrorSectionPath}//div[text()= 'Form Saved']
    Update Main Client/Account Details    ${Child_Name}
    Set Selenium Speed    ${Delay}

Delete Shell
    [Arguments]    ${Shell_Name}
    Open Shell From Filter List    ${Shell_Name}
    Run Keyword And Continue On Failure    Wait Until Page Contains Element    ${DELETE DRAFT Btn}
    Click Element    ${DELETE DRAFT Btn}
    Wait Until Page Contains Element    ${Delete Comfirmation}
    Click Element    ${Delete Comfirmation}

Update Main Client/Account Details
    [Arguments]    ${Client}
    ${Shell_Client}    Set Variable    ${Client}
    Set Global Variable    ${Shell_Client}

Select File row
    [Arguments]    ${TC}
    ${File_row}    Set Variable    ${TC}
    Set Global Variable    ${file_row}

Validate Error Message on Shell with missing Fields
    [Arguments]    ${Field}    ${Data_File}
    Click My Opp and Engage Tile
    Run Keyword If    '${Field.upper()}' == 'NAME'    Select File row    TC107a
    Run Keyword If    '${Field.upper()}' == 'BU'    Select File row    TC107b
    Run Keyword If    '${Field.upper()}' == 'EMD'    Select File row    TC107c
    Run Keyword If    '${Field.upper()}' == 'EM'    Select File row    TC107d
    ${shell_dict}=    Get Shell Test Data and Element Locators    ${Data_File}    ${file_row}
    Wait Until Page Contains Element    ${CREATE NEW SHELL Btn}
    Get Horizontal Position    ${CREATE NEW SHELL Btn}
    #Scroll Element Into View    ${CREATE NEW SHELL Btn}
    Click Button    ${CREATE NEW SHELL Btn}
    Check For Opp Button    ${shell_dict["existing"]}
    ${shell_dict_empty}=    Get Shell Test Data and Element Locators    ${Data_File}    TC000
    Run Keyword And Continue On Failure    New Opportunity Setup Form    ${shell_dict}    ${shell_dict_empty}
    Sleep    3s
    Validate Error Message is displayed on iManage Shell for missing mandatory data    ${shell_dict}
    Click Element    ${IMANAGE HOME Link}

Validate Error Message is displayed on iManage Shell for missing mandatory data
    [Arguments]    ${shell_dict}
    Scroll Element Into View    ${ErrorSectionPath}
    Run Keyword And Continue on Failure    Page Should Contain Element    ${ErrorSectionPath}//div[text()= '${shell_dict["onsrceen_msg"]}']
    Scroll Element Into View    ${WrapperErrorSectionPath}
    Run Keyword And Continue on Failure    Page Should Contain Element    ${WrapperErrorSectionPath}//div[text()= '${shell_dict["onsrceen_msg"]}']

Open Assistant From Filter-List
    [Arguments]    ${ShellName}
    Wait Until Page Contains Element    ${SHELL OPP/ENG FILTER input}    30s
    Input Text    ${SHELL OPP/ENG FILTER input}    ${ShellName}${\n}
    Wait Until Element Is Visible    //a[span[@title='${shell_name}']]/ancestor::td/preceding-sibling::td[@aria-label= 'Expand']    30s
    Sleep    2s
    Click Element    //a[span[@title='${ShellName}']]/ancestor::td/preceding-sibling::td[@aria-label= 'Expand']
    Wait until Page Contains Element    ${ASSIST SHELL FILTER LIST}/div[contains(normalize-space(.), 'Account / Client')]

Open Shell moved to closed tab
    [Arguments]    ${ShellName}
    Wait Until Element Is Visible    ${Shell Tab dropdown}
    Click Element    ${Shell Tab dropdown}
    Wait Until Page Contains Element    //div[@class= 'dx-popup-content']//div[text()= 'Closed']
    Sleep    2s
    Click Element    (//div[@class= 'dx-popup-content']//div[@role= 'option'])[2]
    Run Keyword And Ignore Error    Click Element    (//div[@class= 'dx-popup-content']//div[@role= 'option'])[2]
    Sleep    5s
    Input Text    ${SHELL OPP/ENG FILTER input}    ${shell_name}${\n}
    Press Key    ${SHELL OPP/ENG FILTER input}    \\13
    Sleep    3s
    ${status}=    Run Keyword And Return Status    Page Should Contain Element    //a[span[@title='${shell_name}']]    30s
    Run Keyword If    '${status}'=='PASS'    Log    Shell is moved to closed Successfully!
    ...    ELSE    Log    Test Failed!
    Run Keyword And Continue On Failure    Click Element    //a[span[@title='${shell_name}']]
    Wait Until Page Contains Element    //span[@id='shellname']

Create Assistant Attribute Dictionary
    [Arguments]    ${Shell}
    ${Attribute-dict}=    Create Dictionary    ${Shell}=
    ${empty_list}=    Create List
    ${relay_dict}=    Create Dictionary    Main Budget=${EMPTY}    ERA=${EMPTY}    Change Orders=${empty_list}    sub-Budgets=${empty_list}
    Set To Dictionary    ${Attribute-dict}    ${Shell}    ${relay_dict}
    [Return]    ${Attribute-dict}

Add New Key to Assistant Attribute Dictionary
    [Arguments]    ${Attribute-dict}    ${Shell}
    Set To Dictionary    ${Attribute-dict}    ${Shell}=
    ${empty_list}=    Create List
    ${relay_dict}=    Create Dictionary    Main Budget=${EMPTY}    ERA=${EMPTY}    Change Orders=${empty_list}    sub-Budgets=${empty_list}
    Set To Dictionary    ${Attribute-dict}    ${Shell}    ${relay_dict}
    [Return]    ${Attribute-dict}

Add Data To the sub-dict
    [Arguments]    ${Shell}    ${Attribute}    ${value}
    ${sub-dict}=    Get From Dictionary    ${Assitant-Attributes dict}    ${Shell}
    Log    ${sub-dict}
    Set To Dictionary    ${sub-dict}    ${Attribute}    ${value}
    Set To Dictionary    ${Assitant-Attributes dict}    ${Shell}    ${sub-dict}

Add List data to the sub-dict
    [Arguments]    ${Shell}    ${Attribute}    ${value}
    ${sub-dict}=    Get From Dictionary    ${Assitant-Attributes dict}    ${Shell}
    @{val}=    Set Variable    &{sub-dict}[${Attribute}]
    Append To List    ${val}    ${value}
    Set To Dictionary    ${sub-dict}    ${Attribute}=@{val}
    Set To Dictionary    ${Assitant-Attributes dict}    ${Shell}    ${sub-dict}

Add Attribute to the Assistant Attribute Dict
    [Arguments]    ${Shell_Name}    ${Attribute}    ${value}
    ${Status}=    Run Keyword And Return Status    Variable Should Exist    ${Assitant-Attributes dict}
    ${Assitant-Attributes dict}=    Run Keyword If    '${Status}'=='False'    Create Assistant Attribute Dictionary    ${Shell_Name}
    ...    ELSE    Set Variable    ${Assitant-Attributes dict}
    ${Status2}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${Assitant-Attributes dict}    ${Shell_Name}
    ${Assitant-Attributes dict}=    Run Keyword If    '${Status2}'=='False'    Add New Key to Assistant Attribute Dictionary    ${Assitant-Attributes dict}    ${Shell_Name}
    ...    ELSE    Set Variable    ${Assitant-Attributes dict}
    Set Global Variable    ${Assitant-Attributes dict}
    ${val}=    Set Variable    &{Assitant-Attributes dict}[${Shell_Name}]
    ${Val2}=    Set Variable    &{val}[${Attribute}]
    ${passed}=    Run Keyword And Return Status    Evaluate    type(${Val2}).__name__
    ${type}=    Run Keyword If    ${passed}    Evaluate    type(${Val2}).__name__
    Run Keyword If    '${type}'=='None'    Add Data To the sub-dict    ${Shell_Name}    ${Attribute}    ${value}
    ...    ELSE IF    '${type}'=='list'    Add List data to the sub-dict    ${Shell_Name}    ${Attribute}    ${value}
