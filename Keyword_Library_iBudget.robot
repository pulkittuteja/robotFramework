*** Settings ***
Documentation     Keyword Library for iBudget Functionality
Resource          Keyword_Library_iBudget_Calculations.robot

*** Variables ***
@{EmpExp_BudgetCost}
@{EmpExp_BudgetBillings}
@{RHCExp_BudgetCost}
@{RHCExp_BudgetBillings}
@{IHCExp_BudgetCost}
@{IHCExp_BudgetBillings}
@{MFExp_BudgetCost}
@{MFExp_BudgetBillings}
@{IBUExp_BudgetCost}
@{IBUExp_BudgetBillings}
@{OtherFeesEACCost}
@{OtherFeesEACBillings}
${Contract_Form}    JAL
${Contract_Version}    Original
${HyperLink}      https://www.yahoo.com/
${Workflow}       //*[@id="TabControl_T7T"]/span    # Workflow Tab
${Submit this Budget}    //div[@id='SubmitBudget_CD']/span[@class='dx-vam']    # Clicking on Submit This budget on Workflow Tab
${Last Workflow Action}    //*[@id="GVWorkflowTasks_tccell0_1"]
${Workflow Status}    \    # To get the Text from the xpath
${FSC Returned - Update Budget}    //*[@id="LastWorkflowAction_DDD_L_LBI1T0"]
${Save}           //*[@id="Save_CD"]
${Fsc-Approved}    //*[@id="LastWorkflowAction_DDD_L_LBI0T0"]    # Selecting fsc-approved from the dropdown menu
${Response Arrow for Dropdown}    //*[@id="LastWorkflowAction_B-1"]
${FSC Returned - Update Information}    //*[@id="LastWorkflowAction_DDD_L_LBI2T0"]
${FSC On Hold}    //*[@id="LastWorkflowAction_DDD_L_LBI3T0"]
${FSC Workflow Comments}    //*[@id="WorkflowComments_I"]
${EM comments to EMD}    //*[@id="EMDNote_I"]    # After submitting Budget EM Comments to EMD
${x}              ${EMPTY}
${Return Reason}    ${EMPTY}
${EMD Approved}    //*[@id="LastWorkflowAction_DDD_L_LBI0T0"]
${EMD Returned - Update Information }    //*[@id="LastWorkflowAction_DDD_L_LBI2T0"]
${EMD Returned - Update Budget}    //*[@id="LastWorkflowAction_DDD_L_LBI2T0"]
${Bypass/activate this budget}    //*[@id="BypassActivateBudget_CD"]/span

*** Keywords ***
Get Budget Test Data
    [Arguments]    ${contentSheet}    ${row}
    [Documentation]    This Keyword creates a data dictionary which contains the data for the Budget that is to becreated.
    ...    Arguments: 1. Data Sheet name.
    ...    2. Row/ Test Case no.
    Set Log Level    NONE
    ${budget_dict}=    Get Data From CSV File    ${contentSheet}    TC#    ${row}
    ${t}=    Get TimeStamp
    Set Test Variable    ${t}
    Run Keyword If    '${budget_dict["Project Description"]}'!=''    Set To Dictionary    ${budget_dict}    Project Description    ${budget_dict["Project Description"]} ${t}
    Set Log Level    INFO
    [Return]    ${budget_dict}

Open Budget from Filter-List
    [Arguments]    ${budget_Name}
    Wait Until Element Is Visible    ${ibudget project description input}    30s
    Input Text    ${ibudget project description input}    ${budget_Name}${\n}
    Sleep    7s
    Wait Until Element Is Visible    //td[@title= '${budget_Name}']    10s
    Click Element    //td[@title= '${budget_Name}']//a

Open sub-Budget Linked to Main
    [Arguments]    ${sub-budget_Name}
    Scroll Element Into View    ${ibudget Add sub-Budget Link}
    Input Text    ${ibudget sub Name Input}    ${sub-budget_Name}${\n}
    Sleep    5s
    Wait Until Element Is Visible    //td[@title= '${sub-budget_Name}']
    Click Element    //td[@title= '${sub-budget_Name}']/a
    Wait Until Element Is Visible    ${sub-budget Expenses Tab}    30s

Open New Sub-Budget Form
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${ibudget New budget Link}    30s
    Run Keyword If    ${Status} == True    Click Element    ${ibudget New budget Link}
    ...    ELSE    Open toggle navigation sub-budget dropdown    Create New Budget
    Wait Until Element Is Visible    ${sub-budget PD Input}    30s

Open New Shell From iBudget
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${ibudget New budget Link}    30s
    Run Keyword If    ${Status} == True    Click Element    ${ibudget New Shell Link}
    ...    ELSE    Open toggle navigation sub-budget dropdown    Create New Shell

Open toggle navigation sub-budget dropdown
    [Arguments]    ${text}
    Wait Until Element Is Visible    ${ibudget toggle navigation}    30s
    Click Element    ${ibudget toggle navigation}
    Click Element    //a[text()= '${text}']

Complete Sub-Budget Form
    [Arguments]    ${sub_budget_data}    ${tcno}
    [Documentation]    This Keyword creates a Sub-Budget. Sub-Budget can be created by two ways: First one directly from ibudget and secondly
    ...    from Assistant via iManage Shell. Keyword will understand the type of budget creation based on data present in datasheet.
    ...    (i.e. Client & BU will be diabled when created from Assistant- Mentioned fields should remain blank in datasheet.)
    ...    Arguments: 1. Budget Data File
    ...    2. Test case number from data file
    ${budget_dict}=    Get Budget Test Data    ${sub_budget_data}    ${tcno}
    Set Global Variable    ${budget_dict}
    Run Keyword If    '${budget_dict["Project Description"]}'!=''    Input Text    ${sub-budget PD Input}    ${budget_dict["Project Description"]}
    Run Keyword If    '${budget_dict["Client"]}'!=''    Input Text    ${sub-budget Client input}    ${budget_dict["Client"]}
    Run Keyword If    '${budget_dict["BU"]}'!=''    Select sub-budget BU    ${budget_dict["BU"]}
    Run Keyword If    '${budget_dict["EMD"]}'!=''    Select ibudget EMD    ${budget_dict["EMD"]}
    Run Keyword If    '${budget_dict["EM"]}'!=''    Select ibudget EM    ${budget_dict["EM"]}
    Run Keyword If    '${budget_dict["Service Offering"]}'!=''    Select sub-budget Service Offering    ${budget_dict["Service Offering"]}
    Run Keyword If    '${budget_dict["Rate Card Type"]}'!=''    Select sub-budget Rate Card Type    ${budget_dict["Rate Card Type"]}
    Sleep    3s
    Click Element    ${sub-budget create button}
    Create iBudget Output Dictionary And Initialize it
    ${Base_Currency}=    Get Element Attribute    //input[@id= 'Currency_I']    value
    Run Keyword If    '${budget_dict["Contract Currency"]}'==''    Set To Dictionary    ${budget_dict}    Contract Currency    ${Base_Currency}
    ${cur_rates}=    Normalize Currency Rates    ${Base_Currency}    ${budget_dict["Contract Currency"]}
    Set Global Variable    ${cur_rates}
    Run Keyword If    '${budget_dict["Project Department"]}'!=''    Update Project Department    ${budget_dict["Project Department"]}
    Run Keyword If    '${budget_dict["Contract Currency"]}'!='' and '${budget_dict["Contract Currency"]}'!='${Base_Currency}'    Update Contract Currency    ${budget_dict["Contract Currency"]}
    ${currency}=    Get From Dictionary    ${budget_dict}    Contract Currency
    Run Keyword If    '${budget_dict["Rate Card Type"]}'=='Hourly' and '${budget_dict["Contract rate Type"]}'!=''    Add Contract Rate    ${budget_dict["Contract rate Type"]}    &{cur_rates}[${currency}]
    Run Keyword If    '${budget_dict["Rate Card Type"]}'=='Unit/Value-Based' and '${budget_dict["Unit-Based CR"]}'!=''    Add Unit Based Contract Rate Card    ${budget_dict}
    Minimize Budget Gauge
    Run Keyword If    '${budget_dict["Rate Card Type"]}'=='Hourly' and '${budget_dict["Contract Rate"]}'!=''    Add Contract Rate Card Exception on sub-budget    ${budget_dict["Contract Rate"]}    &{cur_rates}[${currency}]
    Run Keyword If    '${budget_dict["Rate Card Type"]}'=='Hourly' and '${budget_dict["MF/IBU Contract Rate"]}'!=''    Add MF/IBU Contract Rate Card Exception on sub-budget    ${budget_dict["MF/IBU Contract Rate"]}    ${cur_rates}
    [Return]    ${budget_dict["Project Description"]}

Select sub-budget BU
    [Arguments]    ${BU}
    [Documentation]    This Keyword selects BU on the New Sub-budget.
    Set Selenium Speed    1s
    Click Element    ${sub-budget BU dropdown}
    Click Element    //tr[@class= 'dxeListBoxItemRow_Aqua']/td[contains(normalize-space(.), '${BU}')]
    Set Selenium Speed    ${DELAY}

Select ibudget EMD
    [Arguments]    ${EMD}
    [Documentation]    This Keyword selects EMD on a New Sub-budget.
    Set Selenium Speed    1s
    Click Element    ${sub-budget EMD dropdown}
    Wait Until Page Contains Element    ${sub-budget EMD Name Filter-list}
    Input Text    ${sub-budget EMD Name Filter-list}    ${EMD}
    Wait Until Element Is Visible    //table[@id= 'gridLookupEMD_DDD_gv_DXMainTable']//td[contains(normalize-space(.), '${EMD}')]    10s
    Click Element    //table[@id= 'gridLookupEMD_DDD_gv_DXMainTable']//td[contains(normalize-space(.), '${EMD}')]
    Set Selenium Speed    ${DELAY}

Select ibudget EM
    [Arguments]    ${EM}
    [Documentation]    This Keyword selects EM on a New Sub-budget.
    Set Selenium Speed    1s
    Click Element    ${sub-budget EM dropdown}
    Wait Until Page Contains Element    ${sub-budget EM Name Filter-list}
    Input Text    ${sub-budget EM Name Filter-list}    ${EM}
    Wait Until Element Is Visible    //table[@id= 'gridLookupEM_DDD_gv_DXMainTable']//td[contains(normalize-space(.), '${EM}')]    10s
    Click Element    //table[@id= 'gridLookupEM_DDD_gv_DXMainTable']//td[contains(normalize-space(.), '${EM}')]
    Set Selenium Speed    ${DELAY}

Select sub-budget Service Offering
    [Arguments]    ${Service}
    [Documentation]    This Keyword selects Service Offerings on a New Sub-budget.
    Click Element    ${sub-budget Service Offering dropdown}
    Wait Until Element Is Visible    ${sub-budget Service filter-list}${sub-budget Service Offering filter input}    10s
    Input Text    ${sub-budget Service Offering filter input}    ${Service}${\n}
    Sleep    3s
    Wait Until Element Is Visible    //tr[@id= 'GridLookupPrimaryService_DDD_gv_DXDataRow0']/td[contains(normalize-space(.), '${Service}')]    10s
    Click Element    //tr[@id= 'GridLookupPrimaryService_DDD_gv_DXDataRow0']/td[contains(normalize-space(.), '${Service}')]
    Sleep    3s

Select sub-budget Rate Card Type
    [Arguments]    ${Rate}
    [Documentation]    This Keyword selects Rate card Type on a New Sub-budget.
    Click Element    ${sub-budget Rate Card dropdown}
    Wait Until Element Is Visible    //table[@id= 'ContractFeeType_DDD_L_LBT']//td[contains(normalize-space(.), '${Rate}')]    10s
    Click Element    //table[@id= 'ContractFeeType_DDD_L_LBT']//td[contains(normalize-space(.), '${Rate}')]

Update Project Department
    [Arguments]    ${Dept}
    Wait Until Element Is Visible    ${sub-budget Proj Dept dropdown}    10s
    Click Element    ${sub-budget Proj Dept dropdown}
    Press Key    ${sub-budget Proj Dept input}    \\08
    Input Text    ${sub-budget Proj Dept input}    ${Dept}
    Click Element    //div[@id= 'DeptId_DDD_L_D']//em[text()= '${Dept}']
    Sleep    2s
    Click Element    ${sub-budget Save Button}
    Sleep    10s

Update Contract Currency
    [Arguments]    ${Currency}
    Wait Until Element Is Visible    ${sub-budget Contract Currency dropdown}    10s
    Click Element    ${sub-budget Contract Currency dropdown}
    Press Key    ${sub-budget Contract Currency input}    \\08
    Input Text    ${sub-budget Contract Currency input}    ${Currency}
    Sleep    2s
    Click Element    //table[@id= 'gridLookupContractCurrency_DDD_gv_DXMainTable']//td[text()= '${Currency}']
    Sleep    2s
    Click Element    ${sub-budget Save Button}
    Sleep    10s

Add Contract Rate
    [Arguments]    ${Contract rate}    ${cur_rate}
    ${ContractRate_dict}=    Get Data From CSV File    ${ibudget_contract_rate}    Job Function    ${Contract rate}
    Set Global Variable    ${ContractRate_dict}
    Add Contract Rate For Job Functions    Managing Director 1    ${ContractRate_dict["Managing Director 1"]}
    Add Contract Rate For Job Functions    Senior Director    ${ContractRate_dict["Senior Director"]}
    Add Contract Rate For Job Functions    Director    ${ContractRate_dict["Director"]}
    Add Contract Rate For Job Functions    Associate Director    ${ContractRate_dict["Associate Director"]}
    Add Contract Rate For Job Functions    Senior Manager    ${ContractRate_dict["Senior Manager"]}
    Add Contract Rate For Job Functions    Manager    ${ContractRate_dict["Manager"]}
    Add Contract Rate For Job Functions    Senior Consultant 1    ${ContractRate_dict["Senior Consultant 1"]}
    Add Contract Rate For Job Functions    Senior Consultant 2    ${ContractRate_dict["Senior Consultant 2"]}
    Add Contract Rate For Job Functions    Consultant 1    ${ContractRate_dict["Consultant 1"]}
    Add Contract Rate For Job Functions    Consultant 2    ${ContractRate_dict["Consultant 2"]}
    Add Contract Rate For Job Functions    Intern    ${ContractRate_dict["Intern"]}
    Add Contract Rate For Job Functions    Associate    ${ContractRate_dict["Associate"]}
    Click Element    ${sub-budget Save Button}
    Sleep    30s
    Validate Contract Rate(Base) Exchange rates on Budget    ${ContractRate_dict}    ${cur_rate}

Add Contract Rate For Job Functions
    [Arguments]    ${job function}    ${rate}
    Wait Until Element Is Visible    (//table[@class= 'contractratetable'])[2]//td[text()= '${job function}']    30s
    ${val}    Get Value    (//table[@class= 'contractratetable'])[2]//td[text()= '${job function}']/following-sibling::td//input[@type= 'text']
    Log    ${val}
    ${count}    Get Length    ${val}
    Log    ${count}
    Scroll Element Into View    (//table[@class= 'contractratetable'])[2]//td[text()= '${job function}']/following-sibling::td//input[@type= 'text']
    Click Element    (//table[@class= 'contractratetable'])[2]//td[text()= '${job function}']/following-sibling::td//input[@type= 'text']
    Run Keyword If    """${val}""" != ''    Repeat Keyword    ${count +1}    Press Key    (//table[@class= 'contractratetable'])[2]//td[text()= '${job function}']/following-sibling::td//input[@type= 'text']    \\08
    Input Text    (//table[@class= 'contractratetable'])[2]//td[text()= '${job function}']/following-sibling::td//input[@type= 'text']    ${rate}
    #Run Keyword And Continue On Failure    Wait Until Element Is Visible    //table[@class= 'contractratetable']//td[contains(normalize-space(.), '${job function}')]/following-sibling::td[2]/div[text()= '${rate}']    15s

Validate Contract Rate(Base) Exchange rates on Budget
    [Arguments]    ${ContractRate_dict}    ${cur_rate}
    FOR    ${Key}    IN    @{ContractRate_dict.keys()}
        ${BaseRate_UI}=    Get Text    (//table[@class= 'contractratetable'])[2]//td[text()= '${Key}']/following-sibling::td//div[@class= 'divexchangerate']
        ${CalculatedBaseValue}=    Evaluate    &{ContractRate_dict}[${Key}]*${cur_rate}
        ${CalculatedBaseValue_Rounded}=    Convert To Number    ${CalculatedBaseValue}    2
        ${result}=    Run Keyword And Return Status    Should Be Equal As Numbers    ${BaseRate_UI}    ${CalculatedBaseValue_Rounded}
        Run Keyword If    '${result}'=='True'    Set To Dictionary    ${ContractRate_dict}    ${Key}    ${CalculatedBaseValue}
    END

Add Unit Based Contract Rate Card
    [Arguments]    ${data_dict}
    Wait Until Element Is Visible    ${Unit-Based CR New Button}    10s
    ${Resource_dict}=    Get Resource Details Dict    ${data_dict["Unit-Based CR"]}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${CR_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Click Element    ${Unit-Based CR New Button}
        Click Element    ${Unit-Based CR Header}
        Enter Unit-Based Contract Rate content on table    ${CR_table_data}
        Scroll Element Into View    ${Unit-Based CR Save Link Button}
        Click Element    ${Unit-Based CR Save Link Button}
        Sleep    5s
        ${currency}=    Get From Dictionary    ${budget_dict}    Contract Currency
        Run Keyword And Continue On Failure    Verify Contract Rate(Base) for added Unit-Value Resource    ${CR_table_data}    ${currency}
    END
    Complete Unit Value Estimate Tab    ${data_dict}    ${Resource_dict}

Enter Unit-Based Contract Rate content on table
    [Arguments]    ${CR_details}
    FOR    ${i}    IN RANGE    1    3
        ${j}=    Evaluate    ${i}+1
        ${k}=    Evaluate    ${i}-1
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'gvUnitRateCard_DXEditor${i}_I']
        Click Element    //tr[@id= 'gvUnitRateCard_DXDataRow-1']/td[${j}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE    Input Text    //input[@id= 'gvUnitRateCard_DXEditor${i}_I']    @{CR_details}[${k}]
        Click Element    ${Unit-Based CR Header}
    END

Verify Contract Rate(Base) for added Unit-Value Resource
    [Arguments]    ${CR_data}    ${currency}
    ${Calculated_Contract_rate_Base}=    Evaluate    ${CR_data[1]}*&{cur_rates}[${currency}]
    ${Calculated_Contract_rate_Base}=    Convert To Number    ${Calculated_Contract_rate_Base}    2
    ${Calculated_Contract_rate_Base}=    Evaluate    "%.2f" % ${Calculated_Contract_rate_Base}
    Run Keyword And Continue On Failure    Wait Until Element Is Visible    //table[@id= 'gvUnitRateCard_DXMainTable']//td[contains(normalize-space(.), '${CR_data[0]}')]/following-sibling::td[contains(normalize-space(.), '${CR_data[1]}')]/following-sibling::td[text()= '${Calculated_Contract_rate_Base}']
    ${Contract_Rate_Base_UI}=    Get Text    //table[@id= 'gvUnitRateCard_DXMainTable']//td[contains(normalize-space(.), '${CR_data[0]}')]/following-sibling::td[contains(normalize-space(.), '${CR_data[1]}')]/following-sibling::td[1]
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${Contract_Rate_Base_UI}    ${Calculated_Contract_rate_Base}

Complete Unit Value Estimate Tab
    [Arguments]    ${data_dict}    ${Resource_dict}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Unit Value Estimate Tab}
    Wait Until Page Contains Element    ${Unit Value Estimate Header}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${task_data}=    Split String    &{Resource_dict}[${Key}]    ;
        ${Task}=    Run Keyword And Return Status    Page Should Contain Element    //table[@id= 'gvUnitBasedWizard']//td[text()= '@{task_data}[0]']
        Run Keyword If    '${Task}'=='True'    Add EAC QTY For Unit Value Estimate    @{task_data}[0]    @{task_data}[-2]
        Click Element    ${Unit Value Estimate Save Changes Link}
        Sleep    10s
        ${UnitValEACQTY}    ${UnitValEACBillings}    Calculate & Verify Working Budget parameters for Unit Value Estimate Table    @{task_data}[0]    @{task_data}[1]    @{task_data}[-1]
    END
    Calculate & Verify Unit/Value-Based Services Total    ${UnitValEACQTY}    ${UnitValEACBillings}
    Run Keyword If    '${data_dict["Volume Discount"]}'!=''    Input Text    ${Unit Value Estimate Volume Discount Input}    ${data_dict["Volume Discount"]}
    Run Keyword If    '${data_dict["Volume Discount"]}'!=''    Click Element    ${Unit Value Estimate Header}
    Sleep    5s
    Run Keyword If    '${data_dict["Volume Discount"]}'!=''    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_VolumeDiscount    ${data_dict["Volume Discount"]}
    Run Keyword If    '${data_dict["Adjustments"]}'!=''    Input Text    ${Unit Value Estimate Adjustments Input}    ${data_dict["Adjustments"]}
    Run Keyword If    '${data_dict["Adjustments"]}'!=''    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_PlannedInvestment    ${data_dict["Adjustments"]}
    Click Element    ${Unit Value Estimate Save Button}
    Sleep    5s
    Calculate & Verify Adjusted Net Unit/Value-Based fees

Add EAC QTY For Unit Value Estimate
    [Arguments]    ${task}    ${EACvalue}
    Click Element    (//table[@id= 'gvUnitBasedWizard']//td[text()= '${task}']/following-sibling::td)[2]
    Wait Until Page Contains Element    (//table[@id= 'gvUnitBasedWizard']//td[text()= '${task}']/following-sibling::td)[2]//input[@type= 'text']    10s
    Press Key    (//table[@id= 'gvUnitBasedWizard']//td[text()= '${task}']/following-sibling::td)[2]//input[@type= 'text']    \\08
    Input Text    (//table[@id= 'gvUnitBasedWizard']//td[text()= '${task}']/following-sibling::td)[2]//input[@type= 'text']    ${EACvalue}

Add Contracts details on Main
    [Arguments]    ${C_Form}    ${C_Version}    ${Link}
    Set Selenium Speed    1s
    Wait Until Element Is Visible    ${ibudget Main Contracts New Link}    30s
    Click Element    ${ibudget Main Contracts New Link}
    Wait Until Element Is Visible    ${ibudget Main Contract Form dropdown}    10s
    Click Element    ${ibudget Main Contract Form dropdown}
    Click Element    //table[@id= 'ContractsGridView_DXEditor1_DDD_L_LBT']/tbody//tr[contains(normalize-space(.), '${C_Form}')]
    Click Element    ${ibudget Main Contract Version dropdown}
    Click Element    //table[@id= 'ContractsGridView_DXEditor2_DDD_L_LBT']/tbody//tr[contains(normalize-space(.), '${C_Version}')]
    Input Text    ${ibudget Main Hyperlink input}    ${Link}
    Click Element    ${ibudget Main Contract Update Link}
    Run Keyword And Continue On Failure    Wait Until Page Contains Element    ${ibudget Main Contract Edit Link}    10s
    Run Keyword And Continue On Failure    Wait Until Page Contains Element    ${ibudget Main Contract Delete Link}    10s
    Set Selenium Speed    ${Delay}

Update Main Project Number
    [Arguments]    ${BU}
    ${r}=    Evaluate    random.randint(30000, 99999)    random,sys
    ${Mcode}=    Set variable    ${BU}${r}
    Wait Until Element Is Visible    ${ibudget Main Project Code Input}    10s
    Input Text    ${ibudget Main Project Code Input}    ${Mcode}
    Click Element    ${ibudget Main Save button}
    Sleep    5s
    [Return]    ${Mcode}

Update sub-Budget Project Number
    [Arguments]    ${Main_code}
    ${sub_code}=    Catenate    ${Main_code}-08
    Wait Until Element is Visible    ${sub-budget Project Code Input}    10s
    Input Text    ${sub-budget Project Code Input}    ${sub_code}
    Click Element    ${sub-budget Save Button}

Add Contract Rate Card Exception on sub-budget
    [Arguments]    ${Rate_List}    ${curr_rate}
    Wait Until Element Is Visible    ${sub-budget Contract Rate New Button}    10s
    ${Resource_dict}=    Get Resource Details Dict    ${Rate_List}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${CR_details}=    Split String    &{Resource_dict}[${Key}]    ;
        Log    ${CR_details}
        Wait Until Element Is Visible    ${sub-budget Contract Rate New Button}    10s
        Click Element    ${sub-budget Contract Rate New Button}
        Enter Hourly Contract Rate Exception content on table    ${CR_details}    ${curr_rate}
    END
    Calculate total Contract Rate Exception Amount for all Exception Labor Resources

Enter Hourly Contract Rate Exception content on table
    [Arguments]    ${CR_Exception_data}    ${curr_rate}
    ${Resource_Type}=    Run Keyword If    '@{CR_Exception_data}[0]'!=''    Select Contract Rate Exception Name    @{CR_Exception_data}[0]
    ...    ELSE    Log    No Rate card Name Is Provided!
    Run Keyword If    '@{CR_Exception_data}[1]'!=''    Select Contract rate on Sub-Budget    @{CR_Exception_data}[1]
    ...    ELSE    Log    No Contract Rate is Provided!
    Click Element    ${sub-budget Contract Rate Save Changes Link}
    Sleep    3s
    ${Contract_Rate_Base_UI}=    Get Text    //table[@id= 'GVContractRateExcRate_DXMainTable']//td[text()='@{CR_Exception_data}[0]']/following-sibling::td[2]
    ${Contract_Rate_Base}=    Evaluate    @{CR_Exception_data}[1]*${curr_rate}
    ${Contract_Rate_Base}=    Convert To Number    ${Contract_Rate_Base}    2
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${Contract_Rate_Base_UI}    ${Contract_Rate_Base}
    Set To Dictionary    ${ContractRate_dict}    @{CR_Exception_data}[0]    ${Contract_Rate_Base}
    Run Keyword If    '${Resource_Type}'!= 'None'    Complete Corresponding Labor details for Exception Resource    ${Resource_Type}    ${CR_Exception_data}
    ...    ELSE    Log    Invalid Data
    #${CREX_QTY_List}    ${CREX_Cost_List}    ${CREX_Billing_List}    Complete Corresponding Labor details for Exception Resource    @{CR_Exception_data}[0]    @{CR_Exception_data}[2]
    #[Return]    ${CREX_QTY_List}    ${CREX_Cost_List}    ${CREX_Billing_List}

Complete Corresponding Labor details for Exception Resource
    [Arguments]    ${Resource_Type}    ${Resource_data}
    Run Keyword If    '${Resource_Type}'=='Practice Employee' or '${Resource_Type}'=='Operations Employee'    Complete Employee Labor details for Exception Resource    @{Resource_data}[0]    @{Resource_data}[2]
    ...    ELSE IF    '${Resource_Type}'=='RH Contractor'    Complete RH Contractor Labor details for Exception Resource    @{Resource_data}[0]    @{Resource_data}[2]    @{Resource_data}[3]
    ...    ELSE    Complete Independent Contractor Labor details for Exception Resource    @{Resource_data}[0]    @{Resource_data}[2]    @{Resource_data}[3]    @{Resource_data}[4]

Complete Employee Labor details for Exception Resource
    [Arguments]    ${Name}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Labor Tab}
    Click Element    ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Wait Until Element Is Visible    //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']    10s
    Click Element    //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[6]
    Press Key    //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[6]//input[@type= 'text']    \\08
    Input Text    //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[6]//input[@type= 'text']    ${EAC_QTY}
    Click Element    ${Employee labor Save changes Link}
    Sleep    5s
    Run Keyword And Continue On Failure    Wait Until Page Contains Element    //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '&{ContractRate_dict}[${Name}]')]    10s
    Calculate & Verify Working Budget parameters for CR Exception Employee Labor    ${Name}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Basic Page Info Tab}
    #[Return]    ${CREX_QTY_List}    ${CREX_Cost_List}    ${CREX_Billing_List}

Complete RH Contractor Labor details for Exception Resource
    [Arguments]    ${Name}    ${Pay_rate}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Labor Tab}
    Click Element    ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Wait Until Element Is Visible    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']    10s
    Click Element    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]
    Press Key    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']    \\08
    Input Text    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']    ${Pay_rate}
    Click Element    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]
    Click Element    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]
    Press Key    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]//input[@type= 'text']    \\08
    Input Text    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]//input[@type= 'text']    ${EAC_QTY}
    Click Element    ${RHC Save changes}
    Sleep    5s
    Run Keyword And Continue On Failure    Wait Until Page Contains Element    //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '&{ContractRate_dict}[${Name}]')]    10s
    Calculate & Verify Working Budget parameters for CR Exception RH Contractor Labor    ${Name}    ${Pay_rate}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Basic Page Info Tab}
    #[Return]    ${CREX_QTY_List}    ${CREX_Cost_List}    ${CREX_Billing_List}

Complete Independent Contractor Labor details for Exception Resource
    [Arguments]    ${Name}    ${Pay_rate}    ${Currency}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Labor Tab}
    Click Element    ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Wait Until Element Is Visible    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']    10s
    Click Element    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]
    Press Key    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']    \\08
    Input Text    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']    ${Pay_rate}
    Click Element    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]
    Click Element    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]
    Press Key    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]//input[@type= 'text']    \\08
    Input Text    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]//input[@type= 'text']    ${Currency}
    Click Element    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]
    Click Element    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]
    Press Key    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]//input[@type= 'text']    \\08
    Input Text    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]//input[@type= 'text']    ${EAC_QTY}
    Click Element    ${IHC Save changes Link}
    Sleep    5s
    Run Keyword And Continue On Failure    Wait Until Page Contains Element    //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '&{ContractRate_dict}[${Name}]')]    10s
    Calculate & Verify Working Budget parameters for CR Exception IH Contractor Labor    ${Name}    ${Pay_rate}    ${Currency}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Basic Page Info Tab}
    #[Return]    ${CREX_QTY_List}    ${CREX_Cost_List}    ${CREX_Billing_List}

Select Contract Rate Exception Name
    [Arguments]    ${name}
    Click Element    ${sub-budget Contract Rate Name dropdown}
    Wait Until Element Is Visible    ${sub-budget Contract Rate Name Input}    10s
    Input Text    ${sub-budget Contract Rate Name Input}    ${name}
    Wait Until Element Is Visible    //table[@id= 'gridLookup_DDD_gv_DXMainTable']//td[text()= '${name}']
    Sleep    3s
    ${Resource_Type}=    Get Text    //table[@id= 'gridLookup_DDD_gv_DXMainTable']//td[text()= '${name}']/following-sibling::td[5]
    Click Element    //table[@id= 'gridLookup_DDD_gv_DXMainTable']//td[text()= '${name}']
    Sleep    3s
    [Return]    ${Resource_Type}

Select Contract rate on Sub-Budget
    [Arguments]    ${Contract_rate}
    Click Element    //tr[@id= 'GVContractRateExcRate_DXDataRow-1']/td[3]
    Sleep    2s
    Input Text    ${sub-budget Contract Rate Input}    ${Contract_rate}

Add MF/IBU Contract Rate Card Exception on sub-budget
    [Arguments]    ${Rate_List}    ${cur_rates}
    Wait Until Element Is Visible    ${sub-budget MF/IBU Contract Rate New Button}    10s
    ${Resource_dict}=    Get Resource Details Dict    ${Rate_List}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${MF_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Wait Until Element Is Visible    ${sub-budget MF/IBU Contract Rate New Button}    10s
        Click Element    ${sub-budget MF/IBU Contract Rate New Button}
        Enter Hourly MF/IBU Contract Rate Exception content on table    ${MF_table_data}    ${cur_rates}
    END
    Calculate total Contract Rate MF/IBU Exception Amount for all Exception Resources

Enter Hourly MF/IBU Contract Rate Exception content on table
    [Arguments]    ${MF_Exception_data}    ${cur_rates}
    Wait Until Element Is Visible    ${sub-budget MF/IBU Contract Rate Name Input}
    Input Text    ${sub-budget MF/IBU Contract Rate Name Input}    @{MF_Exception_data}[0]
    Click Element    //table[@id= 'gvResourceContractRate_DXStatus']
    Click Element    //tr[@id= 'gvResourceContractRate_DXDataRow-1']/td[3]
    Wait Until Element Is Visible    ${sub-budget MF/IBU Contract Rate Job Function Input}
    Input Text    ${sub-budget MF/IBU Contract Rate Job Function Input}    @{MF_Exception_data}[1]
    Click Element    //table[@id= 'gvResourceContractRate_DXStatus']
    Click Element    //tr[@id= 'gvResourceContractRate_DXDataRow-1']/td[4]
    Input Text    ${sub-budget MF/IBU Contract Rate Input}    @{MF_Exception_data}[2]
    Click Element    ${sub-budget MF/IBU Contract Rate Save Changes Link}
    Sleep    2s
    Wait Until Element Is Visible    //table[@id= 'gvResourceContractRate_DXMainTable']//td[text()= '@{MF_Exception_data}[0]']/following-sibling::td[3]
    ${currency}=    Get From Dictionary    ${budget_dict}    Contract Currency
    ${MF-Contract_Rate_Base_UI}=    Get Text    //table[@id= 'gvResourceContractRate_DXMainTable']//td[text()= '@{MF_Exception_data}[0]']/following-sibling::td[3]
    ${MF-Contract_Rate_Base}=    Evaluate    @{MF_Exception_data}[2]*&{cur_rates}[${currency}]
    ${MF-Contract_Rate_Base}=    Convert To Number    ${MF-Contract_Rate_Base}    2
    Run Keyword And Continue On Failure    Should Be Equal As Numbers    ${MF-Contract_Rate_Base_UI}    ${MF-Contract_Rate_Base}
    Set To Dictionary    ${ContractRate_dict}    @{MF_Exception_data}[1]    ${MF-Contract_Rate_Base}
    Complete Corresponding MF/ IBU Rate Card Exception Labor Resource    ${MF_Exception_data}
    #[Return]    ${MFEX_QTY_List}    ${MFEX_Cost_List}    ${MFEX_Billing_List}

Complete Corresponding MF/ IBU Rate Card Exception Labor Resource
    [Arguments]    ${MF_Exception_data}
    ${Resource_Type}=    Get Substring    @{MF_Exception_data}[0]    0    3
    Run Keyword If    '${Resource_Type}'=='IBU'    Complete Corresponding IBU Labor details for Exception Resource    @{MF_Exception_data}[0]    @{MF_Exception_data}[1]    @{MF_Exception_data}[3]    @{MF_Exception_data}[4]    @{MF_Exception_data}[5]
    ...    ELSE    Complete Corresponding MF Labor details for Exception Resource    @{MF_Exception_data}[0]    @{MF_Exception_data}[1]    @{MF_Exception_data}[3]    @{MF_Exception_data}[4]    @{MF_Exception_data}[5]

Complete Corresponding MF Labor details for Exception Resource
    [Arguments]    ${Name}    ${job}    ${Pay_Rate}    ${Currency}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Labor Tab}
    Click Element    ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Wait Until Page Contains Element    //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td[text()= '${job}']    10s
    Scroll Element Into View    //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td[text()= '${job}']
    Click Element    //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td[text()= '${job}']/following-sibling::td[2]
    Press Key    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[2]//input[@type= 'text']    \\08
    Input Text    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[2]//input[@type= 'text']    ${Pay_Rate}
    Click Element    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]
    Click Element    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]
    Press Key    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]//input[@type= 'text']    \\08
    Input Text    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]//input[@type= 'text']    ${Currency}
    Scroll Element Into View    ${MF Save changes Link}
    Click Element    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]
    Click Element    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]
    Press Key    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]//input[@type= 'text']    \\08
    Input Text    (//table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]//input[@type= 'text']    ${EAC_QTY}
    Click Element    ${MF Save changes Link}
    Sleep    5s
    Calculate & Verify Working Budget parameters for CR Exception MF Labor    ${Name}    ${job}    ${Pay_Rate}    ${Currency}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Basic Page Info Tab}
    #[Return]    ${MFEX_QTY_List}    ${MFEX_Cost_List}    ${MFEX_Billing_List}

Complete Corresponding IBU Labor details for Exception Resource
    [Arguments]    ${Name}    ${job}    ${Pay_Rate}    ${Currency}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Labor Tab}
    Click Element    ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Wait Until Page Contains Element    //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td[text()= '${job}']
    Scroll Element Into View    //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td[text()= '${job}']
    Click Element    //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td[text()= '${job}']/following-sibling::td[2]
    Press Key    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[2]//input[@type= 'text']    \\08
    Input Text    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[2]//input[@type= 'text']    ${Pay_Rate}
    Click Element    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]
    Click Element    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]
    Press Key    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]//input[@type= 'text']    \\08
    Input Text    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[3]//input[@type= 'text']    ${Currency}
    Scroll Element Into View    ${IBU Save changes Link}
    Click Element    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]
    Click Element    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]
    Press Key    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]//input[@type= 'text']    \\08
    Input Text    (//table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td)[2]/following-sibling::td[6]//input[@type= 'text']    ${EAC_QTY}
    Click Element    ${IBU Save changes Link}
    Sleep    5s
    Calculate & Verify Working Budget parameters for CR Exception IBU Labor    ${Name}    ${job}    ${Pay_Rate}    ${Currency}    ${EAC_QTY}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Basic Page Info Tab}

Get Project Department & OP UNIT
    ${dept}=    Get Element Attribute    //td[@id= 'DeptId_CC']//input[@type= 'text']    value
    ${opunit}=    Get Element Attribute    //td[@id= 'GridLookupPrimaryService_CC']//input[@type= 'text']    value
    ${opunit}=    Fetch From Left    ${opunit}    |
    ${dept}=    Get Substring    ${dept}    -5
    [Return]    ${dept}    ${opunit}

Add Labor & Expenses Details
    [Arguments]    ${data_dict}
    Wait until Element Is Visible    ${sub-budget Labor Tab}    30s
    Get Horizontal Position    ${sub-budget Currency Calculator Link}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Labor Tab}
    Sleep    5s
    #Click Element    ${sub-budget Labor Expand/Collapse Link}
    Minimize Budget Gauge
    Run Keyword If    '${data_dict["Employee Labor"]}'!=''    Add Employee Labor details on sub-budget    ${data_dict["Employee Labor"]}
    Run Keyword If    '${data_dict["RH Contractor Labor"]}'!=''    Add RH Contractor Labor details on sub-budget    ${data_dict["RH Contractor Labor"]}
    Run Keyword If    '${data_dict["IH Contractor Labor"]}'!=''    Add Independent Contractor Labor details on sub-budget    ${data_dict["IH Contractor Labor"]}
    Run Keyword If    '${data_dict["MF Labor"]}'!=''    Add Member Firm Labor Details on sub-budget    ${data_dict["MF Labor"]}
    Run Keyword If    '${data_dict["IBU Labor"]}'!=''    Add International BU Labor Details on sub-budget    ${data_dict["IBU Labor"]}
    #Run Keyword If    '${data_dict["Rate Card Type"]}'=='Hourly' and ('${data_dict["Volume Discount"]}'!='' or '${data_dict["Adjustments"]}'!='')    Add Volume & Adjustment Details    ${data_dict}
    Run Keyword If    '${data_dict["Contract Rate"]}'!='' or '${data_dict["Employee Labor"]}'!=''    Calculate & Verify Sub-Total Employee Labor
    Run Keyword If    '${data_dict["Contract Rate"]}'!='' or '${data_dict["RH Contractor Labor"]}'!=''    Calculate & Verify Sub-Total RH Contractor Labor
    Run Keyword If    '${data_dict["Contract Rate"]}'!='' or '${data_dict["IH Contractor Labor"]}'!=''    Calculate & Verify Sub-Total IH Contractor Labor
    Run Keyword If    '${data_dict["MF/IBU Contract Rate"]}'!='' or '${data_dict["MF Labor"]}'!=''    Calculate & Verify Sub-Total Member Firm Labor
    Run Keyword If    '${data_dict["MF/IBU Contract Rate"]}'!='' or '${data_dict["IBU Labor"]}'!=''    Calculate & Verify Sub-Total International BU Labor
    Calculate And Verify Net Professional BU/IBU Services on Labor Tab
    Scroll Element Into View    ${sub-budget Expenses Tab}
    Click Element    ${sub-budget Expenses Tab}
    Run Keyword If    '${data_dict["EMP Expenses"]}'!=''    Add Employee Expense details on sub-budget    ${data_dict["EMP Expenses"]}
    Run Keyword If    '${data_dict["RHC Expenses"]}'!=''    Add RH Contractor Expense details on sub-budget    ${data_dict["RHC Expenses"]}
    #Run Keyword If    '${data_dict["IHC Expenses"]}'!=''    Add Independent Contractor Expense details on sub-budget    ${data_dict["IHC Expenses"]}
    Run Keyword If    '${data_dict["MF Expenses"]}'!=''    Add Member Firm Expense details on sub-budget    ${data_dict["MF Expenses"]}
    Run Keyword If    '${data_dict["IBU Expenses"]}'!=''    Add International BU Expense details on sub-budget    ${data_dict["IBU Expenses"]}
    Calculate And verify Global BU/IBU Expenses on sub-budget

Add Volume & Adjustment Details
    [Arguments]    ${data_dict}
    Scroll Element Into View    ${Volume Discount Input}
    #Click Element    ${Volume Discount Input}
    #Sleep    5s
    Clear Element Text    ${Volume Discount Input}
    Sleep    3s
    Input Text    ${Volume Discount Input}    ${data_dict["Volume Discount"]}
    &{iBudget_Calculation}[VolumeDiscount]=    Set Variable    ${data_dict["Volume Discount"]}
    Run Keyword If    '${data_dict["Adjustments"]}'!=''    Input Text    ${Adjustments Input}    ${data_dict["Adjustments"]}
    &{iBudget_Calculation}[BUPlannedInvestments]=    Run Keyword If    '${data_dict["Adjustments"]}'!=''    Set Variable    ${data_dict["Adjustments"]}
    Click Element    ${sub-budget Save labor Button}
    Sleep    5s
    &{iBudget_Calculation}[BUProfServices_Dis&Adj_EACBillings]=    Evaluate    &{iBudget_Calculation}[VolumeDiscount]+&{iBudget_Calculation}[BUPlannedInvestments]

Minimize Budget Gauge
    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${pop-up condition path}    10s
    ${Status}=    Run Keyword And Return Status    Page Should Contain Element    ${pop-up condition path}
    Run Keyword If    '${Status}'=='True'    Click Element    ${pop-up minimize btn}

Create iBudget Output Dictionary And Initialize it
    ${iBudget_Calculation}=    Create Dictionary
    ${Labor_dict}=    Create Dictionary
    Set To Dictionary    ${iBudget_Calculation}    EmpLabor_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    EmpLabor_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    EmpLabor_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    EmpLabor_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    RHCLabor_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    RHCLabor_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    RHCLabor_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    RHCLabor_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    IHCLabor_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    IHCLabor_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    IHCLabor_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    IHCLabor_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    MFLabor_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    MFLabor_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    MFLabor_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    MFLabor_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    IBULabor_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    IBULabor_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    IBULabor_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    IBULabor_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    BUProfServices_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    BUProfServices_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    BUProfServices_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    BUProfServices_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    VolumeDiscount    0.00
    Set To Dictionary    ${iBudget_Calculation}    BUPlannedInvestments    0
    Set To Dictionary    ${iBudget_Calculation}    BUProfServices_Dis&Adj_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    Non-Billable_Hours    0.00
    Set To Dictionary    ${iBudget_Calculation}    AdjNetProfFees_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    AdjNetProfFees_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    AdjNetProfFees_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    AdjNetProfFees_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    IBUPlannedInvestments    0
    Set To Dictionary    ${iBudget_Calculation}    IBUAdjNetProfFees_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    IBUAdjNetProfFees_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    IBUAdjNetProfFees_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    GlobalNetProfFees_EMPQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    GlobalNetProfFees_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    GlobalNetProfFees_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    GlobalNetProfFees_CM%    0
    Set To Dictionary    ${iBudget_Calculation}    EmpExpenses_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    EmpExpenses_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    RHCExpenses_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    RHCExpenses_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    IHCExpenses_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    IHCExpenses_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    MFExpenses_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    MFExpenses_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    IBUExpenses_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    IBUExpenses_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    TotalBUExpenses_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    TotalBUExpenses_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    GlobalExpenses_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    GlobalExpenses_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    OtherFees&Charges_BudgetCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    OtherFees&Charges_BudgetBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    TotalNetfees&Expenses_EACCost    0.00
    Set To Dictionary    ${iBudget_Calculation}    TotalNetfees&Expenses_EACBillings    0.00
    Set To Dictionary    ${iBudget_Calculation}    TotalNetfees&Expenses_CM%    0.00
    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_Services_EACQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_Services_EACBilling    0.00
    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_VolumeDiscount    0.00
    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_PlannedInvestment    0.00
    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_Discount&Adjustments    0.00
    Set To Dictionary    ${iBudget_Calculation}    AdjNet-Unit/Val_EACQTY    0.00
    Set To Dictionary    ${iBudget_Calculation}    AdjNet-Unit/Val_EACBilling    0.00
    Set To Dictionary    ${iBudget_Calculation}    AdjNet-Unit/Val_EACBilling_ContractCurrency    0.00
    Set Global Variable    ${iBudget_Calculation}
    Set To Dictionary    ${Labor_dict}    Emp_CR_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    Emp_CR_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    Emp_CR_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    RH_CR_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    RH_CR_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    RH_CR_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    IH_CR_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    IH_CR_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    IH_CR_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    Emp_Non_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    Emp_Non_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    Emp_Non_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    RHC_Non_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    RHC_Non_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    RHC_Non_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    IHC_Non_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    IHC_Non_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    IHC_Non_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    MF_CR_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    MF_CR_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    MF_CR_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    IBU_CR_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    IBU_CR_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    IBU_CR_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    MF_Non_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    MF_Non_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    MF_Non_Exception_Billing    0.00
    Set To Dictionary    ${Labor_dict}    IBU_Non_Exception_QTY    0.00
    Set To Dictionary    ${Labor_dict}    IBU_Non_Exception_Cost    0.00
    Set To Dictionary    ${Labor_dict}    IBU_Non_Exception_Billing    0.00
    Set Global Variable    ${Labor_dict}

Get List of Data For labor/Expense Table
    [Arguments]    ${num}    ${content}
    @{L1}    Create List
    @{List}    Create List
    Log    ${content}
    ${initial}=    Evaluate    ${num}*0
    ${cnt}=    Get length    ${content}
    Log    ${cnt}
    ${Number}    Evaluate    ${cnt}/${num}
    ${end}=    Set Variable    ${Number}
    FOR    ${i}    IN RANGE    0    ${num}
        ${L1}=    Get Slice From List    ${content}    ${initial}    ${Number}
        ${initial}=    Set Variable    ${Number}
        ${Number}=    Evaluate    ${Number}+${end}
        Append To List    ${List}    ${L1}
    END
    [Return]    ${List}

Add Employee Labor details on sub-budget
    [Arguments]    ${Employee Labor}
    Wait Until Element Is Visible    ${Employee Labor Header}    30s
    ${Resource_dict}=    Get Resource Details Dict    ${Employee Labor}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${labor_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Click Element    ${Employee Labor New Button}
        Click Element    ${Employee Labor Header}
        Enter Employee Labor content on table    ${labor_table_data}
        Click Element    ${Employee labor Save changes Link}
        Sleep    5s
        Minimize Budget Gauge
        ${Emp_QTY_list}    ${Emp_Costs_list}    ${Emp_Billings_list}    ${NonBillable_Hours_list}    Calculate & Verify Working Budget parameters for Employee Labor    ${labor_table_data}
    END
    Calculate total Non Exception Amount for Employee Labor Resources    ${Emp_QTY_list}    ${Emp_Costs_list}    ${Emp_Billings_list}
    Set Non-Billable Hours in Output Dictionary    ${NonBillable_Hours_list}

Enter Employee Labor content on table
    [Arguments]    ${labor_details}
    FOR    ${i}    IN RANGE    2    10
        ${j}=    Evaluate    ${i}-1
        ${index}=    Set Variable If    ${i}>8    ${j}    ${i}
        ${k}=    Evaluate    ${i}-2
        ${k}=    Set Variable If    ${k}>4    5    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'GridView_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'GridView_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'GridView_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'GridView_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'GridView_DXEditor${i}_I']    @{labor_details}[${k}]
        ...    ELSE    Update Employee Labor Field    ${i}    @{labor_details}[${k}]
        Click Element    ${Employee Labor Header}
    END

Update Employee Labor Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'GridView_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'GridView_DXEditor${index}_I']    ${value}

Add RH Contractor Labor details on sub-budget
    [Arguments]    ${RHC Labor}
    Wait Until Element Is Visible    ${RHC Header}    30s
    ${Status}=    Run Keyword And Return Status    Element Should Be Visible    //b[text()= ' RH Contractor Labor']/a[text()= '+']
    Run Keyword If    '${Status}'=='True'    Click Element    //b[text()= ' RH Contractor Labor']/a[text()= '+']
    ${Resource_dict}=    Get Resource Details Dict    ${RHC Labor}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${rhc_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Click Element    ${RHC New Button}
        Click Element    ${RHC Footer}
        Enter RHC Labor content on table    ${rhc_table_data}
        Click Element    ${RHC Save changes Link}
        Sleep    5s
        Minimize Budget Gauge
        ${RHCLabor_EAC_QTY}    ${RHCLabor_Costs}    ${RHCLabor_Billings}    Calculate & Verify Working Budget parameters for RH Contractor Labor    ${rhc_table_data}
    END
    Calculate total Non Exception Amount for RHC Labor Resources    ${RHCLabor_EAC_QTY}    ${RHCLabor_Costs}    ${RHCLabor_Billings}

Enter RHC Labor content on table
    [Arguments]    ${rhc_details}
    FOR    ${i}    IN RANGE    1    10
        ${j}=    Evaluate    ${i}+1
        ${index}=    Set Variable If    ${j}>8    ${i}    ${j}
        ${k}=    Evaluate    ${i}-1
        ${k}=    Set Variable If    ${k}>3    4    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'GridView1_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'GridView1_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'GridView1_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'GridView1_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'GridView1_DXEditor${i}_I']    @{rhc_details}[${k}]
        ...    ELSE    Update RH Contractor Labor Field    ${i}    @{rhc_details}[${k}]
        Click Element    //tr[@id= 'GridView1_DXDataRow-1']/td[13]
    END

Update RH Contractor Labor Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'GridView1_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'GridView1_DXEditor${index}_I']    ${value}

Add Independent Contractor Labor details on sub-budget
    [Arguments]    ${IHC Labor}
    Wait Until Element Is Visible    ${IHC Header}    30s
    ${Status}=    Run Keyword And Return Status    Element Should Be Visible    //b[text()= ' Independent Contractor Labor']/a[text()= '+']
    Run Keyword If    '${Status}'=='True'    Click Element    //b[text()= ' Independent Contractor Labor']/a[text()= '+']
    ${Resource_dict}=    Get Resource Details Dict    ${IHC Labor}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${ihc_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Scroll Element Into View    ${IHC New Button}
        Click Element    ${IHC New Button}
        Click Element    ${IHC Footer}
        Enter IHC Labor content on table    ${ihc_table_data}
        Click Element    ${IHC Save changes Link}
        Sleep    5s
        Minimize Budget Gauge
        ${IHCLabor_EAC_QTY}    ${IHCLabor_Costs}    ${IHCLabor_Billings}    Calculate & Verify Working Budget parameters for IH Contractor Labor    ${ihc_table_data}
    END
    Calculate total Non Exception Amount for IHC Labor Resources    ${IHCLabor_EAC_QTY}    ${IHCLabor_Costs}    ${IHCLabor_Billings}

Enter IHC Labor content on table
    [Arguments]    ${ihc_details}
    FOR    ${i}    IN RANGE    1    10
        ${j}=    Evaluate    ${i}+1
        ${index}=    Set Variable If    ${j}>8    ${i}    ${j}
        ${l}=    Evaluate    ${index}+1
        ${l}=    Set Variable If    ${l}>13    ${i}    ${l}
        ${k}=    Evaluate    ${i}-1
        ${n}=    Evaluate    ${k}-1
        ${k}=    Set Variable If    ${k}>1 and ${k}<5    ${n}    ${k}
        ${k}=    Set Variable If    ${k}>5    4    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'gvIndenpendentContrLabor_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'gvIndenpendentContrLabor_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'gvIndenpendentContrLabor_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'gvIndenpendentContrLabor_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'gvIndenpendentContrLabor_DXEditor${i}_I']    @{ihc_details}[${k}]
        ...    ELSE    Update IH Contractor Labor Field    ${i}    @{ihc_details}[${k}]
        Click Element    //tr[@id= 'gvIndenpendentContrLabor_DXDataRow-1']/td[${l}]
    END

Update IH Contractor Labor Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'gvIndenpendentContrLabor_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'gvIndenpendentContrLabor_DXEditor${index}_I']    ${value}

Add Member Firm Labor Details on sub-budget
    [Arguments]    ${MF Labor}
    Wait Until Element Is Visible    ${MF Header}    30s
    ${Status}=    Run Keyword And Return Status    Element Should Be Visible    //b[text()= ' Member Firm Labor']/a[text()= '+']
    Run Keyword If    '${Status}'=='True'    Click Element    //b[text()= ' Member Firm Labor']/a[text()= '+']
    ${Resource_dict}=    Get Resource Details Dict    ${MF Labor}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${mf_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Scroll Element Into View    ${MF New Button}
        Click Element    ${MF New Button}
        Click Element    ${MF Footer}
        Enter MF Labor content on table    ${mf_table_data}
        Click Element    ${MF Save changes Link}
        Sleep    5s
        Minimize Budget Gauge
        ${MF_QTY_list}    ${MF_Costs_list}    ${MF_Billings_list}    Calculate & Verify Working Budget parameters for Member Firm Labor    ${mf_table_data}
    END
    Calculate total Non Exception Amount for Member Firm Labor Resources    ${MF_QTY_list}    ${MF_Costs_list}    ${MF_Billings_list}

Enter MF Labor content on table
    [Arguments]    ${mf_details}
    FOR    ${i}    IN RANGE    1    10
        ${j}=    Evaluate    ${i}+1
        ${index}=    Set Variable If    ${j}>8    ${i}    ${j}
        ${k}=    Evaluate    ${i}-1
        ${n}=    Evaluate    ${k}-1
        ${k}=    Set Variable If    ${k}>1 and ${k}<5    ${n}    ${k}
        ${k}=    Set Variable If    ${k}>5    4    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'gvMemberFirmLabor_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'gvMemberFirmLabor_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'gvMemberFirmLabor_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'gvMemberFirmLabor_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'gvMemberFirmLabor_DXEditor${i}_I']    @{mf_details}[${k}]
        ...    ELSE    Update Member Firm Labor Field    ${i}    @{mf_details}[${k}]
        Click Element    ${MF Footer}
    END

Update Member Firm Labor Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'gvMemberFirmLabor_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'gvMemberFirmLabor_DXEditor${index}_I']    ${value}

Add International BU Labor Details on sub-budget
    [Arguments]    ${IBU Labor}
    Wait Until Element Is Visible    ${IBU Header}    30s
    ${Status}=    Run Keyword And Return Status    Element Should Be Visible    //b[text()= ' International BU']/a[text()= '+']
    Run Keyword If    '${Status}'=='True'    Click Element    //b[text()= ' International BU']/a[text()= '+']
    ${Resource_dict}=    Get Resource Details Dict    ${IBU Labor}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${ibu_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Scroll Element Into View    ${IBU New Button}
        Click Element    ${IBU New Button}
        Click Element    ${IBU Footer}
        Enter IBU Labor content on table    ${ibu_table_data}
        Click Element    ${IBU Save changes Link}
        Sleep    5s
        Minimize Budget Gauge
        ${IBULabor_EAC_QTY}    ${IBULabor_Costs}    ${IBULabor_Billings}    Calculate & Verify Working Budget parameters for IBU Labor    ${ibu_table_data}
    END
    Calculate total Non Exception Amount for IBU Labor Resources    ${IBULabor_EAC_QTY}    ${IBULabor_Costs}    ${IBULabor_Billings}

Enter IBU Labor content on table
    [Arguments]    ${ibu_details}
    FOR    ${i}    IN RANGE    1    10
        ${j}=    Evaluate    ${i}+1
        ${index}=    Set Variable If    ${j}>8    ${i}    ${j}
        ${k}=    Evaluate    ${i}-1
        ${n}=    Evaluate    ${k}-1
        ${k}=    Set Variable If    ${k}>1 and ${k}<5    ${n}    ${k}
        ${k}=    Set Variable If    ${k}>5    4    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'gvInternationalBU_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'gvInternationalBU_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'gvInternationalBU_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'gvInternationalBU_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'gvInternationalBU_DXEditor${i}_I']    @{ibu_details}[${k}]
        ...    ELSE    Update International BU Labor Field    ${i}    @{ibu_details}[${k}]
        Click Element    ${IBU Footer}
    END

Update International BU Labor Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'gvInternationalBU_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'gvInternationalBU_DXEditor${index}_I']    ${value}

Add Employee Expense details on sub-budget
    [Arguments]    ${EMP Expense}
    Wait Until Element Is Visible    ${sub-budget Employee Expense New Button}    30s
    ${Resource_dict}=    Get Resource Details Dict    ${EMP Expense}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${empex_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Enter EMP Expense content on table    ${empex_table_data}
        Click Element    ${Employee Expense Save changes Link}
        Sleep    5s
        Append to List    ${EmpExp_BudgetCost}    @{empex_table_data}[5]
        Append to List    ${EmpExp_BudgetBillings}    @{empex_table_data}[6]
    END
    ${Cost}    ${Billings}    Calculate & Verify Sub-Total of Expenses Tab    ${EmpExp_BudgetCost}    ${EmpExp_BudgetBillings}    EmpExpGridView_DXFooterRow
    Set To Dictionary    ${iBudget_Calculation}    EmpExpenses_BudgetCost    ${Cost}
    Set To Dictionary    ${iBudget_Calculation}    EmpExpenses_BudgetBillings    ${Billings}

Enter EMP Expense content on table
    [Arguments]    ${empex_details}
    Click Element    ${sub-budget Employee Expense New Button}
    Wait Until Element Is Visible    ${Employee Expense Resource Name}
    Input Text    ${Employee Expense Resource Name}    @{empex_details}[0]
    Wait Until Element Is Visible    //table[@id= 'gridLookupResourceName_DDD_gv_DXMainTable']//td[text()= '@{empex_details}[0]']    10s
    Click Element    //table[@id= 'gridLookupResourceName_DDD_gv_DXMainTable']//td[text()= '@{empex_details}[0]']
    Sleep    2s
    Click Element    //tr[@id= 'EmpExpGridView_DXDataRow-1']/td[9]
    FOR    ${i}    IN RANGE    4    11
        ${j}=    Evaluate    ${i}-1
        ${l}=    Evaluate    ${j}-1
        ${index}=    Set Variable If    ${j}>6    ${l}    ${j}
        ${k}=    Evaluate    ${i}-3
        ${n}=    Evaluate    ${k}-1
        ${k}=    Set Variable If    ${k}>4    ${n}    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'EmpExpGridView_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'EmpExpGridView_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'EmpExpGridView_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'EmpExpGridView_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'EmpExpGridView_DXEditor${i}_I']    @{empex_details}[${k}]
        ...    ELSE    Update Employee Expenses Field    ${i}    @{empex_details}[${k}]
        Click Element    ${Employee Expense Footer}
    END

Update Employee Expenses Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'EmpExpGridView_DXEditor${index}_I']    \\08
    Sleep    2s
    Press Key    //input[@id= 'EmpExpGridView_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'EmpExpGridView_DXEditor${index}_I']    ${value}

Add RH Contractor Expense details on sub-budget
    [Arguments]    ${RHC Expense}
    Wait Until Element Is Visible    ${sub-budget RHC Expense New Button}    30s
    Scroll Element Into View    ${sub-budget RHC Expense New Button}
    ${Resource_dict}=    Get Resource Details Dict    ${RHC Expense}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${rhcex_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Enter RHC Expense content on table    ${rhcex_table_data}
        Click Element    ${RHC Expense Save changes Link}
        Sleep    5s
        Append to List    ${RHCExp_BudgetCost}    @{rhcex_table_data}[6]
        Append to List    ${RHCExp_BudgetBillings}    @{rhcex_table_data}[7]
    END
    ${Cost}    ${Billings}    Calculate & Verify Sub-Total of Expenses Tab    ${RHCExp_BudgetCost}    ${RHCExp_BudgetBillings}    RhExpGridView_DXFooterRow
    Set To Dictionary    ${iBudget_Calculation}    RHCExpenses_BudgetCost    ${Cost}
    Set To Dictionary    ${iBudget_Calculation}    RHCExpenses_BudgetBillings    ${Billings}

Enter RHC Expense content on table
    [Arguments]    ${rhcex_details}
    Click Element    ${sub-budget RHC Expense New Button}
    Wait Until Element Is Visible    ${RHC Expense Header}
    Input Text    ${RHC Expense Resource Name}    @{rhcex_details}[0]
    Wait Until Element Is Visible    //table[@id= 'gridLookupResourceNameRHC_DDD_gv_DXMainTable']//td[text()= '@{rhcex_details}[0]']    10s
    Sleep    3s
    Click Element    //table[@id= 'gridLookupResourceNameRHC_DDD_gv_DXMainTable']//td[text()= '@{rhcex_details}[0]']
    Sleep    2s
    Click Element    //tr[@id= 'RhExpGridView_DXDataRow-1']/td[9]
    FOR    ${i}    IN RANGE    4    11
        ${j}=    Evaluate    ${i}-1
        ${l}=    Evaluate    ${j}-1
        ${index}=    Set Variable If    ${j}>6    ${l}    ${j}
        ${k}=    Evaluate    ${i}-3
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'RhExpGridView_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'RhExpGridView_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'RhExpGridView_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'RhExpGridView_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'RhExpGridView_DXEditor${i}_I']    @{rhcex_details}[${k}]
        ...    ELSE    Update RHC Expenses Field    ${i}    @{rhcex_details}[${k}]
        Click Element    ${RHC Expense Footer}
    END

Update RHC Expenses Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'RhExpGridView_DXEditor${index}_I']    \\08
    Sleep    2s
    Press Key    //input[@id= 'RhExpGridView_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'RhExpGridView_DXEditor${index}_I']    ${value}

Add Independent Contractor Expense details on sub-budget
    [Arguments]    ${IHC Expense}
    Wait Until Element Is Visible    ${sub-budget IHC Expense New Button}    30s
    ${Resource_dict}=    Get Resource Details Dict    ${IHC Expense}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${ihcex_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Enter IHC Expense content on table    ${ihcex_table_data}
        Click Element    ${IHC Expense Save changes Link}
        Sleep    5s
        Append to List    ${IHCExp_BudgetCost}    @{ihcex_table_data}[6]
        Append to List    ${IHCExp_BudgetBillings}    @{ihcex_table_data}[7]
    END
    ${Cost}    ${Billings}    Calculate & Verify Sub-Total of Expenses Tab    ${IHCExp_BudgetCost}    ${IHCExp_BudgetBillings}    IndExpGridView_DXFooterRow
    Set To Dictionary    ${iBudget_Calculation}    IHCExpenses_BudgetCost    ${Cost}
    Set To Dictionary    ${iBudget_Calculation}    IHCExpenses_BudgetBillings    ${Billings}

Enter IHC Expense content on table
    [Arguments]    ${ihcex_details}
    Click Element    ${sub-budget IHC Expense New Button}
    Wait Until Element Is Visible    ${IHC Expense Header}
    Input Text    ${IHC Expense Resource Name}    @{ihcex_details}[0]
    Wait Until Element Is Visible    //table[@id= 'gridLookupResourceNameRHC_DDD_gv_DXMainTable']//td[text()= '@{ihcex_details}[0]']    10s
    Click Element    //table[@id= 'gridLookupResourceNameIHC_DDD_gv_DXMainTable']//td[text()= '@{ihcex_details}[0]']
    Sleep    2s
    Click Element    //tr[@id= 'RhExpGridView_DXDataRow-1']/td[9]
    FOR    ${i}    IN RANGE    4    11
        ${j}=    Evaluate    ${i}-1
        ${l}=    Evaluate    ${j}-1
        ${index}=    Set Variable If    ${j}>6    ${l}    ${j}
        ${k}=    Evaluate    ${i}-3
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'IndExpGridView_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'IndExpGridView_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'IndExpGridView_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'IndExpGridView_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'IndExpGridView_DXEditor${i}_I']    @{ihcex_details}[${k}]
        ...    ELSE    Update IHC Expenses Field    ${i}    @{ihcex_details}[${k}]
        Click Element    ${IHC Expense Footer}
    END

Update IHC Expenses Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'IndExpGridView_DXEditor${index}_I']    \\08
    Sleep    2s
    Press Key    //input[@id= 'IndExpGridView_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'IndExpGridView_DXEditor${index}_I']    ${value}

Add Member Firm Expense details on sub-budget
    [Arguments]    ${MF Expense}
    Wait Until Element Is Visible    ${sub-budget MF Expense New Button}    30s
    Scroll Element Into View    ${sub-budget MF Expense New Button}
    ${Resource_dict}=    Get Resource Details Dict    ${MF Expense}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${mfex_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Enter MF Expense content on table    ${mfex_table_data}
        Click Element    ${MF Expense Save changes Link}
        Sleep    5s
        Append to List    ${MFExp_BudgetCost}    @{mfex_table_data}[3]
        Append to List    ${MFExp_BudgetBillings}    @{mfex_table_data}[4]
    END
    ${Cost}    ${Billings}    Calculate & Verify Sub-Total of Expenses Tab    ${MFExp_BudgetCost}    ${MFExp_BudgetBillings}    MemExpGridView_DXFooterRow
    Set To Dictionary    ${iBudget_Calculation}    MFExpenses_BudgetCost    ${Cost}
    Set To Dictionary    ${iBudget_Calculation}    MFExpenses_BudgetBillings    ${Billings}

Enter MF Expense content on table
    [Arguments]    ${mfex_details}
    Click Element    ${sub-budget MF Expense New Button}
    Wait Until Element Is Visible    ${MF Expense Header}
    Sleep    2s
    Click Element    ${MF Expense Footer}
    FOR    ${i}    IN RANGE    2    10
        ${j}=    Evaluate    ${i}-1
        ${index}=    Set Variable If    ${i}>6    ${j}    ${i}
        ${k}=    Evaluate    ${i}-2
        ${n}=    Evaluate    ${k}-2
        ${k}=    Set Variable If    ${k}>1 and ${k}<5    ${n}    ${k}
        ${o}=    Evaluate    ${n}-1
        ${k}=    Set Variable If    ${k}>5    ${o}    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'MemExpGridView_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'MemExpGridView_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'MemExpGridView_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'MemExpGridView_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'MemExpGridView_DXEditor${i}_I']    @{mfex_details}[${k}]
        ...    ELSE    Update MF Expenses Field    ${i}    @{mfex_details}[${k}]
        Click Element    ${MF Expense Footer}
    END

Update MF Expenses Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'MemExpGridView_DXEditor${index}_I']    \\08
    Sleep    2s
    Press Key    //input[@id= 'MemExpGridView_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'MemExpGridView_DXEditor${index}_I']    ${value}

Add International BU Expense details on sub-budget
    [Arguments]    ${IBU Expense}
    Wait Until Element Is Visible    ${sub-budget IBU Expense New Button}    30s
    Scroll Element Into View    ${sub-budget IBU Expense New Button}
    ${Resource_dict}=    Get Resource Details Dict    ${IBU Expense}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${ibuex_table_data}=    Split String    &{Resource_dict}[${Key}]    ;
        Enter IBU Expense content on table    ${ibuex_table_data}
        Click Element    ${IBU Expense Save changes Link}
        Sleep    5s
        Append to List    ${IBUExp_BudgetCost}    @{ibuex_table_data}[3]
        Append to List    ${IBUExp_BudgetBillings}    @{ibuex_table_data}[4]
    END
    ${Cost}    ${Billings}    Calculate & Verify Sub-Total of Expenses Tab    ${IBUExp_BudgetCost}    ${IBUExp_BudgetBillings}    IntGridView_DXFooterRow
    Set To Dictionary    ${iBudget_Calculation}    IBUExpenses_BudgetCost    ${Cost}
    Set To Dictionary    ${iBudget_Calculation}    IBUExpenses_BudgetBillings    ${Billings}

Enter IBU Expense content on table
    [Arguments]    ${ibuex_details}
    Scroll Element Into View    ${sub-budget IBU Expense New Button}
    Click Element    ${sub-budget IBU Expense New Button}
    Wait Until Element Is Visible    ${IBU Expense Header}
    Sleep    2s
    Minimize Budget Gauge
    Click Element    ${IBU Expense Footer}
    FOR    ${i}    IN RANGE    2    10
        ${j}=    Evaluate    ${i}-1
        ${index}=    Set Variable If    ${i}>6    ${j}    ${i}
        ${k}=    Evaluate    ${i}-2
        ${n}=    Evaluate    ${k}-2
        ${k}=    Set Variable If    ${k}>1 and ${k}<5    ${n}    ${k}
        ${o}=    Evaluate    ${n}-1
        ${k}=    Set Variable If    ${k}>5    ${o}    ${k}
        ${Editable_Field}=    Run Keyword And Return Status    Page Should Contain Element    //input[@id= 'IntGridView_DXEditor${i}_I']
        ${Text_Available}=    Run Keyword And Return Status    Page Should Contain Element    //tr[@id= 'IntGridView_DXDataRow-1']/td[${index}]/div[1]
        ${Text}=    Run Keyword If    '${Text_Available}'=='True'    Get Text    //tr[@id= 'IntGridView_DXDataRow-1']/td[${index}]/div[1]
        Log    ${Text}
        Click Element    //tr[@id= 'IntGridView_DXDataRow-1']/td[${index}]
        Run Keyword If    '${Editable_Field}'=='False'    Log    There is no input Field at this Box.
        ...    ELSE IF    '${Editable_Field}'=='True' and ('${Text}'=='' or '${Text}'=='None')    Input Text    //input[@id= 'IntGridView_DXEditor${i}_I']    @{ibuex_details}[${k}]
        ...    ELSE    Update IBU Expenses Field    ${i}    @{ibuex_details}[${k}]
        Click Element    ${MF Expense Footer}
    END

Update IBU Expenses Field
    [Arguments]    ${index}    ${value}
    Press Key    //input[@id= 'IntGridView_DXEditor${index}_I']    \\08
    Sleep    2s
    Press Key    //input[@id= 'IntGridView_DXEditor${index}_I']    \\08
    Input Text    //input[@id= 'IntGridView_DXEditor${index}_I']    ${value}

Get Other Fees Data
    [Arguments]    ${data}
    @{ofc_resouces}=    Split String    ${data}    ;
    ${OFC_dict}=    Create Dictionary
    FOR    ${i}    IN    @{ofc_resouces}
        ${data}=    Get Dictionary Data From CSV in Lateral Format    ${ibudget resource data}    ${i}
        Log    ${data}
        Set To Dictionary    ${OFC_dict}    ${i}    ${data}
    END
    [Return]    ${OFC_dict}

Add Other fees And Charges on sub-Budget
    [Arguments]    ${data_dict}
    Scroll Element Into View    ${sub-budget Other Fees Tab}
    Click Element    ${sub-budget Other Fees Tab}
    Wait Until Element Is Visible    ${Other Fees New Button}    30s
    ${OFC_dict}=    Get Other Fees Data    ${data_dict["OFC"]}
    ${Keys}=    Get Dictionary Keys    ${OFC_dict}
    FOR    ${item}    IN    @{Keys}
        ${ofees_table_data}=    Get From Dictionary    ${OFC_dict}    ${item}
        Click Element    ${Other Fees New Button}
        Enter Other Fees Details in the Table    ${ofees_table_data}
        Click Element    ${Other Fees Save button}
        Sleep    5s
        Run Keyword If    '${ofees_table_data["Budget Cost"]}'== '${EMPTY}'    Set To Dictionary    ${ofees_table_data}    Budget Cost    0.00
        Run Keyword If    '${ofees_table_data["Budget Billings"]}'== '${EMPTY}'    Set To Dictionary    ${ofees_table_data}    Budget Billings    0.00
        Append to List    ${OtherFeesEACCost}    ${ofees_table_data["Budget Cost"]}
        Append to List    ${OtherFeesEACBillings}    ${ofees_table_data["Budget Billings"]}
    END
    Log    ${OtherFeesEACCost}
    Calculate & Verify Sub-Total of Other Fees Tab    ${OtherFeesEACCost}    ${OtherFeesEACBillings}

Enter Other Fees Details in the Table
    [Arguments]    ${data_dict}
    Wait Until Element Is Visible    ${Other Fees Type Input Box}    15s
    Input Text    ${Other Fees Type Input Box}    ${data_dict["Resource Name"]}
    Run Keyword If    '${data_dict["Budget Cost"]}'!=''    Clear Element Text    ${Other Fees EAC Cost Input Box}
    Run Keyword If    '${data_dict["Budget Cost"]}'!=''    Input Text    ${Other Fees EAC Cost Input Box}    ${data_dict["Budget Cost"]}
    Run Keyword If    '${data_dict["Budget Billings"]}'!=''    Clear Element Text    ${Other Fees EAC Billings Input Box}
    Run Keyword If    '${data_dict["Budget Billings"]}'!=''    Input Text    ${Other Fees EAC Billings Input Box}    ${data_dict["Budget Billings"]}

Validate Consolidated Budget Tab And Calculate Total Net Fees
    Scroll Element Into View    ${sub-budget Consolidated budget Tab}
    Click Element    ${sub-budget Consolidated budget Tab}
    Wait Until Element Is Visible    ${Consolidated Budget Header}
    Verify Calculated Net Labor/Expenses Values on Consolidated Tab
    Run Keyword If    '${budget_dict["Rate Card Type"]}'=='Unit/Value-Based'    Verify Calculated Unit-Based Wizard on Consolidated Tab
    Calculate And Verify Total Net Fees & Expenses QTC

Sub-Budget activation Workflow
    [Arguments]    ${data_dict}
    log    ${data_dict["Sub-Budget Activation Status"]}
    Run Keyword And Return If    '${data_dict["Sub-Budget Activation Status"]}'=='Draft'    Draft Sub-Budget State    ${data_dict["Sub-Budget Activation Status"]}
    Run Keyword And Return If    '${data_dict["Sub-Budget Activation Status"]}'=='EM Submitted'    EM Submitted    ${data_dict["Sub-Budget Activation Status"]}
    Run Keyword And Return If    '${data_dict["FSC Workflow Action"]}'=='FSC Returned - Update Budget'    FSC Returned - Update Budget    ${data_dict["FSC Workflow Action"]}    ${budget_dict["FSC Returned Reason"]}
    Run Keyword And Return If    '${data_dict["FSC Workflow Action"]}'=='FSC Returned - Update Information'    FSC Returned - Update Information    ${data_dict["FSC Workflow Action"]}
    Run Keyword And Return If    '${data_dict["FSC Workflow Action"]}'=='FSC On Hold'    FSC On Hold    ${data_dict["FSC Workflow Action"]}
    Run Keyword And Return If    '${data_dict["Sub-Budget Activation Status"]}'=='Approved'    FSC-Approved    ${data_dict["Sub-Budget Activation Status"]}
    Run Keyword And Return If    '${data_dict["EMD Workflow Action"]}'=='EMD Approved'    EMD Approved    ${data_dict["EMD Workflow Action"]}
    Run Keyword And Return If    '${data_dict["EMD Workflow Action"]}'=='EMD Returned - Update Budget'    EMD Returned - Update Budget    ${data_dict["EMD Workflow Action"]}
    Run Keyword And Return If    '${data_dict["EMD Workflow Action"]}'=='EMD Returned - Update Information'    EMD Returned - Update Information    ${data_dict["EMD Workflow Action"]}
    Run Keyword And Return If    '${data_dict["Sub-Budget Activation Status"]}'=='Integrated/Entered into Financial System'    Bypass/Activate this budget    ${data_dict["Sub-Budget Activation Status"]}

Draft Sub-Budget State
    [Arguments]    ${Activation-Status}
    log    ${Activation-Status}
    Log    This is a Draft Sub-Budget

EM Submitted
    [Arguments]    ${Activation-Status}
    Navigate to Workflow Tab
    Draft WF comment
    EM Comments to EMD
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Comparing Workflow Status    ${Activation-Status}

Navigate to Workflow Tab
    sleep    5s
    Wait until Page Contains Element    ${Workflow}
    click Element    ${Workflow}

FSC Returned - Update Budget
    [Arguments]    ${Workflow-Action}    ${Returned Reason}
    Navigate to Workflow Tab
    Draft WF comment
    EM Comments to EMD
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${FSC Returned - Update Budget}
    Click Element    ${FSC Returned - Update Budget}
    Return Reasons    ${Returned Reason}
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Comparing Workflow Status    ${Workflow-Action}

Return Reasons
    [Arguments]    ${Reasons}
    log    ${budget_dict["FSC Returned Reason"]}
    log    ${String}
    @{reasons_list}=    Split String    ${Reasons}    ;
    ${x}    Get Length    ${reasons_list}
    ${Resource_dict}=    Create Dictionary
    FOR    ${i}    IN RANGE    0    ${x}
        log    ${reasons_list}[${i}]
        Page should Contain Element    //tr[@class= 'dxeListBoxItemRow_Aqua']//td[text()='${reasons_list}[${i}]']
        Click Element    //tr[@class= 'dxeListBoxItemRow_Aqua']//td[text()='${reasons_list}[${i}]']
    END

FSC Returned - Update Information
    [Arguments]    ${Workflow-Action}    ${Returned Reason}
    Navigate to Workflow Tab
    Draft WF comment
    EM Comments to EMD
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${FSC Returned - Update Information}
    Click Element    ${FSC Returned - Update Information}
    Return Reasons    ${Returned Reason}
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Comparing Workflow Status    ${Workflow-Action}

FSC On Hold
    [Arguments]    ${Workflow-Action}    ${Returned Reason}
    Navigate to Workflow Tab
    Draft WF comment
    EM Comments to EMD
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${FSC On Hold}
    Click Element    ${FSC On Hold}
    Return Reasons    ${Returned Reason}
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Comparing Workflow Status    ${Workflow-Action}

Comparing Workflow Status
    [Arguments]    ${String}
    Wait until Page contains element    ${Last Workflow Action}
    ${Workflow Status}    Get Text    ${Last Workflow Action}
    Should Be Equal As Strings    ${Workflow Status}    ${String}

FSC Workflow Comments
    Page Should Contain Element    ${FSC Workflow Comments}

EM Comments to EMD
    Page Should Contain Element    ${EM comments to EMD}
    Input Text    ${EM comments to EMD}    ${budget_dict["Draft WF comment"]}

Draft WF comment
    Page Should Contain Element    ${FSC Workflow Comments}
    Input Text    ${FSC Workflow Comments}    ${budget_dict["Draft WF comment"]}

FSC-Approved
    [Arguments]    ${Activation-Status}
    Navigate to Workflow Tab
    Draft WF comment
    EM Comments to EMD
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${Fsc-Approved}
    Click Element    ${Fsc-Approved}
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Comparing FSC workflow status    ${Activation-Status}

Comparing FSC workflow status
    [Arguments]    ${String}
    Wait until Page contains element    ${Last Workflow Action}
    ${Workflow Status}    Get Text    ${Last Workflow Action}
    log    ${String}
    ${Workflow Status}    Remove String    ${Workflow Status}    (Send Reminder to EMD?)
    ${Workflow Status}    Get Variable Value    ${Workflow Status}
    ${Workflow Status}    Replace String    ${Workflow Status}    ${SPACE}    ${EMPTY}
    ${String}    Replace String    ${String}    ${SPACE}    ${EMPTY}
    Run Keyword And Ignore Error    Should Be Equal As Strings    ${Workflow Status}    ${String}

EMD Approved
    [Arguments]    ${Workflow-Action}
    Navigate to Workflow Tab
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${Fsc-Approved}
    Click Element    ${Fsc-Approved}
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Wait until Page contains Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${EMD Approved}
    Click Element    ${EMD Approved}
    EMD Approved WF comment
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Comparing Workflow Status    ${Workflow-Action}

EMD Approved WF comment
    Page Should Contain Element    ${FSC Workflow Comments}
    Input Text    ${FSC Workflow Comments}    ${budget_dict["EMD Approved WF comment"]}

EM comments EMD
    Page Should Contain Element    ${EM comments to EMD}
    Input Text    ${EM comments to EMD}    ${budget_dict["EM comments EMD"]}

EMD Returned - Update Budget
    [Arguments]    ${Workflow-Action}
    Navigate to Workflow Tab
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${Fsc-Approved}
    Click Element    ${Fsc-Approved}
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Wait until Page contains Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${EMD Returned - Update Budget}
    Click Element    ${EMD Returned - Update Budget}
    EMD Approved WF comment
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Comparing FSC workflow status    ${Workflow-Action}

EMD Returned - Update Information
    [Arguments]    ${Workflow-Action}
    Navigate to Workflow Tab
    Page should contain Element    ${Submit this Budget}
    Click Element    ${Submit this Budget}
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${Fsc-Approved}
    Click Element    ${Fsc-Approved}
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Wait until Page contains Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${EMD Returned - Update Information }
    Click Element    ${EMD Returned - Update Information }
    EMD Approved WF comment
    wait until page contains element    ${Save}
    Click Element    ${Save}
    Comparing FSC workflow status    ${Workflow-Action}

Bypass/Activate this budget
    Navigate to Workflow Tab
    Page should contain Element    ${Bypass/activate this budget}
    Click Element    ${Bypass/activate this budget}
    #Comparing Activation Status

Comparing Activation Status
    Wait until Page contains element    ${Last Workflow Action}
    ${Workflow Status}    Get Text    ${Last Workflow Action}
    Should Be Equal As Strings    ${Workflow Status}    Integrated/Entered into Financial System

Universal Activation
    [Arguments]    ${data_dict}
    Run Keyword And Return If    '${data_dict["Sub-Budget Activation Status"]}'=='Draft'    Bypass/Activate this budget
    Run Keyword And Return If    '${data_dict["Sub-Budget Activation Status"]}'=='EM Submitted'    EM submit then Approved
    Run Keyword And Return If    '${data_dict["FSC Workflow Action"]}'=='FSC Returned - Update Budget'    Activate the Budget
    Run Keyword And Return If    '${data_dict["FSC Workflow Action"]}'=='FSC Returned - Update Information'    Activate the Budget
    Run Keyword And Return If    '${data_dict["FSC Workflow Action"]}'=='FSC On Hold'    Activate the Budget
    Run Keyword And Return If    '${data_dict["Sub-Budget Activation Status"]}'=='Approved'    Fsc Approved then Activate
    Run Keyword And Return If    '${data_dict["EMD Workflow Action"]}'=='EMD Returned - Update Budget'    Activate the Budget
    Run Keyword And Return If    '${data_dict["EMD Workflow Action"]}'=='EMD Returned - Update Information'    Activate the Budget

EM submit then Approved
    Page Should contain Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${FSC Returned - Update Budget}
    Click Element    ${FSC Returned - Update Budget}
    Return Reasons    Non-Allowable Expense Type(s) Per Contract;Bill Rate does not agree to Contract;Other
    wait until page contains element    ${Save}
    Click Element    ${Save}
    wait until page contains element    ${Bypass/activate this budget}
    Click Element    ${Bypass/activate this budget}
    Comparing Activation Status

Activate the Budget
    wait until page contains element    ${Bypass/activate this budget}
    Click Element    ${Bypass/activate this budget}
    Comparing Activation Status

Fsc Approved then Activate
    Wait until Page contains Element    ${Response Arrow for Dropdown}
    Click Element    ${Response Arrow for Dropdown}
    Page Should contain Element    ${EMD Returned - Update Budget}
    Click Element    ${EMD Returned - Update Budget}
    Page Should contain Element    ${Save}
    Click Element    ${Save}
    Activate the Budget
