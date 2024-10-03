*** Settings ***
Documentation    Keyword Library for iBudget Functionality
Resource        Keyword_Library_iBudget.robot
Resource        Keyword_Library_iBudget_Calculations.robot

*** Variables ***
${index}            0

*** Keywords ***
Get Re-estimated Budget Test Data
    [Arguments]         ${contentSheet}     ${tcno}
    [Documentation]     This Keyword creates a data dictionary which contains the data for the Budget that is to becreated.
    ...                 Arguments: 1. Data Sheet name.
    ...                            2. Row/ Test Case no.
    Set Log Level    NONE
    ${budget_dict}=      Get Data From CSV File    ${contentSheet}      TC#     ${tcno}
    ${t}=    Get TimeStamp
    Set Test Variable    ${t}
    Run Keyword If    '${budget_dict["Project Description"]}'!=''    Set To Dictionary    ${budget_dict}    Project Description    ${budget_dict["Project Description"]} ${t}
    Set Log Level    INFO
    [Return]    ${budget_dict}

Validate Budget is Activated And Ready for re-estimation
    Run Keyword And Continue On Failure         Page should contain Element     ${Re-estimate Last Basic Header}
    Run Keyword And Continue On Failure         Page should contain Element     ${Re-estimate Revised Header}
    ${Project_Name}=        Get Element Attribute       //table[@class= 'basicprojectinfotable']//td[text()= 'Project Description']/following-sibling::td//input        value
    Run Keyword And Continue On Failure         Page should contain Element     (//table[@class= 'basicprojectinfotable'])[3]//td[text()= 'Project Description ']/following-sibling::td//input[@value= '${Project_Name}']
    ${BU}=      Get Element Attribute       //table[@class= 'basicprojectinfotable']//td[text()= 'BU']/following-sibling::td//input     value
    Run Keyword And Continue On Failure         Page should contain Element     (//table[@class= 'basicprojectinfotable'])[3]//td[text()= 'BU']/following-sibling::td//input[@value= '${BU}']
    ${Rate_card_type}=      Get Element Attribute       (//table[@class= 'basicprojectinfotable'])[2]//td[text()= 'Rate Card Type ']/following-sibling::td//input       value
    Run Keyword And Continue On Failure         Page should contain Element     (//table[@class= 'basicprojectinfotable'])[4]//td[text()= 'Rate Card Type ']/following-sibling::td//input[@value= '${Rate_Card_Type}']

Update Revised Basic Budget Information on BasicInfo Page
    [Arguments]         ${Re-estimated Data}        ${tcno}
    ${estimated_budget_dict}=       Get Re-estimated Budget Test Data         ${Re-estimated Data}        ${tcno}
    Set Global Variable      ${estimated_budget_dict}
    ${Last_Approved_dict}=      Get Last Approved Basic Budget Information Dict      ${estimated_budget_dict}
    Set Global Variable         ${Last_Approved_dict}
    ${cur_rates}=       Normalize Currency Rates        ${Last_Approved_dict["Base Currency"]}        ${Last_Approved_dict["Contract Currency"]}
    Set Global Variable     ${cur_rates}
    ${currency}=        Get From Dictionary        ${Last_Approved_dict}       Contract Currency
    Run Keyword If       '${estimated_budget_dict["Project Description"]}'!=''       Input Text         ${Re-estimated PD input}        ${estimated_budget_dict["Project Description"]}
    Run Keyword If       '${estimated_budget_dict["EMD"]}'!='' and '${estimated_budget_dict["EMD"]}'!='${Last_Approved_dict["EMD"]}'        Update Revised Budget EMD       ${estimated_budget_dict["EMD"]}
    Run Keyword If       '${estimated_budget_dict["EM"]}'!='' and '${estimated_budget_dict["EM"]}'!='${Last_Approved_dict["EM"]}'        Update Revised Budget EM       ${estimated_budget_dict["EM"]}
    Run Keyword If       '${estimated_budget_dict["Project Department"]}'!='' and '${estimated_budget_dict["Project Department"]}'!='${Last_Approved_dict["Project Department"]}'        Update Revised Budget Project Department       ${estimated_budget_dict["Project Department"]}
    Run Keyword If       '${estimated_budget_dict["Service Offering"]}'!='' and '${estimated_budget_dict["Service Offering"]}'!='${Last_Approved_dict["Service"]}'        Update Revised Budget Service       ${estimated_budget_dict["Service Offering"]}
    Click Element       //div[@id= 'SaveTop_CD']
    Sleep       10s
    ${Resource_List}=       Create List
    Set Global Variable      ${Resource_List}
    ${dataFrame}=        create_dataframe
    Run Keyword If       '${estimated_budget_dict["Contract rate Type"]}'!=''       Add Revised Contract Rates       ${estimated_budget_dict["Contract rate Type"]}         ${Last_Approved_dict}       &{cur_rates}[${currency}]
    Run Keyword If       '${estimated_budget_dict["Unit-Based CR"]}'!=''          Edit/Add Revised Unit-Value Based Contract Rates         ${estimated_budget_dict}
    Run Keyword If       '${estimated_budget_dict["Contract Rate Exception"]}'!=''          Edit/Add Revised Contract Rate Card Exception Rates         ${estimated_budget_dict["Contract Rate Exception"]}      &{cur_rates}[${currency}]
    Run Keyword If       '${estimated_budget_dict["MF/IBU Contract Rate Exception"]}'!=''       Edit/Add Revised MF/IBU Contract Rate Card Exception Rates      ${estimated_budget_dict["MF/IBU Contract Rate Exception"]}      &{cur_rates}[${currency}]
    [Return]         ${estimated_budget_dict}

Update Revised Budget EMD
    [Arguments]         ${emd}
    Set Selenium Speed    1s
    Click Element       ${Re-estimated EMD input dropdown}
    Wait Until Element Is Visible       //tr[@id= 'gridLookupEMD_DDD_gv_DXFilterRow']//input[@type= 'text']         10s
    Input Text      //tr[@id= 'gridLookupEMD_DDD_gv_DXFilterRow']//input[@type= 'text']      ${emd}
    Wait Until Element Is Visible       //table[@id= 'gridLookupEMD_DDD_gv_DXMainTable']//td[text()= '${emd}']          10s
    Click Element       //table[@id= 'gridLookupEMD_DDD_gv_DXMainTable']//td[text()= '${emd}']
    Set Selenium Speed      ${DELAY}

Update Revised Budget EM
    [Arguments]         ${em}
    Set Selenium Speed    1s
    Click Element           ${Re-estimated EM input dropdown}
    Wait Until Element Is Visible       //tr[@id= 'gridLookupEM_DDD_gv_DXFilterRow']//input[@type= 'text']         10s
    Input Text      //tr[@id= 'gridLookupEM_DDD_gv_DXFilterRow']//input[@type= 'text']      ${em}
    Wait Until Element Is Visible       //table[@id= 'gridLookupEM_DDD_gv_DXMainTable']//td[text()= '${em}']          10s
    Click Element       //table[@id= 'gridLookupEM_DDD_gv_DXMainTable']//td[text()= '${em}']
    Set Selenium Speed      ${DELAY}

Update Revised Budget Project Department
    [Arguments]         ${dept}
    Click Element       ${Re-estimated Department input dropdown}
    Press Key       ${Re-estimated Department input}       \\08
    Input Text       ${Re-estimated Department input}       ${dept}

Update Revised Budget Service
    [Arguments]         ${service}
    Set Selenium Speed    1s
    Click Element       ${Re-estimated Service input dropdown}
    Wait Until Element Is Visible        ${Re-estimated Service input}      10s
    Input Text      ${Re-estimated Service input}       ${service}
    Sleep       5s
    Wait Until Element Is Visible       //table[@id= 'GridLookupPrimaryService_DDD_gv_DXMainTable']//td[text()= '${service}']        10s
    Click Element           //table[@id= 'GridLookupPrimaryService_DDD_gv_DXMainTable']//td[text()= '${service}']
    Set Selenium Speed      ${DELAY}

Get Last Approved Basic Budget Information Dict
    [Arguments]      ${estimated_budget_dict}
    ${Last_Approved_dict}=      Create Dictionary       Project Description=0       Base Currency=0         EMD=0         EM=0          Project Department=0          Service=0      Contract Currency=0
    FOR   ${key}        IN      @{Last_Approved_dict.keys()}
        ${value}=        Get Element Attribute       //table[@class= 'basicprojectinfotable']//td[text()= '${key}']/following-sibling::td//input        value
        Set To Dictionary       ${Last_Approved_dict}       ${key}        ${value}
    END
    ${budget_Type}=        Get Element Attribute       //table[@class= 'basicprojectinfotable']//td[text()= 'Rate Card Type ']/following-sibling::td//input        value
    Set To Dictionary       ${Last_Approved_dict}       Rate Card Type        ${budget_Type}
    ${Last_Approved_dict}=      Run Keyword If          '${Last_Approved_dict["Rate Card Type"]}'!='Unit/Value-Based'        Get Hourly Last Approved Contract Rates Dict       ${Last_Approved_dict}
    ...         ELSE        Set Variable        ${Last_Approved_dict}
    [Return]        ${Last_Approved_dict}

Get Hourly Last Approved Contract Rates Dict
    [Arguments]      ${Last_Approved_dict}
    ${Last_ContractRate_dict}=          Get Data From CSV File         ${ibudget_contract_rate}       Job Function          Contract Rate4
    FOR   ${key}        IN      @{Last_ContractRate_dict.keys()}
        ${value}=       Get Element Attribute       //table[@class= 'contractratetable']//td[text()= '${key}']/following-sibling::td//input[@type= 'text']      value
        Set To Dictionary       ${Last_ContractRate_dict}       ${key}      ${value}
    END
    Set To Dictionary       ${Last_Approved_dict}       Contract_rate        ${Last_ContractRate_dict}
    [Return]        ${Last_Approved_dict}

Add Revised Contract Rates
    [Arguments]     ${Rate_Type}        ${Last_Approved_dict}       ${Currency}
    ${Revised_ContractRate_dict}=          Get Data From CSV File         ${ibudget_contract_rate}       Job Function          ${Rate_Type}
    Set Global Variable         ${Revised_ContractRate_dict}
    FOR   ${key}        IN      @{Revised_ContractRate_dict.keys()}
        ${val}=         Set Variable        &{Revised_ContractRate_dict}[${Key}].00
        Set To Dictionary       ${Revised_ContractRate_dict}        ${Key}      ${val}
    END
    ${Last_approved_contract_dict}=         Get From Dictionary      ${Last_Approved_dict}       Contract_rate
    Run Keyword If      '${Last_approved_contract_dict["Managing Director 1"]}'!='${Revised_ContractRate_dict["Managing Director 1"]}'          Add Revised Contract Rates For Job-Function      ManagingDirector1         ${Revised_ContractRate_dict["Managing Director 1"]}
    Run Keyword If      '${Last_approved_contract_dict["Senior Director"]}'!='${Revised_ContractRate_dict["Senior Director"]}'          Add Revised Contract Rates For Job-Function      SeniorDirector         ${Revised_ContractRate_dict["Senior Director"]}
    Run Keyword If      '${Last_approved_contract_dict["Director"]}'!='${Revised_ContractRate_dict["Director"]}'          Add Revised Contract Rates For Job-Function      Director         ${Revised_ContractRate_dict["Director"]}
    Run Keyword If      '${Last_approved_contract_dict["Associate Director"]}'!='${Revised_ContractRate_dict["Associate Director"]}'          Add Revised Contract Rates For Job-Function      AssociateDirector         ${Revised_ContractRate_dict["Associate Director"]}
    Run Keyword If      '${Last_approved_contract_dict["Senior Manager"]}'!='${Revised_ContractRate_dict["Senior Manager"]}'          Add Revised Contract Rates For Job-Function      SeniorManager         ${Revised_ContractRate_dict["Senior Manager"]}
    Run Keyword If      '${Last_approved_contract_dict["Manager"]}'!='${Revised_ContractRate_dict["Manager"]}'          Add Revised Contract Rates For Job-Function      Manager         ${Revised_ContractRate_dict["Manager"]}
    Run Keyword If      '${Last_approved_contract_dict["Senior Consultant 1"]}'!='${Revised_ContractRate_dict["Senior Consultant 1"]}'          Add Revised Contract Rates For Job-Function      SeniorConsultant1         ${Revised_ContractRate_dict["Senior Consultant 1"]}
    Run Keyword If      '${Last_approved_contract_dict["Senior Consultant 2"]}'!='${Revised_ContractRate_dict["Senior Consultant 2"]}'          Add Revised Contract Rates For Job-Function      SeniorConsultant2         ${Revised_ContractRate_dict["Senior Consultant 2"]}
    Run Keyword If      '${Last_approved_contract_dict["Consultant 1"]}'!='${Revised_ContractRate_dict["Consultant 1"]}'          Add Revised Contract Rates For Job-Function      Consultant1         ${Revised_ContractRate_dict["Consultant 1"]}
    Run Keyword If      '${Last_approved_contract_dict["Consultant 2"]}'!='${Revised_ContractRate_dict["Consultant 2"]}'          Add Revised Contract Rates For Job-Function      Consultant2         ${Revised_ContractRate_dict["Consultant 2"]}
    Run Keyword If      '${Last_approved_contract_dict["Intern"]}'!='${Revised_ContractRate_dict["Intern"]}'          Add Revised Contract Rates For Job-Function      Intern         ${Revised_ContractRate_dict["Intern"]}
    Run Keyword If      '${Last_approved_contract_dict["Associate"]}'!='${Revised_ContractRate_dict["Associate"]}'          Add Revised Contract Rates For Job-Function      Associate        ${Revised_ContractRate_dict["Associate"]}
    Click Element        //div[@id= 'Save_CD']
    Sleep       20s
    Validate Revised Contract Rate(Base) Exchange rates on Budget       ${Revised_ContractRate_dict}        ${Currency}

Add Revised Contract Rates For Job-Function
    [Arguments]     ${job function}         ${rate}
    #${old_rate}=        Set Variable       ${old_rate}.00
    Wait Until Element Is Visible       (//table[@class= 'contractratetable'])[2]//input[@id= 'ContractRatesView.${job function}_I']       30s
    ${val}     Get Value        (//table[@class= 'contractratetable'])[2]//input[@id= 'ContractRatesView.${job function}_I']
    Log      ${val}
    ${count}        Get Length      ${val}
    Log       ${count}
    Scroll Element Into View        (//table[@class= 'contractratetable'])[2]//input[@id= 'ContractRatesView.${job function}_I']
    Click Element       (//table[@class= 'contractratetable'])[2]//input[@id= 'ContractRatesView.${job function}_I']
    Run Keyword If    """${val}""" != ''
    ...     Repeat Keyword       ${count +1}        Press Key       (//table[@class= 'contractratetable'])[2]//input[@id= 'ContractRatesView.${job function}_I']       \\08
    Input Text      (//table[@class= 'contractratetable'])[2]//input[@id= 'ContractRatesView.${job function}_I']        ${rate}
    #Run Keyword And Continue On Failure         Wait Until Element Is Visible       //table[@class= 'contractratetable']//td[contains(normalize-space(.), '${job function}')]/following-sibling::td[2]/div[text()= '${rate}']       15s

Validate Revised Contract Rate(Base) Exchange rates on Budget
    [Arguments]      ${ContractRate_dict}        ${cur_rate}
    FOR     ${Key}      IN      @{ContractRate_dict.keys()}
        ${str_content}=     Remove String        ${Key}      ${SPACE}
        ${BaseRate_UI}=     Get Text       (//table[@class= 'contractratetable'])[2]//input[@id= 'ContractRatesView.${str_content}_I']/ancestor::td[2]/following-sibling::td//div[@class= 'divexchangerate']
        ${CalculatedBaseValue}=      Evaluate       &{ContractRate_dict}[${Key}]*${cur_rate}
        ${CalculatedBaseValue_Rounded}=      Convert To Number       ${CalculatedBaseValue}       2
        ${result}=      Run Keyword And Return Status      Should Be Equal As Numbers     ${BaseRate_UI}      ${CalculatedBaseValue_Rounded}
        Run Keyword If      '${result}'=='True'     Set To Dictionary        ${Revised_ContractRate_dict}        ${Key}         ${CalculatedBaseValue}
    END
    Set To Dictionary       ${Revised_ContractRate_dict}        Non-Billable       0.00
    Log      ${Revised_ContractRate_dict}

Edit/Add Revised Unit-Value Based Contract Rates
    [Arguments]         ${data_dict}
    Wait Until Element Is Visible          ${Unit-Based CR New Button}       10s
    ${Resource_dict}=         Get Resource Details Dict        ${data_dict["Unit-Based CR"]}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${UB_CR_details}=       Split String     &{Resource_dict}[${Key}]    ;
        Log         ${UB_CR_details}
        Run Keyword If      '@{UB_CR_details}[-1]'=='EDIT'         Edit Revised Unit-Value Based Contract Rates      ${UB_CR_details}        ${Key}
        ...         ELSE            Add Revised Unit-Value Based Contract Rates       ${UB_CR_details}        ${Key}
    END
    Complete Unit Value Re-estimate Tab    ${data_dict}    ${Resource_dict}

Add Revised Unit-Value Based Contract Rates
    [Arguments]     ${UB_CR_data}       ${Key}
    Click Element    ${Unit-Based CR New Button}
    Click Element    ${Unit-Based CR Header}
    Enter Unit-Based Contract Rate content on table    ${UB_CR_data}
    Scroll Element Into View    ${Unit-Based CR Save Link Button}
    Click Element    ${Unit-Based CR Save Link Button}
    Sleep    5s
    ${currency}=    Get From Dictionary    ${Last_Approved_dict}    Contract Currency
    Run Keyword And Continue On Failure    Verify Contract Rate(Base) for added Unit-Value Resource    ${UB_CR_data}        ${currency}

Edit Revised Unit-Value Based Contract Rates
    [Arguments]       ${UB_CR_data}        ${Key}
    Scroll Element Into View      ${Unit-Based CR New Button}
    Run Keyword     Page Should Contain Element      //table[@id= 'gvUnitRateCard_DXMainTable']//td[text()= '@{UB_CR_data}[0]']
    ${old_rate}=        Get Text        //table[@id= 'gvUnitRateCard_DXMainTable']//td[text()= '@{UB_CR_data}[0]']/following-sibling::td
    ${new_rate}=        Set Variable        @{UB_CR_data}[0].00
    Run Keyword If      '${old_rate}'!='${new_rate}'        Run Keywords        Click Element       //table[@id= 'gvUnitRateCard_DXMainTable']//td[contains(normalize-space(.), '@{UB_CR_data}[0]')]/following-sibling::td
    ...         AND         Press Key       //table[@id= 'gvUnitRateCard_DXMainTable']//td[contains(normalize-space(.), '@{UB_CR_data}[0]')]/following-sibling::td//input[@type= 'text']        \\08
    ...         AND         Input Text      //table[@id= 'gvUnitRateCard_DXMainTable']//td[contains(normalize-space(.), '@{UB_CR_data}[0]')]/following-sibling::td//input[@type= 'text']        @{UB_CR_data}[1]
    Scroll Element Into View    ${Unit-Based CR Save Link Button}
    Click Element    ${Unit-Based CR Save Link Button}
    Sleep    5s
    ${currency}=    Get From Dictionary    ${Last_Approved_dict}    Contract Currency
    Run Keyword And Continue On Failure    Verify Contract Rate(Base) for added Unit-Value Resource    ${UB_CR_data}        ${currency}

Complete Unit Value Re-estimate Tab
    [Arguments]    ${data_dict}    ${Resource_dict}
    Scroll Element Into View    ${sub-budget Currency Calculator Link}
    Click Element    ${sub-budget Unit Value Re-estimate Tab}
    Wait Until Page Contains Element    ${Unit Value Re-estimate Header}
    FOR    ${Key}    IN    @{Resource_dict.keys()}
        ${task_data}=    Split String    &{Resource_dict}[${Key}]    ;
        ${Task}=    Run Keyword And Return Status    Page Should Contain Element    //table[@id= 'gvUnitBasedWizard']//td[text()= '@{task_data}[0]']
        Run Keyword If    '${Task}'=='True'    Add Revised EAC QTY For Unit Value Estimate    @{task_data}[0]    @{task_data}[-2]
        Click Element    ${Unit Value Estimate Save Changes Link}
        Sleep    10s
        Fetch Calculated Unit-Value Based Data & assign in DataFrame     @{task_data}[0]    @{task_data}[1]    @{task_data}[-2]      ${Key}
    END
    Run Keyword If    '${data_dict["Volume Discount"]}'!=''    Input Text    ${Unit Value Estimate Volume Discount Input}    ${data_dict["Volume Discount"]}
    Run Keyword If    '${data_dict["Volume Discount"]}'!=''    Click Element    ${Unit Value Estimate Header}
    Sleep    5s
    Run Keyword If    '${data_dict["Volume Discount"]}'!=''    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_VolumeDiscount    ${data_dict["Volume Discount"]}
    Run Keyword If    '${data_dict["Adjustments"]}'!=''    Input Text    ${Unit Value Estimate Adjustments Input}    ${data_dict["Adjustments"]}
    Run Keyword If    '${data_dict["Adjustments"]}'!=''    Set To Dictionary    ${iBudget_Calculation}    Unit/Val_PlannedInvestment    ${data_dict["Adjustments"]}
    Click Element    ${Unit Value Estimate Save Button}
    Sleep    5s

Add Revised EAC QTY For Unit Value Estimate
    [Arguments]     ${Task}      ${EAC_QTY}
    Click Element     //table[@id= 'gvUnitBasedWizard']//td[text()= '${Task}']/following-sibling::td[6]
    Wait Until Page Contains Element         //table[@id= 'gvUnitBasedWizard']//td[text()= '${Task}']/following-sibling::td[6]//input[@type= 'text']      10s
    Press Key    //table[@id= 'gvUnitBasedWizard']//td[text()= '${Task}']/following-sibling::td[6]//input[@type= 'text']     \\08
    Input Text    //table[@id= 'gvUnitBasedWizard']//td[text()= '${Task}']/following-sibling::td[6]//input[@type= 'text']      ${EAC_QTY}

Edit/Add Revised Contract Rate Card Exception Rates
    [Arguments]      ${Rate_List}       ${curr_rate}
    Wait Until Element Is Visible       ${Re-estimate Contract Rate Exception New Button}       10s
    ${Resource_dict}=         Get Resource Details Dict        ${Rate_List}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${CR_details}=       Split String     &{Resource_dict}[${Key}]    ;
        Log         ${CR_details}
        Run Keyword If      '@{CR_details}[-1]'=='EDIT'         Edit Revised Contract Rate card Exception Rates      ${CR_details}       ${curr_rate}       ${Key}
        ...         ELSE            Add Revised Contract Rate card Exception Rates       ${CR_details}       ${curr_rate}       ${Key}
    END

Add Revised Contract Rate card Exception Rates
    [Arguments]      ${CR_Exception_data}       ${curr_rate}       ${Key}
    Wait Until Element Is Visible           ${Re-estimate Contract Rate Exception New Button}      10s
    Scroll Element Into View         ${Re-estimate Contract Rate Exception New Button}
    Click Element           ${Re-estimate Contract Rate Exception New Button}
    ${Resource_Type}=       Run Keyword If      '@{CR_Exception_data}[0]'!=''       Select Contract Rate Exception Name         @{CR_Exception_data}[0]
    ...            ELSE        Log         No Rate card Name Is Provided!
    Run Keyword If      '@{CR_Exception_data}[1]'!=''      Run Keywords      Click Element      //tr[@id= 'GVContractRateExcRateNew_DXDataRow-1']/td[3]
    ...         AND         Input Text      ${Re-estimation Contract Rate Exception Rate Input}               @{CR_Exception_data}[1]
    ...         ELSE        Log         No Contract Rate is Provided!
    Click Element       ${Re-estimate Contract Rate Exception Save Button}
    Sleep       3s
    ${rate}=        Get Text        //table[@id= 'GVContractRateExcRateNew_DXMainTable']//td[text()='@{CR_Exception_data}[0]']/following-sibling::td[1]
    ${Contract_Rate_Base_UI}=         Get Text         //table[@id= 'GVContractRateExcRateNew_DXMainTable']//td[text()='@{CR_Exception_data}[0]']/following-sibling::td[2]
    ${Contract_Rate_Base}=      Evaluate        @{CR_Exception_data}[1]*${curr_rate}
    ${Contract_Rate_Base}=      Convert To Number       ${Contract_Rate_Base}       2
    Run Keyword And Continue On Failure      Should Be Equal As Numbers     ${Contract_Rate_Base_UI}      ${Contract_Rate_Base}
    Set To Dictionary       ${Revised_ContractRate_dict}        @{CR_Exception_data}[0]         ${Contract_Rate_Base}
    Run Keyword If      '${Resource_Type}'!= 'None'         Update/Verify corresponding Labor Exception Changes     ${Resource_Type}        ${CR_Exception_data}        ${rate}        ${Key}
    ...         ELSE        Log         Invalid Data

Edit Revised Contract Rate card Exception Rates
    [Arguments]     ${CR_details}       ${currency}     ${Key}
    Scroll Element Into View         //table[@id= "GVContractRateExcRateNew"]
    Wait Until Element Is Visible       //table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${CR_details[0]}')]
    ${Resource_type}=       Get Exception Resource Type         ${CR_details[0]}
    ${Old_rate}=        Get Text       //table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${CR_details[0]}')]/following-sibling::td[1]
    ${Rate}=        Set Variable        ${CR_details[1]}.00
    Run Keyword If      '${Old_rate}'!='${Rate}'       Update Revised Contract Rate Value Exception       ${CR_details[0]}      ${Rate}       ${currency}
    Run Keyword If      '${Resource_type}'!='None'      Update/Verify corresponding Labor Exception Changes         ${Resource_type}         ${CR_details}      ${Old_rate}      ${Key}

Get Exception Resource Type
    [Arguments]      ${Resource_Name}
    Click Element       (//table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${Resource_Name}')])[2]
    Wait Until Element Is Visible       ${sub-budget Contract Rate Name dropdown}
    Click Element       ${sub-budget Contract Rate Name dropdown}
    Wait Until Element Is Visible        ${sub-budget Contract Rate Name Input}         10s
    Input Text      ${sub-budget Contract Rate Name Input}      ${Resource_Name}
    Wait Until Element Is Visible       //table[@id= 'gridLookup_DDD_gv_DXMainTable']//td[text()= '${Resource_Name}']
    Sleep    3s
    ${Resource_Type}=       Get Text        //table[@id= 'gridLookup_DDD_gv_DXMainTable']//td[text()= '${Resource_Name}']/following-sibling::td[5]
    Click Element       //table[@id= 'gridLookup_DDD_gv_DXMainTable']//td[text()= '${Resource_Name}']
    Sleep       3s
    Click Element       ${Re-estimate Contract Rate Exception Save Button}
    Sleep       5s
    [Return]        ${Resource_Type}

Update/Verify corresponding Labor Exception Changes
    [Arguments]     ${Resource_Type}       ${Resource_data}       ${Resource_Old_Rate}       ${Key}
    Run Keyword If      '${Resource_Type}'=='Practice Employee' or '${Resource_Type}'=='Operations Employee'      Update Revised Employee Labor details for Exception Resource        @{Resource_data}[0]       @{Resource_data}[1]        @{Resource_data}[2]      @{Resource_data}[-2]       ${Resource_Old_Rate}      ${Key}
    ...         ELSE IF     '${Resource_Type}'=='RH Contractor'     Update Revised RH Contractor Labor details for Exception Resource        @{Resource_data}[0]        @{Resource_data}[1]      @{Resource_data}[2]      @{Resource_data}[3]       @{Resource_data}[-2]       ${Resource_Old_Rate}      ${Key}
    ...         ELSE         Update Revised Independent Contractor Labor details for Exception Resource        @{Resource_data}[0]      @{Resource_data}[1]      @{Resource_data}[2]      @{Resource_data}[3]      @{Resource_data}[4]      @{Resource_data}[-2]      ${Resource_Old_Rate}       ${Key}

Update Revised Contract Rate Value Exception
    [Arguments]         ${Name}      ${Value}       ${currency}
    Click Element       //table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[1]
    Sleep       2s
    Press key         //table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[1]//input[@type= 'text']        \\08
    Input Text       //table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[1]//input[@type= 'text']          ${Value}
    Click Element       ${Re-estimate Contract Rate Exception Save Button}
    Sleep       5s
    Wait Until Element Is Visible        //table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[2]
    ${Contract_Rate_Base_UI}=       Get Text        //table[@id= "GVContractRateExcRateNew"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[2]
    ${Calculated_CR_Base_UI}=       Evaluate        ${Value}*${currency}
    ${Calculated_CR_Base_UI}=      Convert To Number       ${Calculated_CR_Base_UI}       2
    Run Keyword And Continue On Failure      Should Be Equal As Numbers     ${Contract_Rate_Base_UI}      ${Calculated_CR_Base_UI}
    Set To Dictionary        ${Revised_ContractRate_dict}        ${Name}         ${Calculated_CR_Base_UI}

Update Revised Employee Labor details for Exception Resource
    [Arguments]      ${Name}        ${Rate}      ${ETC_QTY}     ${Existing_Rate_ETC_QTY}      ${old_rate}        ${Key}
    Scroll Element Into View        ${sub-budget Labor Tab}
    Click Element       ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Wait Until Element Is Visible       //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']      10s
    Click Element       ${Re-estimation Collapse ETC/EAC}
    ${Rate}=        Set Variable        ${Rate}.00
    ${new_row}=     Run Keyword If      '${Rate}'!='${old_rate}'        Set Variable        True
    ...     ELSE        Set Variable        False
    Run Keyword If      '${new_row}'!='True'         Update EAC QTY for Employee Labor corresponding to Exception Resource         ${Name}        ${Rate}      ${ETC_QTY}        ${Key}      ${old_rate}        ${new_row}      ${Existing_Rate_ETC_QTY}
    ...         ELSE            Update & Validate New Employee Labor Row for New Rates corresponding to Exception Resource      ${Name}        ${Rate}      ${ETC_QTY}      ${Existing_Rate_ETC_QTY}       ${old_rate}       ${Key}     ${new_row}

Update Revised RH Contractor Labor details for Exception Resource
    [Arguments]     ${Name}      ${Rate}        ${Pay_rate}     ${ETC_QTY}      ${Existing_Rate_ETC_QTY}      ${old_rate}        ${Key}
    Scroll Element Into View        ${sub-budget Labor Tab}
    Click Element       ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Click Element       ${Re-estimation Collapse ETC/EAC}
    Wait Until Element Is Visible       //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']      10s
    ${Rate}=        Set Variable        ${Rate}.00
    ${new_row}=     Run Keyword If      '${Rate}'!='${old_rate}'        Set Variable        True
    ...     ELSE        Set Variable        False
    Run Keyword If      '${new_row}'!='True'       Update EAC QTY for RH Contractor Labor corresponding to Exception Resource         ${Name}        ${Rate}       ${Pay_rate}      ${ETC_QTY}      ${Key}      ${old_rate}        ${new_row}      ${Existing_Rate_ETC_QTY}
    ...         ELSE            Update & Validate New RH Contractor Labor Row for New Rates corresponding to Exception Resource      ${Name}        ${Rate}     ${Pay_rate}      ${ETC_QTY}         ${Existing_Rate_ETC_QTY}       ${old_rate}       ${Key}      ${new_row}

Update Revised Independent Contractor Labor details for Exception Resource
    [Arguments]     ${Name}      ${Rate}        ${Pay_rate}      ${Pay_rate_currency}       ${ETC_QTY}      ${Existing_Rate_ETC_QTY}      ${old_rate}        ${Key}
    Scroll Element Into View        ${sub-budget Labor Tab}
    Click Element       ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Click Element       ${Re-estimation Collapse ETC/EAC}
    Wait Until Element Is Visible       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']      10s
    ${Rate}=        Set Variable        ${Rate}.00
    ${new_row}=     Run Keyword If      '${Rate}'!='${old_rate}'        Set Variable        True
    ...         ELSE        Set Variable        False
    Run Keyword If      '${new_row}'!='True'        Update EAC QTY for IH Contractor Labor corresponding to Exception Resource         ${Name}        ${Rate}       ${Pay_rate}     ${Pay_rate_currency}      ${ETC_QTY}         ${Key}      ${old_rate}     ${new_row}      ${Existing_Rate_ETC_QTY}
    ...         ELSE            Update & Validate New IH Contractor Labor Row for New Rates corresponding to Exception Resource      ${Name}        ${Rate}     ${Pay_rate}      ${Pay_rate_currency}      ${ETC_QTY}       ${Existing_Rate_ETC_QTY}      ${old_rate}       ${Key}      ${new_row}

Update EAC QTY for Employee Labor corresponding to Exception Resource
    [Arguments]      ${Name}        ${Rate}      ${ETC_QTY}      ${Key}     ${old_rate}     ${new_row}      ${Existing_Rate_ETC_QTY}
    Click Element       ${Employee Labor Footer}
    Click Element        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]
    Wait Until Element Is Visible       //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]//input[@type= 'text']        5s
    Press Key       //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]//input[@type= 'text']      \\08
    Input Text      //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]//input[@type= 'text']       ${ETC_QTY}
    Click Element       ${Employee labor Save changes Link}
    Sleep       5s
    ${new_row}=     Run Keyword If       '${new_row}'=='True'       Fetch Calculated Employee Labor Exception Data and allign in DataFrame      ${Name}        ${old_rate}      ${ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    ...         ELSE        Set Variable        ${new_row}
    ${new_row}=      Fetch Calculated Employee Labor Exception Data and allign in DataFrame       ${Name}        ${Rate}      ${ETC_QTY}      ${Key}         ${new_row}     ${Existing_Rate_ETC_QTY}
    Scroll Element Into View        ${sub-budget Currency Calculator Link}
    Click Element       ${sub-budget Basic Page Info Tab}

Update & Validate New Employee Labor Row for New Rates corresponding to Exception Resource
    [Arguments]     ${Name}        ${Rate}      ${ETC_QTY}      ${Existing_Rate_ETC_QTY}      ${old_rate}           ${Key}       ${new_row}
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']
    Update Old Contract Rate ETC QTY & Validate Calculation      ${Name}        GridView_DXMainTable        ${Existing_Rate_ETC_QTY}      ${old_rate}
    Update EAC QTY for Employee Labor corresponding to Exception Resource        ${Name}        ${Rate}      ${ETC_QTY}     ${Key}      ${old_rate}     ${new_row}      ${Existing_Rate_ETC_QTY}

Update EAC QTY for RH Contractor Labor corresponding to Exception Resource
    [Arguments]      ${Name}        ${Rate}       ${Pay_rate}      ${ETC_QTY}       ${Key}       ${old_rate}     ${new_row}      ${Existing_Rate_ETC_QTY}
    Click Element       ${RHC Footer}
    ${Pay_rate_old}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]
    ${Pay_rate}=        Set Variable        ${Pay_rate}.00
    Run Keyword If      '${Pay_rate_old}'!='${Pay_rate}'        Run Keywords        Click Element       //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]
    ...      AND        Press Key       //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']      ${Pay_rate}
    Click Element       ${RHC Footer}
    ${ETC_QTY_old}=     Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]
    ${ETC_QTY}=        Set Variable        ${ETC_QTY}.00
    Run Keyword If      '${ETC_QTY_old}'!='${ETC_QTY}'        Run Keywords        Click Element       //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[13]
    ...      AND        Press Key       //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[13]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[13]//input[@type= 'text']      ${ETC_QTY}
    Click Element       ${RHC Save changes Link}
    Sleep       5s
    ${new_row}=     Run Keyword If       '${new_row}'=='True'       Fetch Calculated RH Contractor Labor Exception Data and allign in DataFrame      ${Name}        ${old_rate}     ${Pay_rate}      ${Existing_Rate_ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    ...         ELSE        Set Variable        ${new_row}
    ${new_row}=      Fetch Calculated RH Contractor Labor Exception Data and allign in DataFrame       ${Name}        ${Rate}       ${Pay_rate}      ${ETC_QTY}      ${Key}         ${new_row}     ${Existing_Rate_ETC_QTY}
    Scroll Element Into View        ${sub-budget Currency Calculator Link}
    Click Element       ${sub-budget Basic Page Info Tab}

Update & Validate New RH Contractor Labor Row for New Rates corresponding to Exception Resource
    [Arguments]     ${Name}        ${Rate}       ${Pay_rate}      ${ETC_QTY}        ${Existing_Rate_ETC_QTY}         ${old_rate}        ${Key}      ${new_row}
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']
    Update Old Contract Rate ETC QTY & Validate Calculation      ${Name}        GridView1_DXMainTable        ${Existing_Rate_ETC_QTY}      ${old_rate}
    Update EAC QTY for RH Contractor Labor corresponding to Exception Resource          ${Name}        ${Rate}       ${Pay_rate}      ${ETC_QTY}        ${Key}      ${old_rate}     ${new_row}      ${Existing_Rate_ETC_QTY}

Update EAC QTY for IH Contractor Labor corresponding to Exception Resource
    [Arguments]         ${Name}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}       ${Key}      ${old_rate}     ${new_row}      ${Existing_Rate_ETC_QTY}
    Click Element       ${IHC Footer}
    ${Pay_rate_old}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]
    ${Pay_rate}=        Set Variable        ${Pay_rate}.00
    Run Keyword If      '${Pay_rate_old}'!='${Pay_rate}'        Run Keywords        Click Element       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]
    ...      AND        Press Key       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]//input[@type= 'text']      ${Pay_rate}
    Click Element       ${IHC Footer}
    ${PR_currency_old}=     Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]
    Run Keyword If      '${PR_currency_old}'!='${Pay_rate_currency}'        Run Keywords        Click Element       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]
    ...      AND        Press Key       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[4]//input[@type= 'text']      ${Pay_rate_currency}
    Click Element       ${IHC Footer}
    ${ETC_QTY_old}=     Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[7]
    ${ETC_QTY}=        Set Variable        ${ETC_QTY}.00
    Run Keyword If      '${ETC_QTY_old}'!='${ETC_QTY}'        Run Keywords        Click Element       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[13]
    ...      AND        Press Key       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[13]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[13]//input[@type= 'text']      ${ETC_QTY}
    Click Element       ${IHC Save changes Link}
    Sleep       5s
    ${new_row}=     Run Keyword If       '${new_row}'=='True'       Fetch Calculated Independent Contractor Labor Exception Data and allign in DataFrame      ${Name}        ${old_rate}     ${Pay_rate_old}        ${Pay_rate_currency}       ${Existing_Rate_ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    ...         ELSE        Set Variable        ${new_row}
    ${new_row}=      Fetch Calculated Independent Contractor Labor Exception Data and allign in DataFrame       ${Name}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}      ${Key}         ${new_row}     ${Existing_Rate_ETC_QTY}
    Scroll Element Into View        ${sub-budget Currency Calculator Link}
    Click Element       ${sub-budget Basic Page Info Tab}

Update & Validate New IH Contractor Labor Row for New Rates corresponding to Exception Resource
    [Arguments]          ${Name}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}      ${Existing_Rate_ETC_QTY}       ${old_rate}      ${Key}      ${new_row}
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']
    Update Old Contract Rate ETC QTY & Validate Calculation      ${Name}        gvIndenpendentContrLabor_DXMainTable        ${Existing_Rate_ETC_QTY}      ${old_rate}
    Update EAC QTY for IH Contractor Labor corresponding to Exception Resource          ${Name}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}       ${Key}      ${old_rate}     ${new_row}      ${Existing_Rate_ETC_QTY}

Update Old Contract Rate ETC QTY & Validate Calculation
    [Arguments]     ${Name}        ${Resource_Path}        ${Existing_Rate_ETC_QTY}      ${old_rate}
    Wait Until Element Is Visible       //table[@id= '${Resource_Path}']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']
    Click Element       //table[@id= '${Resource_Path}']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']/following-sibling::td[7]
    Press Key           //table[@id= '${Resource_Path}']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']/following-sibling::td[7]//input[@type= 'text']          \\08
    Input Text       //table[@id= '${Resource_Path}']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']/following-sibling::td[7]//input[@type= 'text']         ${Existing_Rate_ETC_QTY}

Edit/Add Revised MF/IBU Contract Rate Card Exception Rates
    [Arguments]      ${Rate_List}       ${curr_rate}
    Wait Until Element Is Visible       ${Re-estimate MF/IBU Contract Rate Exception New Button}       10s
    ${Resource_dict}=         Get Resource Details Dict        ${Rate_List}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${MF/IBU CR_details}=       Split String     &{Resource_dict}[${Key}]    ;
        Log         ${MF/IBU CR_details}
        Run Keyword If      '@{MF/IBU CR_details}[-1]'=='EDIT'         Edit Revised MF/IBU Contract Rate card Exception Rates      ${MF/IBU CR_details}       ${curr_rate}      ${Key}
        ...         ELSE            Add Revised MF/IBU Contract Rate card Exception Rates       ${MF/IBU CR_details}       ${curr_rate}     ${Key}
    END

Add Revised MF/IBU Contract Rate card Exception Rates
    [Arguments]      ${MF_Exception_data}       ${curr_rate}        ${Key}
    Wait Until Element Is Visible           ${Re-estimate MF/IBU Contract Rate Exception New Button}      10s
    Scroll Element Into View         ${Re-estimate MF/IBU Contract Rate Exception New Button}
    Click Element       ${Re-estimate MF/IBU Contract Rate Exception New Button}
    Run Keyword If      '@{MF_Exception_data}[0]'!=''       Input Text      ${sub-budget MF/IBU Contract Rate Name Input}       @{MF_Exception_data}[0]
    ...      ELSE       Log     Invalid Input
    Click Element           //table[@id= 'gvResourceContractRate_DXStatus']
    Run Keyword If      '@{MF_Exception_data}[1]'!=''       Run Keywords        Click Element       //tr[@id= 'gvResourceContractRate_DXDataRow-1']/td[3]
    ...         AND     Input Text      ${sub-budget MF/IBU Contract Rate Job Function Input}       @{MF_Exception_data}[1]
    ...         ELSE        Log     Invalid Input
    Click Element           //table[@id= 'gvResourceContractRate_DXStatus']
    Run Keyword If      '@{MF_Exception_data}[2]'!=''       Run Keywords        Click Element       //tr[@id= 'gvResourceContractRate_DXDataRow-1']/td[4]
    ...         AND     Input Text          ${sub-budget MF/IBU Contract Rate Input}        @{MF_Exception_data}[2]
    ...         ELSE        Log     Invalid input
    Click Element       ${Re-estimate MF/IBU Contract Rate Exception Save Button}
    Sleep       3s
    Wait Until Element Is Visible           //table[@id= 'gvResourceContractRate_DXMainTable']//td[text()= '@{MF_Exception_data}[0]']/following-sibling::td[3]
    ${rate}=        Get Text        //table[@id= 'gvResourceContractRate_DXMainTable']//td[text()= '@{MF_Exception_data}[0]']/following-sibling::td[2]
    ${MF-Contract_Rate_Base_UI}=         Get Text        //table[@id= 'gvResourceContractRate_DXMainTable']//td[text()= '@{MF_Exception_data}[0]']/following-sibling::td[3]
    ${MF-Contract_Rate_Base}=      Evaluate        @{MF_Exception_data}[2]*${curr_rate}
    ${MF-Contract_Rate_Base}=      Convert To Number       ${MF-Contract_Rate_Base}       2
    Run Keyword And Continue On Failure      Should Be Equal As Numbers     ${MF-Contract_Rate_Base_UI}      ${MF-Contract_Rate_Base}
    Set To Dictionary       ${Revised_ContractRate_dict}        @{MF_Exception_data}[1]         ${MF-Contract_Rate_Base}
    ${Resource_Type}=       Get Substring       @{MF_Exception_data}[0]     0       3
    Run Keyword If      '${Resource_Type}'!= 'None'         Update/Verify corresponding Labor Exception Changes for MF/IBU Resource         ${Resource_Type}        ${MF_Exception_data}        ${rate}      ${Key}

Edit Revised MF/IBU Contract Rate card Exception Rates
    [Arguments]     ${CR_details}       ${currency}
    Scroll Element Into View         //table[@id= "gvResourceContractRate"]
    Wait Until Element Is Visible       (//table[@id= "gvResourceContractRate"]//td[contains(normalize-space(.), '${CR_details[0]}')])[2]
    ${Resource_Type}=       Get Substring       @{CR_details}[0]     0       3
    ${Old_rate}=        Get Text       //table[@id= "gvResourceContractRate"]//td[contains(normalize-space(.), '${CR_details[0]}')]/following-sibling::td[2]
    ${Rate}=        Set Variable        ${CR_details[2]}.00
    Run Keyword If      '${Old_rate}'!='${Rate}'       Update Revised MF/IBU Contract Rate Value Exception       ${CR_details[0]}      ${Rate}       ${currency}
    Run Keyword If      '${Resource_type}'!='None'      Update/Verify corresponding Labor Exception Changes for MF/IBU Resource         ${Resource_type}         ${CR_details}      ${Old_rate}     ${Key}

Update Revised MF/IBU Contract Rate Value Exception
    [Arguments]      ${Name}      ${Rate}       ${currency}
    Click Element       //table[@id= "gvResourceContractRate"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[2]
    Sleep       2s
    Press key         //table[@id= "gvResourceContractRate"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[2]//input[@type= 'text']        \\08
    Input Text       //table[@id= "gvResourceContractRate"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[2]//input[@type= 'text']          ${Rate}
    Click Element       ${Re-estimate MF/IBU Contract Rate Exception Save Button}
    Sleep       5s
    Wait Until Element Is Visible        //table[@id= "gvResourceContractRate"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[3]
    ${Contract_Rate_Base_UI}=       Get Text        //table[@id= "gvResourceContractRate"]//td[contains(normalize-space(.), '${Name}')]/following-sibling::td[3]
    ${Calculated_CR_Base_UI}=       Evaluate        ${Rate}*${currency}
    ${Calculated_CR_Base_UI}=      Convert To Number       ${Calculated_CR_Base_UI}       2
    Run Keyword And Continue On Failure      Should Be Equal As Numbers     ${Contract_Rate_Base_UI}      ${Calculated_CR_Base_UI}
    Set To Dictionary        ${Revised_ContractRate_dict}        ${Name}         ${Calculated_CR_Base_UI}

Update/Verify corresponding Labor Exception Changes for MF/IBU Resource
    [Arguments]         ${Resource_type}         ${Resource_data}      ${Resource_Old_Rate}      ${Key}
    Run Keyword If      '${Resource_Type}'=='IBU'        Update Revised IBU Labor details for Exception Resource        @{Resource_data}[0]      @{Resource_data}[1]      @{Resource_data}[2]      @{Resource_data}[3]      @{Resource_data}[4]     @{Resource_data}[5]      @{Resource_data}[-2]      ${Resource_Old_Rate}      ${Key}
    ...         ELSE       Update Revised Member Firm Labor details for Exception Resource        @{Resource_data}[0]      @{Resource_data}[1]      @{Resource_data}[2]      @{Resource_data}[3]      @{Resource_data}[4]     @{Resource_data}[5]      @{Resource_data}[-2]      ${Resource_Old_Rate}       ${Key}

Update Revised IBU Labor details for Exception Resource
    [Arguments]     ${Name}     ${Job_Function}     ${Rate}        ${Pay_rate}      ${Pay_rate_currency}       ${ETC_QTY}      ${Existing_Rate_ETC_QTY}      ${old_rate}        ${Key}
    Scroll Element Into View        ${sub-budget Labor Tab}
    Click Element       ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Wait Until Element Is Visible       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']      10s
    Click Element       ${Re-estimation Collapse ETC/EAC}
    ${Rate}=        Set Variable        ${Rate}.00
    ${new_row}=     Run Keyword If      '${Rate}'!='${old_rate}'        Set Variable        True
    ...     ELSE        Set Variable        False
    Run Keyword If      '${new_row}'!='True'        Update EAC QTY for IBU Labor corresponding to Exception Resource         ${Name}      ${Job_Function}      ${Rate}      ${Pay_rate}      ${Pay_rate_currency}     ${ETC_QTY}        ${new_row}      ${Key}      ${Existing_Rate_ETC_QTY}        ${old_rate}
    ...         ELSE            Update & Validate New IBU Labor Row for New Rates corresponding to Exception Resource      ${Name}     ${Job_Function}        ${Rate}       ${Pay_rate}      ${ETC_QTY}       ${Pay_rate_currency}      ${Existing_Rate_ETC_QTY}       ${old_rate}      ${new_row}      ${Key}

Update Revised Member Firm Labor details for Exception Resource
    [Arguments]     ${Name}     ${Job_Function}     ${Rate}        ${Pay_rate}      ${Pay_rate_currency}       ${ETC_QTY}      ${Existing_Rate_ETC_QTY}      ${old_rate}        ${Key}
    Scroll Element Into View        ${sub-budget Labor Tab}
    Click Element       ${sub-budget Labor Tab}
    Minimize Budget Gauge
    Click Element       ${Re-estimation Collapse ETC/EAC}
    Wait Until Element Is Visible       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']      10s
    ${Rate}=        Set Variable        ${Rate}.00
    ${new_row}=     Run Keyword If      '${Rate}'!='${old_rate}'        Set Variable        True
    ...     ELSE        Set Variable        False
    Run Keyword If      '${new_row}'!='True'        Update EAC QTY for Member Firm Labor corresponding to Exception Resource         ${Name}        ${Job_Function}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}      ${ETC_QTY}        ${new_row}      ${Key}      ${Existing_Rate_ETC_QTY}        ${old_rate}
    ...         ELSE            Update & Validate New Member Firm Labor Row for New Rates corresponding to Exception Resource      ${Name}      ${Job_Function}        ${Rate}     ${Pay_rate}      ${ETC_QTY}      ${Pay_rate_currency}        ${Existing_Rate_ETC_QTY}       ${old_rate}      ${new_row}      ${Key}

Update EAC QTY for IBU Labor corresponding to Exception Resource
    [Arguments]         ${Name}        ${Job_Function}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}      ${ETC_QTY}     ${new_row}       ${Key}      ${Existing_Rate_ETC_QTY}       ${old_rate}
    Click Element       ${IBU Footer}
    ${Pay_rate_old}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]
    ${Pay_rate}=        Set Variable        ${Pay_rate}.00
    Run Keyword If      '${Pay_rate_old}'!='${Pay_rate}'        Run Keywords        Click Element       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]
    ...      AND        Press Key       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]//input[@type= 'text']      ${Pay_rate}
    Click Element       ${IBU Footer}
    ${PR_currency_old}=     Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]
    Run Keyword If      '${PR_currency_old}'!='${Pay_rate_currency}'        Run Keywords        Click Element       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]
    ...      AND        Press Key       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]//input[@type= 'text']      ${Pay_rate_currency}
    Click Element       ${IBU Footer}
    ${ETC_QTY_old}=     Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]
    ${ETC_QTY}=        Set Variable        ${ETC_QTY}.00
    Run Keyword If      '${ETC_QTY_old}'!='${ETC_QTY}'        Run Keywords        Click Element       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]
    ...      AND        Press Key       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]//input[@type= 'text']      ${ETC_QTY}
    Click Element       ${IBU Save changes Link}
    Sleep       5s
    ${new_row}=     Run Keyword If       '${new_row}'=='True'       Fetch Calculated IBU Labor Exception Data and allign in DataFrame      ${Name}        ${old_rate}     ${Pay_rate_old}        ${Pay_rate_currency}       ${Existing_Rate_ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    ...         ELSE        Set Variable        ${new_row}
    ${new_row}=      Fetch Calculated IBU Labor Exception Data and allign in DataFrame       ${Name}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}      ${Key}         ${new_row}     ${Existing_Rate_ETC_QTY}
    Scroll Element Into View        ${sub-budget Currency Calculator Link}
    Click Element       ${sub-budget Basic Page Info Tab}

Update & Validate New IBU Labor Row for New Rates corresponding to Exception Resource
    [Arguments]      ${Name}     ${Job_Function}        ${Rate}         ${Pay_rate}      ${ETC_QTY}       ${Pay_rate_currency}      ${Existing_Rate_ETC_QTY}       ${old_rate}      ${new_row}      ${Key}
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']
    Update Old Contract Rate ETC QTY & Validate Calculation      ${Name}        gvInternationalBU_DXMainTable        ${Existing_Rate_ETC_QTY}      ${old_rate}
    Update EAC QTY for IBU Labor corresponding to Exception Resource          ${Name}       ${Job_Function}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}       ${new_row}      ${Key}      ${Existing_Rate_ETC_QTY}        ${old_rate}

Update EAC QTY for Member Firm Labor corresponding to Exception Resource
    [Arguments]     ${Name}        ${Job_Function}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}      ${ETC_QTY}     ${new_row}      ${Key}      ${Existing_Rate_ETC_QTY}        ${old_rate}
    Click Element       ${MF Footer}
    ${Pay_rate_old}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]
    ${Pay_rate}=        Set Variable        ${Pay_rate}.00
    Run Keyword If      '${Pay_rate_old}'!='${Pay_rate}'        Run Keywords        Click Element       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]
    ...      AND        Press Key       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[3]//input[@type= 'text']      ${Pay_rate}
    Click Element       ${MF Footer}
    ${PR_currency_old}=     Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]
    Run Keyword If      '${PR_currency_old}'!='${Pay_rate_currency}'        Run Keywords        Click Element       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]
    ...      AND        Press Key       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/preceding-sibling::td[2]//input[@type= 'text']      ${Pay_rate_currency}
    Click Element       ${MF Footer}
    ${ETC_QTY_old}=     Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]
    ${ETC_QTY}=        Set Variable        ${ETC_QTY}.00
    Run Keyword If      '${ETC_QTY_old}'!='${ETC_QTY}'        Run Keywords        Click Element       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]
    ...      AND        Press Key       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]//input[@type= 'text']      \\08
    ...      AND        Input Text       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[7]//input[@type= 'text']      ${ETC_QTY}
    Click Element       ${MF Save changes Link}
    Sleep       5s
    ${new_row}=     Run Keyword If       '${new_row}'=='True'       Fetch Calculated Member Firm Labor Exception Data and allign in DataFrame      ${Name}        ${old_rate}     ${Pay_rate_old}        ${Pay_rate_currency}       ${Existing_Rate_ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    ...         ELSE        Set Variable        ${new_row}
    ${new_row}=      Fetch Calculated Member Firm Labor Exception Data and allign in DataFrame       ${Name}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}      ${Key}         ${new_row}     ${Existing_Rate_ETC_QTY}
    Scroll Element Into View        ${sub-budget Currency Calculator Link}
    Click Element       ${sub-budget Basic Page Info Tab}

Update & Validate New Member Firm Labor Row for New Rates corresponding to Exception Resource
    [Arguments]     ${Name}      ${Job_Function}        ${Rate}     ${Pay_rate}      ${ETC_QTY}      ${Pay_rate_currency}        ${Existing_Rate_ETC_QTY}       ${old_rate}      ${Key}
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']
    Run keyword And Continue On Failure         Page should contain Element      //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${old_rate}']
    Update Old Contract Rate ETC QTY & Validate Calculation      ${Name}        gvMemberFirmLabor_DXMainTable        ${Existing_Rate_ETC_QTY}      ${old_rate}
    Update EAC QTY for Member Firm Labor corresponding to Exception Resource          ${Name}       ${Job_Function}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}       ${new_row}      ${Key}      ${Existing_Rate_ETC_QTY}        ${old_rate}

Add Revised Labor/Expenses details
    [Arguments]      ${estimated_budget_dict}
    Wait until Element Is Visible       ${sub-budget Labor Tab}         30s
    Get Horizontal Position          ${sub-budget Currency Calculator Link}
    Scroll Element Into View         ${sub-budget Currency Calculator Link}
    Click Element           ${sub-budget Labor Tab}
    Sleep       5s
    #Click Element       ${sub-budget Labor Expand/Collapse Link}
    Minimize Budget Gauge
    Run Keyword If      '${estimated_budget_dict["Employee Labor"]}'!=''          Add/Edit Revised Employee Labor details on sub-budget            ${estimated_budget_dict["Employee Labor"]}
    Run Keyword If      '${estimated_budget_dict["RH Contractor Labor"]}'!=''          Add/Edit Revised RH Contractor Labor details on sub-budget            ${estimated_budget_dict["RH Contractor Labor"]}
    Run Keyword If      '${estimated_budget_dict["IH Contractor Labor"]}'!=''          Add/Edit Revised IH Contractor Labor details on sub-budget            ${estimated_budget_dict["IH Contractor Labor"]}
    Run Keyword If      '${estimated_budget_dict["MF Labor"]}'!=''          Add/Edit Revised MF Labor details on sub-budget            ${estimated_budget_dict["MF Labor"]}
    Run Keyword If      '${estimated_budget_dict["IBU Labor"]}'!=''          Add/Edit Revised IBU Labor details on sub-budget            ${estimated_budget_dict["IBU Labor"]}
    Scroll Element Into View          ${sub-budget Expenses Tab}
    Click Element            ${sub-budget Expenses Tab}
    Run Keyword If      '${estimated_budget_dict["EMP Expenses"]}'!=''            Add/Edit Revised Employee Expense details on sub-budget         ${estimated_budget_dict["EMP Expenses"]}
    Run Keyword If      '${estimated_budget_dict["RHC Expenses"]}'!=''        Add/Edit Revised RH Contractor Expense details on sub-budget          ${estimated_budget_dict["RHC Expenses"]}
    Run Keyword If      '${estimated_budget_dict["IHC Expenses"]}'!=''        Add/Edit Revised IH Contractor Expense details on sub-budget        ${estimated_budget_dict["IHC Expenses"]}
    Run Keyword If      '${estimated_budget_dict["MF Expenses"]}'!=''        Add/Edit Revised Member Firm Expense details on sub-budget             ${estimated_budget_dict["MF Expenses"]}
    Run Keyword If      '${estimated_budget_dict["IBU Expenses"]}'!=''         Add/Edit Revised International BU Expense details on sub-budget      ${estimated_budget_dict["IBU Expenses"]}

Add/Edit Revised Employee Labor details on sub-budget
    [Arguments]      ${Employee Labor}
    Wait Until Element Is Visible       ${Employee Labor Header}        30s
    ${Resource_dict}=         Get Resource Details Dict        ${Employee Labor}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${labor_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log         ${labor_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{labor_table_data}[-1]'=='EDIT'         Edit Revised Employee Labor details on sub-budget      ${labor_table_data}        ${Key}
        ...         ELSE            Add Revised Employee Labor details on sub-budget       ${labor_table_data}      ${Key}
    END

Edit Revised Employee Labor details on sub-budget
    [Arguments]      ${labor_details}       ${key}
    Wait Until Element Is Visible       //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_details}[1]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[2]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[3]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[4]')]
    ${old_ETC_QTY}=      Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_details}[1]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[2]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[3]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[4]')]/following-sibling::td[2]
    ${ETC_QTY}=        Set Variable        @{labor_details}[5].00
    Run Keyword If      '${old_ETC_QTY}'!='${ETC_QTY}'      Run Keywords        Click Element       //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_details}[1]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[2]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[3]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[4]')]/following-sibling::td[8]
    ...       AND       Press Key       //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_details}[1]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[2]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[3]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[4]')]/following-sibling::td[8]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_details}[1]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[2]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[3]')]/following-sibling::td[contains(normalize-space(.),'@{labor_details}[4]')]/following-sibling::td[8]//input[@type= 'text']       ${ETC_QTY}
    Click Element       ${Employee labor Save changes Link}
    Sleep       3s
    Fetch Calculated Employee Labor Details and allign in DataFrame     @{labor_details}[0]     @{labor_details}[1]     @{labor_details}[2]     @{labor_details}[3]     @{labor_details}[4]     ${ETC_QTY}     ${key}

Add Revised Employee Labor details on sub-budget
    [Arguments]     ${labor_table_data}     ${key}
    Click Element       ${Employee Labor New Button}
    FOR  ${i}    IN RANGE    1    18
        Click Element       ${Employee Labor Header}
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'GridView_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<2     Evaluate        ${i}+1
        ...         ELSE IF     ${i}>6      Set Variable        14
        ...         ELSE        Set Variable        ${i}
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'GridView_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'GridView_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'GridView_DXEditor${i}_I']      @{labor_table_data}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    ${ETC_QTY}=        Set Variable        @{labor_table_data}[5].00
    Click Element       ${Employee labor Save changes Link}
    Sleep       3s
    Fetch Calculated Employee Labor Details and allign in DataFrame     @{labor_table_data}[0]     @{labor_table_data}[1]     @{labor_table_data}[2]     @{labor_table_data}[3]     @{labor_table_data}[4]     ${ETC_QTY}     ${key}

Add/Edit Revised RH Contractor Labor details on sub-budget
    [Arguments]     ${RHC Labor}
    Wait Until Element Is Visible       ${RHC Header}        30s
    ${Resource_dict}=         Get Resource Details Dict        ${RHC Labor}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${rhc_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${rhc_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{rhc_table_data}[-1]'=='EDIT'         Edit Revised RH Contractor Labor details on sub-budget      ${rhc_table_data}       ${Key}
        ...         ELSE            Add Revised RH Contractor Labor details on sub-budget       ${rhc_table_data}       ${Key}
    END

Edit Revised RH Contractor Labor details on sub-budget
    [Arguments]     ${rhc_details}      ${key}
    Wait Until Element Is Visible       //table[@id= 'GridView1_DXMainTable']//td[@title='@{rhc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[3]')]
    ${old_ETC_QTY}=      Get Text       //table[@id= 'GridView1_DXMainTable']//td[@title='@{rhc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[3]')]/following-sibling::td[4]
    ${ETC_QTY}=        Set Variable        @{rhc_details}[4].00
    Run Keyword If      '${old_ETC_QTY}'!='${ETC_QTY}'      Run Keywords        Click Element       //table[@id= 'GridView1_DXMainTable']//td[@title='@{rhc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]
    ...       AND       Press Key       //table[@id= 'GridView1_DXMainTable']//td[@title='@{rhc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'GridView1_DXMainTable']//td[@title='@{rhc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       ${ETC_QTY}
    Click Element       ${RHC Save changes Link}
    Sleep       3s
    Fetch Calculated RH Contractor Labor Details and allign in DataFrame     @{rhc_details}[0]     @{rhc_details}[1]     @{rhc_details}[2]     @{rhc_details}[3]      ${ETC_QTY}     ${key}

Add Revised RH Contractor Labor details on sub-budget
    [Arguments]     ${rhc_details}      ${key}
    Scroll Element Into View        ${RHC New Button}
    Click Element       ${RHC New Button}
    FOR  ${i}    IN RANGE    1    19
        Click Element       ${RHC Footer}
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'GridView1_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<4     Evaluate        ${i}+1
        ...         ELSE IF     ${i}>6      Set Variable        15
        ...         ELSE        Set Variable        ${i}
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'GridView1_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'GridView1_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'GridView1_DXEditor${i}_I']      @{rhc_details}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    ${ETC_QTY}=        Set Variable        @{rhc_details}[4].00
    Click Element       ${RHC Save changes Link}
    Sleep       3s
    Fetch Calculated RH Contractor Labor Details and allign in DataFrame     @{rhc_details}[0]     @{rhc_details}[1]     @{rhc_details}[2]     @{rhc_details}[3]      ${ETC_QTY}     ${key}

Add/Edit Revised IH Contractor Labor details on sub-budget
    [Arguments]     ${IHC Labor}
    Wait Until Element Is Visible       ${IHC Header}        30s
    ${Status}=     Run Keyword And Return Status       Element Should Be Visible       //b[text()= ' Independent Contractor Labor']/a[text()= '+']
    Run Keyword If      '${Status}'=='True'       Click Element        ${IHC Header}
    ${Resource_dict}=         Get Resource Details Dict        ${IHC Labor}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${ihc_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${ihc_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{ihc_table_data}[-1]'=='EDIT'         Edit Revised IH Contractor Labor details on sub-budget      ${ihc_table_data}       ${Key}
        ...         ELSE            Add Revised IH Contractor Labor details on sub-budget       ${ihc_table_data}       ${Key}
    END

Edit Revised IH Contractor Labor details on sub-budget
    [Arguments]     ${ihc_details}      ${key}
    Wait Until Element Is Visible       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='@{ihc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[3]')]
    ${old_ETC_QTY}=      Get Text       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='@{ihc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[3]')]/following-sibling::td[3]
    ${ETC_QTY}=        Set Variable        @{ihc_details}[4].00
    Run Keyword If      '${old_ETC_QTY}'!='${ETC_QTY}'      Run Keywords        Click Element       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='@{ihc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]
    ...       AND       Press Key       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='@{ihc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='@{ihc_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       ${ETC_QTY}
    Click Element       ${IHC Save changes Link}
    Sleep       3s
    Fetch Calculated IH Contractor Labor Details and allign in DataFrame     @{ihc_details}[0]     @{ihc_details}[1]     @{ihc_details}[2]     @{ihc_details}[3]      ${ETC_QTY}     ${key}

Add Revised IH Contractor Labor details on sub-budget
    [Arguments]     ${ihc_details}      ${key}
    Scroll Element Into View        ${IHC New Button}
    Click Element       ${IHC New Button}
    FOR  ${i}    IN RANGE    1    18
        Click Element       ${IHC Footer}
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'gvIndenpendentContrLabor_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<6     Evaluate        ${i}+1
        ...         ELSE       Set Variable        15
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'gvIndenpendentContrLabor_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'gvIndenpendentContrLabor_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'gvIndenpendentContrLabor_DXEditor${i}_I']      @{ihc_details}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    ${ETC_QTY}=        Set Variable        @{ihc_details}[4].00
    Click Element       ${IHC Save changes Link}
    Sleep       3s
    Fetch Calculated IH Contractor Labor Details and allign in DataFrame     @{ihc_details}[0]     @{ihc_details}[1]     @{ihc_details}[2]     @{ihc_details}[3]      ${ETC_QTY}     ${key}

Add/Edit Revised MF Labor details on sub-budget
    [Arguments]      ${MF Labor}
    Wait Until Element Is Visible       ${MF Header}        30s
    ${Status}=     Run Keyword And Return Status       Element Should Be Visible        //b[text()= ' Member Firm Labor']/a[text()= '+']
    Run Keyword If      '${Status}'=='True'       Click Element      //b[text()= ' Member Firm Labor']/a[text()= '+']
    ${Resource_dict}=         Get Resource Details Dict        ${MF Labor}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${mf_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${mf_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{mf_table_data}[-1]'=='EDIT'         Edit Revised Member Firm Labor details on sub-budget      ${mf_table_data}       ${Key}
        ...         ELSE            Add Revised Member Firm Labor details on sub-budget       ${mf_table_data}      ${Key}
    END

Edit Revised Member Firm Labor details on sub-budget
    [Arguments]     ${mf_details}       ${key}
    Wait Until Element Is Visible       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='@{mf_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[3]')]
    ${old_ETC_QTY}=      Get Text       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='@{mf_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[3]')]/following-sibling::td[3]
    ${ETC_QTY}=        Set Variable        @{mf_details}[4].00
    Run Keyword If      '${old_ETC_QTY}'!='${ETC_QTY}'      Run Keywords        Click Element       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='@{mf_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]
    ...       AND       Press Key       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='@{mf_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='@{mf_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       ${ETC_QTY}
    Click Element       ${MF Save changes Link}
    Sleep       3s
    Fetch Calculated Member Firm Labor Details and allign in DataFrame     @{mf_details}[0]     @{mf_details}[1]     @{mf_details}[2]     @{mf_details}[3]      ${ETC_QTY}     ${key}

Add Revised Member Firm Labor details on sub-budget
    [Arguments]     ${mf_details}       ${key}
    Click Element       ${MF New Button}
    FOR  ${i}    IN RANGE    1    18
        Click Element       ${MF Footer}
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'gvMemberFirmLabor_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<6     Evaluate        ${i}+1
        ...         ELSE       Set Variable        15
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'gvMemberFirmLabor_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'gvMemberFirmLabor_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'gvMemberFirmLabor_DXEditor${i}_I']      @{mf_details}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    Click Element       ${MF Save changes Link}
    Sleep       3s
    Fetch Calculated Member Firm Labor Details and allign in DataFrame     @{mf_details}[0]     @{mf_details}[1]     @{mf_details}[2]     @{mf_details}[3]      @{mf_details}[4]     ${key}

Add/Edit Revised IBU Labor details on sub-budget
    [Arguments]     ${IBU Labor}
    Wait Until Element Is Visible       ${IBU Header}        30s
    ${Status}=     Run Keyword And Return Status       Element Should Be Visible        //b[text()= ' International BU']/a[text()= '+']
    Run Keyword If      '${Status}'=='True'       Click Element      //b[text()= ' International BU']/a[text()= '+']
    ${Resource_dict}=         Get Resource Details Dict        ${IBU Labor}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${ibu_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${ibu_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{ibu_table_data}[-1]'=='EDIT'         Edit Revised IBU Labor details on sub-budget      ${ibu_table_data}     ${Key}
        ...         ELSE            Add Revised IBU Labor details on sub-budget       ${ibu_table_data}     ${Key}
    END

Edit Revised IBU Labor details on sub-budget
    [Arguments]     ${ibu_details}      ${key}
    Wait Until Element Is Visible       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='@{ibu_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[3]')]
    ${old_ETC_QTY}=      Get Text       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='@{ibu_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[3]')]/following-sibling::td[3]
    ${ETC_QTY}=        Set Variable        @{ibu_details}[4].00
    Run Keyword If      '${old_ETC_QTY}'!='${ETC_QTY}'      Run Keywords        Click Element       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='@{ibu_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]
    ...       AND       Press Key       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='@{ibu_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='@{ibu_details}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[2]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_details}[3]')]/following-sibling::td[text()= '${old_ETC_QTY}']/following-sibling::td[6]//input[@type= 'text']       ${ETC_QTY}
    Click Element       ${IBU Save changes Link}
    Sleep       3s
    Fetch Calculated IBU Labor Details and allign in DataFrame     @{ibu_details}[0]     @{ibu_details}[1]     @{ibu_details}[2]     @{ibu_details}[3]      ${ETC_QTY}     ${key}

Add Revised IBU Labor details on sub-budget
    [Arguments]     ${ibu_details}      ${key}
    Click Element       ${IBU New Button}
    FOR  ${i}    IN RANGE    1    18
        Click Element       ${IBU Footer}
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'gvInternationalBU_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<6     Evaluate        ${i}+1
        ...         ELSE       Set Variable        15
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'gvInternationalBU_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'gvInternationalBU_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'gvInternationalBU_DXEditor${i}_I']      @{ibu_details}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    Click Element       ${IBU Save changes Link}
    Sleep       3s
    Fetch Calculated IBU Labor Details and allign in DataFrame     @{ibu_details}[0]     @{ibu_details}[1]     @{ibu_details}[2]     @{ibu_details}[3]      @{ibu_details}[4]     ${key}

Add/Edit Revised Employee Expense details on sub-budget
    [Arguments]      ${EMP Expense}
    Wait Until Element Is Visible       ${sub-budget Employee Expense New Button}        30s
    ${Resource_dict}=         Get Resource Details Dict        ${EMP Expense}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${emp_ex_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${emp_ex_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{emp_ex_table_data}[-1]'=='EDIT'         Edit Revised Employee Expense details on sub-budget      ${emp_ex_table_data}     ${Key}
        ...         ELSE            Add Revised Employee Expense details on sub-budget       ${emp_ex_table_data}     ${Key}
    END

Edit Revised Employee Expense details on sub-budget
    [Arguments]      ${emp_ex_data}     ${Key}
    Wait Until Element Is Visible       //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]
    ${old_ETC Cost}=        Get Text         //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[2]
    ${old_ETC Billings}=        Get Text        //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[3]
    ${ETC Cost}=        Set Variable        @{emp_ex_data}[5].00
    ${ETC Billings}=        Set Variable        @{emp_ex_data}[6].00
    Run Keyword If      '${old_ETC Cost}'!='${ETC Cost}'      Run Keywords        Click Element       //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[6]
    ...       AND       Press Key       //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[6]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[6]//input[@type= 'text']       ${ETC Cost}
    ...       AND       Click Element       //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[7]
    Run Keyword If      '${old_ETC Billings}'!='${ETC Billings}'      Run Keywords        Click Element       //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[7]
    ...       AND       Press Key       //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[7]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '@{emp_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[1]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[2]')]/following-sibling::td[contains(normalize-space(.), '@{emp_ex_data}[3]')]/following-sibling::td[7]//input[@type= 'text']       ${ETC Billings}
    Click Element       ${Employee Expense Save changes Link}
    Sleep       3s
    Fetch Calculated Employee Expenses Details and allign in DataFrame     @{emp_ex_data}[0]     @{emp_ex_data}[1]     @{emp_ex_data}[2]     @{emp_ex_data}[3]      ${ETC Cost}     ${ETC Billings}     ${key}

Add Revised Employee Expense details on sub-budget
    [Arguments]        ${emp_ex_data}     ${Key}
    Click Element       ${sub-budget Employee Expense New Button}
    Wait Until Element Is Visible       ${Employee Expense Resource Name}
    Input Text      ${Employee Expense Resource Name}        @{emp_ex_data}[0]
    Wait Until Element Is Visible        //table[@id= 'gridLookupResourceName_DDD_gv_DXMainTable']//td[text()= '@{emp_ex_data}[0]']     10s
    Click Element           //table[@id= 'gridLookupResourceName_DDD_gv_DXMainTable']//td[text()= '@{emp_ex_data}[0]']
    Sleep   2s
    ${index}=       Evaluate        ${index}+1
    FOR  ${i}    IN RANGE    4    17
        Click Element       //td[@id= 'EmpExpGridView_tcFooterRow']
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'EmpExpGridView_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<8     Evaluate        ${i}-1
        ...         ELSE IF      '${Editable_Field}'=='True' and ${i}==16        Set Variable        12
        ...         ELSE        Set Variable        11
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'EmpExpGridView_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'EmpExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Press Key       //input[@id= 'EmpExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'EmpExpGridView_DXEditor${i}_I']      @{emp_ex_data}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    Run Keyword And Ignore Error        Click Element        ${Employee Expense Save changes Link}
    Run Keyword And Ignore Error        Click Element       //td[@id= 'EmpExpGridView_tcFooterRow']//input[@value= 'Save Changes']
    Sleep       3s
    Fetch Calculated Employee Expenses Details and allign in DataFrame     @{emp_ex_data}[0]     @{emp_ex_data}[1]     @{emp_ex_data}[2]     @{emp_ex_data}[3]      @{emp_ex_data}[5]     @{emp_ex_data}[6]     ${key}

Add/Edit Revised RH Contractor Expense details on sub-budget
    [Arguments]      ${RHC Expense}
    Wait Until Element Is Visible       ${sub-budget RHC Expense New Button}        30s
    ${Resource_dict}=         Get Resource Details Dict        ${RHC Expense}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${rhc_ex_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${rhc_ex_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{rhc_ex_table_data}[-1]'=='EDIT'         Edit Revised RH Contractor Expense details on sub-budget      ${rhc_ex_table_data}     ${Key}
        ...         ELSE            Add Revised RH Contractor Expense details on sub-budget       ${rhc_ex_table_data}     ${Key}
    END

Edit Revised RH Contractor Expense details on sub-budget
    [Arguments]      ${rhc_ex_data}     ${Key}
    Wait Until Element Is Visible       //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]
    ${old_ETC Cost}=        Get Text         //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[8]
    ${old_ETC Billings}=        Get Text        //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[9]
    ${ETC Cost}=        Set Variable        @{rhc_ex_data}[3].00
    ${ETC Billings}=        Set Variable        @{rhc_ex_data}[4].00
    Run Keyword If      '${old_ETC Cost}'!='${ETC Cost}'      Run Keywords        Click Element       //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[8]
    ...       AND       Press Key       //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       ${ETC Cost}
    ...       AND       Click Element       //table[@id='RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[9]
    Run Keyword If      '${old_ETC Billings}'!='${ETC Billings}'      Run Keywords        Click Element       //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[9]
    ...       AND       Press Key       //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '@{rhc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       ${ETC Billings}
    Click Element       ${RHC Expense Save changes Link}
    Sleep       3s
    Fetch Calculated RH Contractor Expenses Details and allign in DataFrame     @{rhc_ex_data}[0]     @{rhc_ex_data}[1]      ${ETC Cost}     ${ETC Billings}     ${key}

Add Revised RH Contractor Expense details on sub-budget
    [Arguments]        ${rhc_ex_data}     ${Key}
    Scroll Element Into View        ${sub-budget RHC Expense New Button}
    Click Element       ${sub-budget RHC Expense New Button}
    Wait Until Element Is Visible       ${RHC Expense Resource Name}
    Input Text      ${RHC Expense Resource Name}        @{rhc_ex_data}[0]
    Wait Until Element Is Visible        //table[@id= 'gridLookupResourceNameRHC_DDD_gv_DXMainTable']//td[text()= '@{rhc_ex_data}[0]']     10s
    Sleep       3s
    Click Element           //table[@id= 'gridLookupResourceNameRHC_DDD_gv_DXMainTable']//td[text()= '@{rhc_ex_data}[0]']
    Sleep   2s
    ${index}=       Evaluate        ${index}+1
    FOR  ${i}    IN RANGE    4    17
        Click Element       //td[@id= 'RhExpGridView_tcFooterRow']
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'RhExpGridView_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<8     Evaluate        ${i}-1
        ...         ELSE IF      '${Editable_Field}'=='True' and ${i}==16        Set Variable        12
        ...         ELSE        Set Variable        11
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'RhExpGridView_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'RhExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Press Key       //input[@id= 'RhExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'RhExpGridView_DXEditor${i}_I']      @{rhc_ex_data}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    Run Keyword And Ignore Error        Click Element        ${RHC Expense Save changes Link}
    Run Keyword And Ignore Error        Click Element       //td[@id= 'RhExpGridView_tcFooterRow']//input[@value= 'Save Changes']
    Sleep       3s
    Fetch Calculated RH Contractor Expenses Details and allign in DataFrame     @{rhc_ex_data}[0]     @{rhc_ex_data}[1]     @{rhc_ex_data}[3]     @{rhc_ex_data}[4]     ${key}

Add/Edit Revised IH Contractor Expense details on sub-budget
    [Arguments]      ${IHC Expense}
    Wait Until Element Is Visible       ${sub-budget RHC Expense New Button}        30s
    ${Resource_dict}=         Get Resource Details Dict        ${IHC Expense}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${ihc_ex_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${ihc_ex_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{ihc_ex_table_data}[-1]'=='EDIT'         Edit Revised IH Contractor Expense details on sub-budget      ${ihc_ex_table_data}     ${Key}
        ...         ELSE            Add Revised IH Contractor Expense details on sub-budget       ${ihc_ex_table_data}     ${Key}
    END

Edit Revised IH Contractor Expense details on sub-budget
    [Arguments]      ${ihc_ex_data}     ${Key}
    Wait Until Element Is Visible       //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]
    ${old_ETC Cost}=        Get Text         //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[8]
    ${old_ETC Billings}=        Get Text        //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[9]
    ${ETC Cost}=        Set Variable        @{ihc_ex_data}[3].00
    ${ETC Billings}=        Set Variable        @{ihc_ex_data}[4].00
    Run Keyword If      '${old_ETC Cost}'!='${ETC Cost}'      Run Keywords        Click Element       //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[8]
    ...       AND       Press Key       //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       ${ETC Cost}
    ...       AND       Click Element       //table[@id='IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[9]
    Run Keyword If      '${old_ETC Billings}'!='${ETC Billings}'      Run Keywords        Click Element       //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[9]
    ...       AND       Press Key       //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '@{ihc_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       ${ETC Billings}
    Click Element       ${IHC Expense Save changes Link}
    Sleep       3s
    Fetch Calculated IH Contractor Expenses Details and allign in DataFrame     @{ihc_ex_data}[0]     @{ihc_ex_data}[1]      ${ETC Cost}     ${ETC Billings}     ${key}

Add Revised IH Contractor Expense details on sub-budget
    [Arguments]        ${ihc_ex_data}     ${Key}
    Scroll Element Into View        ${sub-budget IHC Expense New Button}
    Click Element       ${sub-budget IHC Expense New Button}
    Wait Until Element Is Visible       ${IHC Expense Resource Name}
    Input Text      ${IHC Expense Resource Name}        @{ihc_ex_data}[0]
    Wait Until Element Is Visible        //table[@id= 'gridLookupResourceNameIHC_DDD_gv_DXMainTable']//td[text()= '@{ihc_ex_data}[0]']     10s
    Click Element           //table[@id= 'gridLookupResourceNameIHC_DDD_gv_DXMainTable']//td[text()= '@{ihc_ex_data}[0]']
    Sleep   2s
    ${index}=       Evaluate        ${index}+1
    FOR  ${i}    IN RANGE    4    17
        Click Element       //td[@id= 'IndExpGridView_tcFooterRow']
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'IndExpGridView_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<8     Evaluate        ${i}-1
        ...         ELSE IF      '${Editable_Field}'=='True' and ${i}==16        Set Variable        12
        ...         ELSE        Set Variable        11
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'IndExpGridView_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'IndExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Press Key       //input[@id= 'IndExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'IndExpGridView_DXEditor${i}_I']      @{ihc_ex_data}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    Run Keyword And Ignore Error        Click Element        ${IHC Expense Save changes Link}
    Run Keyword And Ignore Error        Click Element       //td[@id= 'IndExpGridView_tcFooterRow']//input[@value= 'Save Changes']
    Sleep       3s
    Fetch Calculated IH Contractor Expenses Details and allign in DataFrame     @{ihc_ex_data}[0]     @{ihc_ex_data}[1]     @{ihc_ex_data}[3]     @{ihc_ex_data}[4]     ${key}

Add/Edit Revised Member Firm Expense details on sub-budget
    [Arguments]      ${MF Expense}
    Wait Until Element Is Visible       ${sub-budget MF Expense New Button}        30s
    ${Resource_dict}=         Get Resource Details Dict        ${MF Expense}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${mf_ex_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${mf_ex_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{mf_ex_table_data}[-1]'=='EDIT'         Edit Revised Member Firm Expense details on sub-budget      ${mf_ex_table_data}     ${Key}
        ...         ELSE            Add Revised Member Firm Expense details on sub-budget       ${mf_ex_table_data}     ${Key}
    END

Edit Revised Member Firm Expense details on sub-budget
    [Arguments]      ${mf_ex_data}     ${Key}
    Wait Until Element Is Visible       //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]
    ${old_ETC Cost}=        Get Text         //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[8]
    ${old_ETC Billings}=        Get Text        //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[9]
    ${ETC Cost}=        Set Variable        @{mf_ex_data}[3].00
    ${ETC Billings}=        Set Variable        @{mf_ex_data}[4].00
    Run Keyword If      '${old_ETC Cost}'!='${ETC Cost}'      Run Keywords        Click Element       //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[8]
    ...       AND       Press Key       //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       ${ETC Cost}
    ...       AND       Click Element       //table[@id='MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[9]
    Run Keyword If      '${old_ETC Billings}'!='${ETC Billings}'      Run Keywords        Click Element       //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[9]
    ...       AND       Press Key       //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '@{mf_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       ${ETC Billings}
    Click Element       ${MF Expense Save changes Link}
    Sleep       3s
    Fetch Calculated Member Firm Expenses Details and allign in DataFrame     @{mf_ex_data}[0]     @{mf_ex_data}[1]      ${ETC Cost}     ${ETC Billings}     ${key}

Add Revised Member Firm Expense details on sub-budget
    [Arguments]        ${mf_ex_data}     ${Key}
    Scroll Element Into View        ${sub-budget MF Expense New Button}
    Click Element       ${sub-budget MF Expense New Button}
    Wait Until Element Is Visible       //tr[@id= 'MemExpGridView_DXDataRow-1']
    FOR  ${i}    IN RANGE    2    16
        Click Element       //td[@id= 'MemExpGridView_tcFooterRow']
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'MemExpGridView_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<8     Set Variable        ${i}
        ...         ELSE IF      '${Editable_Field}'=='True' and ${i}==15        Set Variable        12
        ...         ELSE        Set Variable        11
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'MemExpGridView_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'MemExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Press Key       //input[@id= 'MemExpGridView_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'MemExpGridView_DXEditor${i}_I']      @{mf_ex_data}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    Run Keyword And Ignore Error        Click Element        ${MF Expense Save changes Link}
    Run Keyword And Ignore Error        Click Element       //td[@id= 'MemExpGridView_tcFooterRow']//input[@value= 'Save Changes']
    Sleep       3s
    Fetch Calculated Member Firm Expenses Details and allign in DataFrame     @{mf_ex_data}[0]     @{mf_ex_data}[1]     @{mf_ex_data}[3]     @{mf_ex_data}[4]     ${key}

Add/Edit Revised International BU Expense details on sub-budget
    [Arguments]      ${IBU Expense}
    Wait Until Element Is Visible       ${sub-budget IBU Expense New Button}        30s
    ${Resource_dict}=         Get Resource Details Dict        ${IBU Expense}
    FOR     ${Key}      IN      @{Resource_dict.keys()}
        ${ibu_ex_table_data}=       Split String     &{Resource_dict}[${Key}]    ;
        Log      ${ibu_ex_table_data}
        Minimize Budget Gauge
        Run Keyword If      '@{ibu_ex_table_data}[-1]'=='EDIT'         Edit Revised International BU Expense details on sub-budget      ${ibu_ex_table_data}     ${Key}
        ...         ELSE            Add Revised International BU Expense details on sub-budget       ${ibu_ex_table_data}     ${Key}
    END

Edit Revised International BU Expense details on sub-budget
    [Arguments]      ${ibu_ex_data}     ${Key}
    Wait Until Element Is Visible       //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]
    ${old_ETC Cost}=        Get Text         //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[8]
    ${old_ETC Billings}=        Get Text        //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[9]
    ${ETC Cost}=        Set Variable        @{ibu_ex_data}[3].00
    ${ETC Billings}=        Set Variable        @{ibu_ex_data}[4].00
    Run Keyword If      '${old_ETC Cost}'!='${ETC Cost}'      Run Keywords        Click Element       //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[8]
    ...       AND       Press Key       //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[8]//input[@type= 'text']       ${ETC Cost}
    ...       AND       Click Element       //table[@id='IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[9]
    Run Keyword If      '${old_ETC Billings}'!='${ETC Billings}'      Run Keywords        Click Element       //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[9]
    ...       AND       Press Key       //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       \\08
    ...       AND       Input Text      //table[@id= 'IntGridView_DXMainTable']//td[@title = '@{ibu_ex_data}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_ex_data}[1]')]/following-sibling::td[9]//input[@type= 'text']       ${ETC Billings}
    Click Element       ${IBU Expense Save changes Link}
    Sleep       3s
    Fetch Calculated International BU Expenses Details and allign in DataFrame     @{ibu_ex_data}[0]     @{ibu_ex_data}[1]      ${ETC Cost}     ${ETC Billings}     ${key}

Add Revised International BU Expense details on sub-budget
    [Arguments]        ${ibu_ex_data}     ${Key}
    Scroll Element Into View        ${sub-budget IBU Expense New Button}
    Click Element       ${sub-budget IBU Expense New Button}
    Wait Until Element Is Visible       //tr[@id= 'IntGridView_DXDataRow-1']
    FOR  ${i}    IN RANGE    2    16
        Click Element       //td[@id= 'IntGridView_tcFooterRow']
        ${Editable_Field}=      Run Keyword And Return Status       Page Should Contain Element      //input[@id= 'IntGridView_DXEditor${i}_I']
        ${j}=       Run Keyword If      '${Editable_Field}'=='True' and ${i}<8     Set Variable        ${i}
        ...         ELSE IF      '${Editable_Field}'=='True' and ${i}==15        Set Variable        12
        ...         ELSE        Set Variable        11
        Run Keyword If      '${Editable_Field}'=='True'         Run Keywords        Click Element       //tr[@id= 'IntGridView_DXDataRow-1']/td[${j}]/div[1]
        ...      AND        Press Key       //input[@id= 'IntGridView_DXEditor${i}_I']     \\08
        ...      AND        Press Key       //input[@id= 'IntGridView_DXEditor${i}_I']     \\08
        ...      AND        Input Text      //input[@id= 'IntGridView_DXEditor${i}_I']      @{ibu_ex_data}[${index}]
        ${index}=       Run Keyword If      '${Editable_Field}'=='True'     Evaluate        ${index}+1
        ...         ELSE        Set Variable        ${index}
    END
    Run Keyword And Ignore Error        Click Element        ${IBU Expense Save changes Link}
    Run Keyword And Ignore Error        Click Element       //td[@id= 'IntGridView_tcFooterRow']//input[@value= 'Save Changes']
    Sleep       3s
    Fetch Calculated International BU Expenses Details and allign in DataFrame     @{ibu_ex_data}[0]     @{ibu_ex_data}[1]     @{ibu_ex_data}[3]     @{ibu_ex_data}[4]     ${key}

Add/Edit Revised Other fees And Charges on sub-Budget
    [Arguments]     ${data_dict}
    Scroll Element Into View        ${sub-budget Other Fees Tab}
    Click Element       ${sub-budget Other Fees Tab}
    Wait Until Element Is Visible       ${Other Fees New Button}        30s
    ${OFC_dict}=        Get Other Fees Data       ${data_dict["OFC"]}
    ${Keys}=        Get Dictionary Keys      ${OFC_dict}
    FOR     ${item}     IN      @{Keys}
        ${ofees_table_data}=        Get From Dictionary       ${OFC_dict}        ${item}
        Log         ${ofees_table_data["RE Type"]}
        Run Keyword If      '${ofees_table_data["RE Type"]}'=='EDIT'         Edit Revised Other fees And Charges on sub-Budget      ${ofees_table_data}     ${item}
        ...         ELSE            Add Revised Other fees And Charges on sub-Budget       ${ofees_table_data}     ${item}
    END

Edit Revised Other fees And Charges on sub-Budget
    [Arguments]      ${ofees_table_data}     ${Key}
    Wait Until Element Is Visible        //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${ofees_table_data["Resource Name"]}']      10s
    Click Element       //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${ofees_table_data["Resource Name"]}']/preceding-sibling::td//span[text()= 'Edit']
    Wait Until Element Is Visible         ${Other Fees Type Input Box}       10s
    ${old_ETC_Cost}=        Get Element Attribute       //input[@id= 'otherFeesView_DXEditor10_I']      value
    ${old_ETC_Billings}=        Get Element Attribute       //input[@id= 'otherFeesView_DXEditor11_I']      value
    ${ETC Cost}=        Set Variable        ${ofees_table_data["Budget Cost"]}.00
    ${ETC Billings}=        Set Variable        ${ofees_table_data["Budget Billings"]}.00
    Run Keyword If      '${old_ETC_Cost}'!='${ETC Cost}'      Run Keywords      Clear Element Text      //input[@id= 'otherFeesView_DXEditor10_I']
    ...      AND        Input Text      //input[@id= 'otherFeesView_DXEditor10_I']       ${ETC Cost}
    Run Keyword If      '${old_ETC_Billings}'!='${ETC Billings}'      Run Keywords      Clear Element Text      //input[@id= 'otherFeesView_DXEditor11_I']
    ...      AND        Input Text      //input[@id= 'otherFeesView_DXEditor11_I']       ${ETC Billings}
    Click Element       //table[@id= 'otherFeesView_DXMainTable']//span[text()= 'Update']
    Sleep       3s
    Fetch Calculated Other Fees & Charges Details and allign in DataFrame       ${ofees_table_data["Resource Name"]}        ${ofees_table_data["Budget Cost"]}      ${ofees_table_data["Budget Billings"]}      ${Key}

Add Revised Other fees And Charges on sub-Budget
    [Arguments]      ${ofees_table_data}     ${Key}
    Click Element       ${Other Fees New Button}
    Wait Until Element Is Visible        ${Other Fees Type Input Box}       10s
    ${ETC Cost}=        Set Variable        ${ofees_table_data["Budget Cost"]}.00
    ${ETC Billings}=        Set Variable        ${ofees_table_data["Budget Billings"]}.00
    Input Text      ${Other Fees Type Input Box}        ${ofees_table_data["Resource Name"]}
    Run Keyword If      '${ofees_table_data["Budget Cost"]}'!=''       Run Keywords          Clear Element Text        //input[@id= 'otherFeesView_DXEditor10_I']
    ...      AND            Input Text      //input[@id= 'otherFeesView_DXEditor10_I']       ${ETC Cost}
    Run Keyword If      '${ofees_table_data["Budget Billings"]}'!=''       Run Keywords          Clear Element Text        //input[@id= 'otherFeesView_DXEditor11_I']
    ...      AND            Input Text      //input[@id= 'otherFeesView_DXEditor11_I']       ${ETC Billings}
    Click Element       ${Other Fees Save button}
    Sleep       5s
    Fetch Calculated Other Fees & Charges Details and allign in DataFrame       ${ofees_table_data["Resource Name"]}        ${ofees_table_data["Budget Cost"]}      ${ofees_table_data["Budget Billings"]}       ${Key}


