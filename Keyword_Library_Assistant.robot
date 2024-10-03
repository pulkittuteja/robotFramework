*** Settings ***
Documentation     Keyword Library for iManage Assistant Functionality

*** Variables ***

*** Keywords ***
Open iManage Assistant
    [Documentation]    Keyword waits up to 30s for Hamburger icon to display then clicks the it. Checks is the
    ...    assistant logo is displayed to confirm the assistant is open
    Sleep    13s
    Wait Until Page Contains Element    ${HAMBURGER Btn}    30s
    Click Element    ${HAMBURGER Btn}
    #Select Frame    iframe
    Wait Until Page Contains Element    ${ASSIST LOGO img}    30s
    Unselect Frame

Expand Assistant Section
    [Arguments]    ${section_loc}
    [Documentation]    Pass the section locator as an argument when calling this keyword. In order to get the
    ...    expanded state I need to inspect the parent element to see if @class is 'dropdown' or 'dropdown open'.
    ...    Attmpted to you aria-expanded property but it doesn't exsist on the page at initial load.
    Sleep    3s
    Click Element    ${section_loc}

Link Shell to Existing ERA
    [Arguments]    ${eraname}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST ERA Link}
    Click Element    ${ASSIST ERA LINK img}
    Open ERA From Filter List    ${eraname}
    Sleep    10s

Validate Opportunity Section
    [Arguments]    ${data_dict}
    Run Keyword If    '${data_dict["Salesforce Opportunity"]}'=='' and '${data_dict["Client Name"]}'==''     Element Should Be Visible    ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST MESSAGE text}
    ...    ELSE IF   '${data_dict["Salesforce Opportunity"]}'!=''       Element Should Be Visible    ${ASSIST OPPORTUNITY Link}/following-sibling::ul/li/div/a[text()='Salesforce Opportunity']
    ...    ELSE         Element Should Be Visible    ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST OPPORTUNITY CREATION TEXT}

Open Assistant On ERA and Validate Attached Shells
    [Arguments]         ${Shell_List}
    Open iManage Assistant
    Sleep       15s
    Select Frame    iframe
    Expand Assistant Section        ${ASSIST MY OPP&ENGAGE Link}
    Sleep       5s
    Expand Assistant Section        ${ASSIST MY OPP&ENGAGE Link}
    FOR    ${shell}   IN   @{Shell_List}
           Run Keyword And Continue On Failure       Page Should Contain Element         ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${shell}']
    END

Validate Default Fields on Assistant for Proposed Opportunity Stage
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${shell_dict["Opp/EngName"]}']
    Run Keyword And Ignore Error     Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul${ASSIST CHANGE ORDER IMG}
    Expand Assistant Section    ${ASSIST ACCOUNT/CLIENT Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST SALESFORCE ACCOUNT Link}
    # Opportunity is currently showing the no opportunity text when it should be the link.. will change again after integration is completed
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure     Validate Opportunity Section    ${shell_dict}
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA CREATE img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA LINK img}
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Ignore Error    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST BUDGET CREATION TEXT}
    # Create teams icon shows but no "Teams Site creation in process" text anymore? - will need to confirm and fix if necessary
    Expand Assistant Section    ${ASSIST COLLABORATION Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST COLLABORATION Link}/following-sibling::ul${ASSIST COLLABORATION CREATION TEXT}
    Expand Assistant Section  ${ASSIST PKIC REQUEST Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST CDR CREATE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST PKIC CREATE Link}
    #Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST VIEW PKIC Link}

Validate Default Fields on Assistant for Identified Opportunity Stage
    [Arguments]     ${OportunityName}
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${OportunityName}']
    Run Keyword And Ignore Error     Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul${ASSIST CHANGE ORDER IMG}
    Expand Assistant Section    ${ASSIST ACCOUNT/CLIENT Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST SALESFORCE ACCOUNT Link}
    # Opportunity is currently showing the no opportunity text when it should be the link.. will change again after integration is completed
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure     Validate Opportunity Section    ${shell_dict}
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA CREATE img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST ERA LINK img}
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul//img
    # Create teams icon shows but no "Teams Site creation in process" text anymore? - will need to confirm and fix if necessary
    Expand Assistant Section    ${ASSIST COLLABORATION Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST COLLABORATION Link}/following-sibling::ul${ASSIST COLLABORATION IMG}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST COLLABORATION Link}/following-sibling::ul${ASSIST COLLABORATION TeamSiteTEXT}
    Expand Assistant Section  ${ASSIST PKIC REQUEST Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST CDR CREATE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST PKIC CREATE Link}
    #Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul${ASSIST VIEW PKIC Link}

Validate Assistant on Change Order
    [Arguments]         ${ERA Name}      ${CO Name}       ${Shell Name}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${Shell Name}']
    Run Keyword And Continue On Failure    Element Should Be Visible        ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul${ASSIST CHANGE ORDER IMG}
    Run Keyword And Continue On Failure    Element Should Be Visible        ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title= '${CO Name}']
    Expand Assistant Section    ${ASSIST ACCOUNT/CLIENT Link}
    Run Keyword and Continue On Failure         Element Should Be Visible       ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST SALESFORCE ACCOUNT Link}
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure    Element Should Be Visible        ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST OPPORTUNITY CREATED LINK}
    Expand Assistant Section    ${ASSIST ERA Link}
    ${ERA Name_New}     Get Substring       ${ERA Name}      0       30
    Run Keyword And Continue On Failure         Wait Until Element Is Visible       ${ASSIST ERA UNLINK img}
    #Run Keyword And Continue On Failure         Run Keyword If      '${ERA}'=='Salesforce ERA'         Element Should Be Visible           //a[contains(text(), '${ERA}')]
    Run Keyword And Continue On Failure           Element Should Be Visible           ${ASSIST ERA Link}/following-sibling::ul//a[contains(text(), '${ERA Name_New}')]
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul//a[contains(normalize-space(.), '${Shell Name}')]
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET CREATE img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET COPY img}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST SUB BUDGET LINK img}


Validate assistant is inactive
    [Arguments]     ${data_dict}
    Open iManage Assistant
    Expand Assistant Section    ${ASSIST MY OPP&ENGAGE Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${data_dict["Opp/EngName"]}']
    Expand Assistant Section    ${ASSIST ACCOUNT/CLIENT Link}
    Run Keyword If      '${data_dict["Client Name"]}'==''       Element Should Be Visible       ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST NO ACCOUNT/CLIENT TEXT}
    ...         ELSE        Element Should Be Visible       ${ASSIST ACCOUNT/CLIENT Link}/following-sibling::ul${ASSIST SALESFORCE ACCOUNT Link}
    Expand Assistant Section    ${ASSIST OPPORTUNITY Link}
    Run Keyword And Continue On Failure    Element Should Be Visible        ${ASSIST OPPORTUNITY Link}/following-sibling::ul${ASSIST NO OPPORTUNITY TEXT}
    Expand Assistant Section    ${ASSIST ERA Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST ERA Link}/following-sibling::ul${ASSIST NO ERA TEXT}
    Expand Assistant Section    ${ASSIST BUDGETS Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST BUDGETS Link}/following-sibling::ul${ASSIST NO SUB BUDGET TEXT}
    Expand Assistant Section    ${ASSIST COLLABORATION Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST COLLABORATION Link}/following-sibling::ul${ASSIST NO COLLABORATION TEXT}
    Expand Assistant Section  ${ASSIST PKIC REQUEST Link}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${ASSIST PKIC REQUEST Link}/following-sibling::ul//p[contains(normalize-space(.), 'Shell is incomplete.')]

Validate Assistant Parameters on Shell Filter-List
    [Arguments]     ${Shell}
    Open Assistant Section on filter-list      Account / Client
    Run Keyword And Continue On Failure    Element Should Be Visible         //div[@class= 'detailContentAccount ng-star-inserted']/p[text()= ' Salesforce Account: ']
    Run Keyword And Continue On Failure    Element Should Be Visible         //div[@class= 'detailContentAccount ng-star-inserted']//a[text()= '${Shell_Client}']
    Open Assistant Section on filter-list       Opportunity
    Run Keyword And Continue On Failure    Element Should Be Visible        //div[@class= 'detailContentOpportunity ng-star-inserted']//a['Original Salesforce Opportunity']
    Open Assistant Section on filter-list       ERA
    Run Keyword And Continue On Failure    Element Should Be Visible        //div[@class= 'detailContentERA ng-star-inserted']//a['${ERA NAME}']
    Open Assistant Section on filter-list       Budgets
    Run Keyword And Continue On Failure    Element Should Be Visible        //div[@class= 'detailContentBudget ng-star-inserted']//a[text()= '${Shell}']
    Run Keyword And Continue On Failure    Element Should Be Visible        //div[@class= 'detailContentBudget ng-star-inserted']//span[text()= 'No Sub Budgets have been created/linked.']
    Open Assistant Section on filter-list       Collaboration
    Run Keyword And Continue On Failure    Element Should Be Visible        //div[@class= 'detailContentTeamsSite ng-star-inserted']//div[text()= 'Teams Site creation in progress.']
    Open Assistant Section on filter-list       Change Order Shells
    Run Keyword And Continue On Failure    Element Should Be Visible        //div[@class= 'detailChangeOrder ng-star-inserted']//p[text()= 'No Change Order Opportunities have been created.']

Open Assistant Section on filter-list
    [Arguments]     ${TextLoc}
    Click Element       ${ASSIST SHELL FILTER LIST}/div[contains(normalize-space(.), '${TextLoc}')]

From Assistant select shell and validate Attached Attributes
    [Arguments]         ${Shell_List}
    FOR    ${shell}   IN   @{Shell_List}
        Expand Assistant Section        ${ASSIST MY OPP&ENGAGE Link}
        Click Element         ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${shell}']/preceding-sibling::img
        Expand Assistant Section        ${ASSIST MY OPP&ENGAGE Link}
        ${Shell_Attributes}=        Get From Dictionary     ${Assitant-Attributes dict}     ${shell}
        ${CO_List}=     Set Variable        ${Shell_Attributes['Change Orders']}
        Validate Attached Change Orders to the Selected Shell in Assistant      ${CO_List}
        Expand Assistant Section        ${ASSIST ERA Link}
        Run Keyword If      '${Shell_Attributes['ERA']}'!=''      Page Should Contain Element         ${ASSIST ERA Link}/following-sibling::ul//a[text() = '${Shell_Attributes['ERA']}']
        Expand Assistant Section        ${ASSIST BUDGETS Link}
        Run Keyword If      '${Shell_Attributes['Main Budget']}'!=''      Page Should Contain Element         ${ASSIST BUDGETS Link}/following-sibling::ul//a[@title= '${Shell_Attributes['Main Budget']}']
        ...         ELSE
        ...         Page Should Contain Element         ${ASSIST BUDGETS Link}/following-sibling::ul//img
        ${Sub-Budget_List}=     Set Variable        ${Shell_Attributes['sub-Budgets']}
        Validate Attached sub-Budgets to the Selected Shell in Assistant      ${Sub-Budget_List}
    END

Validate Attached Change Orders to the Selected Shell in Assistant
    [Arguments]     ${CO_List}
    FOR     ${CO}   IN   @{CO_List}
        Run Keyword And Continue On Failure       Page Should Contain Element         ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title='${CO}']
    END

Validate Attached sub-Budgets to the Selected Shell in Assistant
    [Arguments]     ${sub-Budget_List}
    FOR     ${sub}   IN   @{sub-Budget_List}
        Run Keyword And Continue On Failure       Page Should Contain Element         ${ASSIST BUDGETS Link}/following-sibling::ul//a[@title= '${sub}']
    END




