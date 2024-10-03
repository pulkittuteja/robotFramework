*** Settings ***
Resource          resource.robot    #Library    RPA.Browser.Selenium

*** Variables ***
${Download}       ${CURDIR}\\DownloadedFiles
&{Dict}           username=samina    password=samina

*** Test Cases ***
Close Opportunity
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click My Opp and Engage Tile
    ${DraftShellName_S1}    ${draft_Data_dict_S1}    Create a Draft New Shell    ${iManage_Shell_Data}    TC102
    Set Suite variable    ${DraftShellName_S1}
    Set Suite variable    ${draft_Data_dict_S1}
    Open Shell From Filter List    Test New Opportunity 1619763564
    Sleep    10s
    log    ${shell_dict}
    ${OppurtunityCreated}=    Run Keyword And Return Status    Element Should Be Visible    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Scroll Element Into View    ${OPPORTUNITY STATUS BAR}${OPPORTUNITY STATUS-SUCCESS CREATION}
    log    ${shell_dict["Closed Stage"]}
    log    ${shell_dict["PrimaryReason"]}
    log    ${shell_dict["Proposal Used"]}
    Run Keyword And Continue On Failure    Run Keyword If    '${OppurtunityCreated}'=='True'    Close Opportunity    ${shell_dict["Closed Stage"]}    ${shell_dict["PrimaryReason"]}    ${shell_dict["Proposal Used"]}
    ...    ELSE    Log    Opportunity can't be closed as it's not created yet!

ERA Test Cases
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click My Opp and Engage Tile
    ${DraftShellName_S1}    ${draft_Data_dict_S1}    Create a Draft New Shell    ${iManage_Shell_Data}    TC102
    Set Suite variable    ${DraftShellName_S1}
    Set Suite variable    ${draft_Data_dict_S1}
    Open Shell From Filter List    Test Draft Opportunity 1618171931
    Open iManage Assistant
    Sleep    5s
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    Create an ERA via Shell    ${era_data}    TC001
    ERA with completed Part-1 and Part-2    ${era_data}    TC002
    Summary Section FRAR when selected as Normal
    Submit the ERA for Approval
    Validate ERA is in EMD Awaiting Approval Tab    Normal
    Open ERA From Filter List    ${ERA NAME}    Normal
    Navigate To ERA Approval Link from filter-list
    Approve ERA    ${ERA_dict}    Yes
    Validate ERA is in Approved ERA Tab    Normal

ERA Increased
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click My Opp and Engage Tile
    ${DraftShellName_S1}    ${draft_Data_dict_S1}    Create a Draft New Shell    ${iManage_Shell_Data}    TC102
    Set Suite variable    ${DraftShellName_S1}
    Set Suite variable    ${draft_Data_dict_S1}
    Open Shell From Filter List    Test Draft Opportunity 1618171931
    Open iManage Assistant
    Sleep    5s
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    ERA with completed Part-1 and Part-2    ${era_data}    TC015
    Wait until Element is Visible    ${FRAR Select}
    ${FRAR Selected Value}=    Get Selected List Value    ${FRAR Select}
    Run Keyword And Continue On Failure    Should be equal as strings    ${FRAR Selected Value}    High
    Summary Section FRAR when selected as Normal
    Summary Section FRAR when selected as High
    Summary Section FRAR when selected as Increased
    Click Save and Next Button
    Complete RMAP Section    ${ERA_dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${ERA_dict}
    Click Button    ${SAVE Button}
    Submit the ERA for Approval
    Validate ERA is in EMD Awaiting Approval Tab    Increased
    Open ERA From Filter List    ${ERA NAME}    Increased
    Navigate To ERA Approval Link from filter-list
    Approve ERA    ${ERA_dict}    Yes
    Approve ERA    ${ERA_dict}    No
    Validate ERA is in Approved ERA Tab    Increased
    Navigate to iManage Shell Page

ERA High
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Click My Opp and Engage Tile
    ${DraftShellName_S1}    ${draft_Data_dict_S1}    Create a Draft New Shell    ${iManage_Shell_Data}    TC102
    Set Suite variable    ${DraftShellName_S1}
    Set Suite variable    ${draft_Data_dict_S1}
    Open Shell From Filter List    Test New Opportunity 1619775468
    Open iManage Assistant
    Sleep    5s
    From Assistant Navigate to ${ASSIST ERA Link} further to ${ASSIST ERA CREATE img}
    ERA with completed Part-1 and Part-2    ${era_data}    TC015
    Wait until Element is Visible    ${FRAR Select}
    ${FRAR Selected Value}=    Get Selected List Value    ${FRAR Select}
    Run Keyword And Continue On Failure    Should be equal as strings    ${FRAR Selected Value}    High
    Summary Section FRAR when selected as Increased
    Summary Section FRAR when selected as High
    Complete Summary Section    ${ERA_dict}
    Click Save and Next Button
    Complete RMAP Section    ${ERA_dict}
    Click Save and Next Button
    Complete QCMD Plan Section    ${ERA_dict}
    Click Button    ${SAVE Button}
    Sleep    2s
    Export eQA Lead Plan
    Comment    Submit the ERA for Approval
    Comment    Validate ERA is in EMD Awaiting Approval Tab    High
    Comment    Open ERA From Filter List    ${ERA NAME}    High
    Comment    Navigate To ERA Approval Link from filter-list
    Comment    Approve ERA    ${ERA_dict}    Yes

ERA Download
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait Until Page Contains Element    //li[@id='era']//img[@src='/assets/iManage_ERATile.png']
    Click Element    //li[@id='era']//img[@src='/assets/iManage_ERATile.png']
    Open ERA From Filter List    QA TEST High ERA - Existing Client \ 65530741    High
    Wait Until Page Contains Element    //*[@id="inslider"]/div[6]/table/tr/td[2]/a    30s    #${QCMD Plan Header}
    Click Element    //*[@id="inslider"]/div[6]/table/tr/td[2]/a
    Set Download Directory    ${Download}
    Wait until Page Contains Element    ${EXPORT eQA Lead Plan Button}
    Click Element    ${EXPORT eQA Lead Plan Button}
    ${/}

PDF
    # create unique folder
    ${now}    Get Time    epoch
    Comment    ${Download}    Join Path    ${OUTPUT DIR}    downloads_${now}
    Create Directory    ${Download}
    Comment    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # list of plugins to disable. disabling PDF Viewer is necessary so that PDFs are saved rather than displayed
    ${disabled}    Create List    Chrome PDF Viewer
    ${prefs}    Create Dictionary    download.default_directory=${Download}    plugins.plugins_disabled=${disabled}
    Comment    Call Method    ${chrome options}    add_experimental_option    prefs    ${prefs}
    Comment    Create Webdriver    Chrome    chrome_options=${chrome options}
    Wait until Element is Visible    ${EXPORT eQA Lead Plan Button}
    Goto    ${EXPORT eQA Lead Plan Button}    #http://localhost/download.html
    Click Link    ${EXPORT eQA Lead Plan Button}    # downloads a file
    Click Element    ${EXPORT eQA Lead Plan Button}
    # wait for download to finish
    ${file}    Wait Until Keyword Succeeds    1 min    2 sec    Download should be done    ${Download}

Download PDF
    # create unique folder
    ${now}    Get Time    epoch
    ${download directory}    Join Path    ${OUTPUT DIR}    downloads_${now}
    Create Directory    ${download directory}
    ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # list of plugins to disable. disabling PDF Viewer is necessary so that PDFs are saved rather than displayed
    ${disabled}    Create List    Chrome PDF Viewer
    ${prefs}    Create Dictionary    download.default_directory=${download directory}    plugins.plugins_disabled=${disabled}
    Call Method    ${chrome options}    add_experimental_option    prefs    ${prefs}
    Create Webdriver    Chrome    chrome_options=${chrome options}
    Wait until Element is Visible    ${EXPORT eQA Lead Plan Button}
    Comment    Goto    ${EXPORT eQA Lead Plan Button}    #http://localhost/download.html
    Click Link    ${EXPORT eQA Lead Plan Button}    # downloads a file
    # wait for download to finish
    ${file}    Wait Until Keyword Succeeds    1 min    2 sec    Download should be done    ${download directory}

Test
    Comment    ${currentpath}    evaluate    os.getcwd()    os
    @{list} =    create list    disable-web-security    ignore-certificate-error
    ${args} =    create dictionary    args=${list}    download.default.directory=${Download}
    ${desired_caps} =    create dictionary    chromeOptions=${args}
    Comment    open browser    about:blank    Chrome    desired_capabilities=${desired_caps}
    Setup
    Get Approver Roles    apprv01
    Login in as ADMIN
    Wait Until Page Contains Element    //li[@id='era']//img[@src='/assets/iManage_ERATile.png']
    Click Element    //li[@id='era']//img[@src='/assets/iManage_ERATile.png']
    Open ERA From Filter List    QA TEST High ERA - Existing Client \ 65530741    High
    Wait Until Page Contains Element    //*[@id="inslider"]/div[6]/table/tr/td[2]/a    30s    #${QCMD Plan Header}
    Click Element    //*[@id="inslider"]/div[6]/table/tr/td[2]/a
    Wait until Page Contains Element    ${EXPORT eQA Lead Plan Button}
    Click Element    ${EXPORT eQA Lead Plan Button}

TCDICT
    Should Be Equal As Strings    ${Dict}[password]    ${Dict}[username]

*** Keywords ***
Download should be done
    [Arguments]    ${directory}
    [Documentation]    Verifies that the directory has only one folder and it is not a temp file.
    ...
    ...    Returns path to the file
    ${files}    List Files In Directory    ${directory}
    Length Should Be    ${files}    1    Should be only one file in the download folder
    Should Not Match Regexp    ${files[0]}    (?i).*\\.tmp    Chrome is still downloading a file
    ${file}    Join Path    ${directory}    ${files[0]}
    Log    File was successfully downloaded to ${file}
    [Return]    ${file}
