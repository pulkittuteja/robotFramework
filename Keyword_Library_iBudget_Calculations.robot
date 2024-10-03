*** Settings ***
Documentation    Suite description
Resource          Keyword_Library_iBudget.robot
Resource          Keyword_Library_iBudget_re-estimation.robot

*** Variables ***
${Cost_Rate_Emp_MD1}            250
${Cost_Rate_RHC}            25.446
${Cost_Rate_IHC}            20.00
${Cost_Rate_Exception1}     181.31
@{Emp_CRException_EAC_QTY}
@{Emp_CRException_Costs}
@{Emp_CRException_Billings}
@{RH_CRException_EAC_QTY}
@{RH_CRException_Costs}
@{RH_CRException_Billings}
@{IH_CRException_EAC_QTY}
@{IH_CRException_Costs}
@{IH_CRException_Billings}
@{MFException_EAC_QTY}
@{MFException_Costs}
@{MFException_Billings}
@{IBUException_EAC_QTY}
@{IBUException_Costs}
@{IBUException_Billings}
@{EmpLabor_EAC_QTY}
@{EmpLabor_Costs}
@{EmpLabor_Billings}
@{NonBillable_Hours}
@{RHCLabor_EAC_QTY}
@{RHCLabor_Costs}
@{RHCLabor_Billings}
@{IHCLabor_EAC_QTY}
@{IHCLabor_Costs}
@{IHCLabor_Billings}
@{MFLabor_EAC_QTY}
@{MFLabor_Costs}
@{MFLabor_Billings}
@{IBULabor_EAC_QTY}
@{IBULabor_Costs}
@{IBULabor_Billings}
@{UnitValEACQTY}
@{UnitValEACBillings}

*** Keywords ***
Verify EAC Billing Calculation
    [Arguments]     ${job}     ${EAC_QTY}     ${EAC_Billing}
    ${Contract_rate_base}=      Set Variable        &{ContractRate_dict}[${job}]
    ${Contract_rate_base}=  Evaluate  "%.2f" % ${Contract_rate_base}
    ${EAC_Bi}=        Evaluate        ${Contract_rate_base}*${EAC_QTY}
    ${EAC_Billings}=    Convert To Number     ${EAC_Bi}     2
    ${Calculated_EAC_billings}=     Remove String    ${EAC_Billing}    ,
    Run Keyword And Continue On Failure        Should Be Equal As Numbers      ${EAC_Billings}        ${Calculated_EAC_billings}
    [Return]        ${EAC_Billings}

Verify EAC Cost Calculation
    [Arguments]         ${CR}       ${EAC_QTY}      ${EAC_Cost}
    ${EAC_C}=       Evaluate        ${CR}*${EAC_QTY}
    ${EAC_Costs}=       Convert To Number        ${EAC_C}       2
    ${Calculated_EAC_Cost}=     Remove String    ${EAC_Cost}    ,
    Run Keyword And Continue On Failure        Should Be Equal As Numbers      ${EAC_Costs}        ${Calculated_EAC_Cost}
    [Return]        ${EAC_Costs}

Get Cost Rates
    [Arguments]         ${dept_name}     ${opunit}
    ${dept}=        Get Department ID       ${dept_name}
    Connect To Database Using Custom Params    pyodbc    DRIVER='{SQL Server}', SERVER='imanagesqlserver01.database.windows.net',database='${iBudget_db}', user='imanageadmin', password='Password$123'
    ${q}    Query    Select r.JobFuncCode, r.CostRate From (Select d.Code as Dept, o.Code as OpUnit, j.Code as JobFuncCode, c.LaborCostRate as CostRate From JobFunctions j, StandardCostRates c, [dbo].[Departments] d, [dbo].[OperationUnits] o Where j.[key] = c.JobFunctionKey AND d.[key] = c.DepartmentKey AND o.[Key] = c.OperationUnitKey) as r Where Dept = '${dept}' AND OpUnit = '${opunit}' Order By JobFuncCode, CostRate
    Disconnect From Database
    ${d}=    Create Dictionary
    Log    ${q}
    FOR    ${i}    IN    @{q}
        Set To Dictionary    ${d}    ${i[0]}    ${i[1]}
    END
    Log Dictionary    ${d}
    [Return]    ${d}

Get Department ID
    [Arguments]     ${dept}
    Connect To Database Using Custom Params    pyodbc    DRIVER='{SQL Server}', SERVER='imanagesqlserver01.database.windows.net',database='${iBudget_db}', user='imanageadmin', password='Password$123'
    ${q}    Query    Select Name, Code from Departments Where Name = '${dept}'
    Disconnect From Database
    ${d}=    Create Dictionary
    Log    ${q}
    FOR    ${i}    IN    @{q}
        Set To Dictionary    ${d}    ${i[0]}    ${i[1]}
    END
    Log Dictionary    ${d}
    [Return]    &{d}[${dept}]

Get Burden Rates
    Connect To Database Using Custom Params    pyodbc    DRIVER='{SQL Server}', SERVER='imanagesqlserver01.database.windows.net',database='${iBudget_db}', user='imanageadmin', password='Password$123'
    ${q}    Query       Select l.Name, c.Code, l.BurdenRate From LineOfBusinesses l, Currencies c
    ...                 Where l.CurrencyKey = c.[Key] AND l.IsEligible = 1
    Disconnect From Database
    ${d}=    Create Dictionary
    Log    ${q}
    FOR    ${i}    IN    @{q}
        Set To Dictionary    ${d}    ${i[0]}    ${i[1]}
    END
    Log Dictionary    ${d}
    ${b}=    Create Dictionary
    FOR    ${j}    IN    @{q}
        Set To Dictionary    ${b}    ${j[0]}    ${j[2]}
    END
    Log Dictionary    ${b}
    [Return]    ${d}        ${b}

Verify Cost Rate Calculation
    [Arguments]     ${Pay_rate}         ${Currency}         ${Cost_Rate_UI}
    #${Currency}=         Get currency codes       ${Currency}
    ${Calculated_Cost_Rate}=        Evaluate        ${Pay_Rate}*&{cur_rates}[${Currency}]
    ${Cost_Rate}=      Convert To Number       ${Calculated_Cost_Rate}       2
    Run Keyword And Continue On Failure      Should Be Equal As Numbers         ${Cost_Rate_UI}         ${Cost_Rate}
    [Return]          ${Calculated_Cost_Rate}

Verify Cost Rate Calculation For Rh Contractor
    [Arguments]     ${Pay_rate}         ${Cost_Rate_UI}         ${BurdenRate}       ${Currency}
    ${Calculated_Cost_Rate}=        Evaluate        (${Pay_Rate}*&{cur_rates}[USD])*(1+${BurdenRate})
    ${Cost_Rate}=      Convert To Number       ${Calculated_Cost_Rate}       2
    Run Keyword And Continue On Failure      Should Be Equal As Numbers         ${Cost_Rate_UI}         ${Cost_Rate}
    [Return]          ${Calculated_Cost_Rate}

Verify CM percent Calculation
    [Arguments]     ${Billings}      ${Costs}        ${CM%}
    ${UI_Billings}=     Remove String    ${Billings}    ,
    ${UI_Cost}=     Remove String    ${Costs}    ,
    ${UI_CM%}=       Fetch From Left     ${CM%}      %
    #${UI_CM%}=      Convert To Number       ${UI_CM%}       1
    ${UI_CM%}=  Evaluate  "%.1f" % ${UI_CM%}
    ${Calculated_CM%}=      Run Keyword If         '${UI_Billings}'!='0.00'      Evaluate        round((${UI_Billings}-${UI_Cost})/${UI_Billings}*100,1)
    ...     ELSE        Set Variable        ${UI_CM%}
    #${Final_Calculated_CM%}=        Convert To Number       ${Calculated_CM%}       2
    Run Keyword And Continue On Failure        Should Be Equal As Numbers      ${Calculated_CM%}       ${UI_CM%}
    [Return]        ${Calculated_CM%}

Set Contract Rate For Different Contract Currency
    [Arguments]     ${Cost_Rate_Base_UI}        ${Job_Function}
    Run Keyword If      '${Cost_Rate_Base_UI}'!='&{ContractRate_dict}[${Job_Function}]'     Set To Dictionary       ${ContractRate_dict}        ${Job_Function}      ${Cost_Rate_Base_UI}

Calculate & Verify Working Budget parameters for CR Exception Employee Labor
    [Arguments]         ${job}      ${EAC_QTY}
    ${CR_job}=      Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${job}']/following-sibling::td/div
    ${CR_job}=      Get Substring      ${CR_job}      0     3
    ${Department_Name}=     Get Text         //table[@id= 'GridView_DXMainTable']//td[@title='${job}']/following-sibling::td[2]/div
    ${OP_Unit}=     Get Text         //table[@id= 'GridView_DXMainTable']//td[@title='${job}']/following-sibling::td[3]/div
    ${OP_Unit}=     Get Substring      ${OP_Unit}      0     3
    ${CostRate_dict}=       Get Cost Rates      ${Department_Name}      ${OP_Unit}
    ${EAC_Billing}=     Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${job}']/following-sibling::td[8]
    ${EAC_Cost}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${job}']/following-sibling::td[7]
    ${CM}=      Get Text            //table[@id= 'GridView_DXMainTable']//td[@title='${job}']/following-sibling::td[9]
    ${Billings}=        Verify EAC Billing Calculation          ${job}     ${EAC_QTY}       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         &{CostRate_dict}[${CR_job}]        ${EAC_QTY}        ${EAC_Cost}
    Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    Append to List      ${Emp_CRException_EAC_QTY}      ${EAC_QTY}
    Append to List      ${Emp_CRException_Costs}        ${Costs}
    Append to List      ${Emp_CRException_Billings}     ${Billings}

Calculate & Verify Working Budget parameters for CR Exception RH Contractor Labor
    [Arguments]        ${job}       ${Pay_rate}      ${EAC_QTY}
    ${Job_Function}=        Get Element Attribute       //table[@id= 'GridView1_DXMainTable']//td[@title= '${job}']/following-sibling::td      title
    ${Pay_rate}=        Set Variable       ${Pay_rate}.00
    ${EAC_QTY}=       Set Variable       ${EAC_QTY}.00
    ${RH BU/LOB}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '${job}']/following-sibling::td[2]
    ${BurdenCurrency_dict}      ${BurdenRate_dict}       Get Burden Rates
    ${EAC_Billing}=     Get Text       //table[@id= 'GridView1_DXMainTable']//td[@title= '${job}']/following-sibling::td[@title= '${EAC_QTY}']/following-sibling::td[2]
    ${EAC_Cost}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '${job}']/following-sibling::td[@title= '${EAC_QTY}']/following-sibling::td[1]
    ${CM}=          Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '${job}']/following-sibling::td[@title= '${EAC_QTY}']/following-sibling::td[3]
    ${Cost_Rate}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '${job}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[2]
    ${Cost_Rate_Base_UI}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '${job}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[3]
    Log         &{BurdenRate_dict}[${RH BU/LOB}]
    Log         &{BurdenCurrency_dict}[${RH BU/LOB}]
    ${Cost_Rate}=       Verify Cost Rate Calculation For Rh Contractor        ${Pay_rate}       ${Cost_Rate}        &{BurdenRate_dict}[${RH BU/LOB}]      &{BurdenCurrency_dict}[${RH BU/LOB}]
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Set Contract Rate For Different Contract Currency        ${Cost_Rate_Base_UI}        ${Job_Function}
    ${Billings}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'        Verify EAC Billing Calculation          ${job}     ${EAC_QTY}       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Cost_Rate}        ${EAC_QTY}        ${EAC_Cost}
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    ${EAC_Cost}=     Remove String    ${EAC_Cost}    ,
    Append to List      ${RH_CRException_EAC_QTY}     ${EAC_QTY}
    Append to List      ${RH_CRException_Costs}       ${EAC_Cost}
    Append to List      ${RH_CRException_Billings}        ${Billings}

Calculate & Verify Working Budget parameters for CR Exception IH Contractor Labor
    [Arguments]        ${name}       ${Pay_rate}     ${Currency}      ${EAC_QTY}
    ${Job_Function}=        Get Element Attribute       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '${name}']/following-sibling::td      title
    ${Pay_rate}=        Set Variable       ${Pay_rate}.00
    ${EAC_QTY}=       Set Variable       ${EAC_QTY}.00
    ${EAC_Billing}=     Get Text       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '${name}']/following-sibling::td[contains(normalize-space(.),'${EAC_QTY}')]/following-sibling::td[2]
    ${EAC_Cost}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '${name}']/following-sibling::td[contains(normalize-space(.),'${EAC_QTY}')]/following-sibling::td[1]
    ${CM}=          Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '${name}']/following-sibling::td[contains(normalize-space(.),'${EAC_QTY}')]/following-sibling::td[3]
    ${Cost_Rate_UI}=       Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '${name}']/following-sibling::td[contains(normalize-space(.),'${Pay_rate}')]/following-sibling::td[2]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Currency}        ${Cost_Rate_UI}
    #Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Set Contract Rate For Different Contract Currency        ${Cost_Rate_Base_UI}        ${Job_Function}
    ${Billings}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'        Verify EAC Billing Calculation          ${name}     ${EAC_QTY}       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Calculated_Cost_Rate}        ${EAC_QTY}        ${EAC_Cost}
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    ${EAC_Cost}=     Remove String    ${EAC_Cost}    ,
    Append to List      ${IH_CRException_EAC_QTY}     ${EAC_QTY}
    Append to List      ${IH_CRException_Costs}       ${EAC_Cost}
    Append to List      ${IH_CRException_Billings}        ${Billings}

Calculate & Verify Working Budget parameters for CR Exception MF Labor
    [Arguments]     ${Name}     ${job}      ${Pay_Rate}     ${Currency}    ${EAC_QTY}
    ${EAC_Billing}=     Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[8]
    ${EAC_Cost}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[7]
    ${CM}=      Get Text            //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[9]
    ${Cost_Rate_UI}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[4]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Currency}         ${Cost_Rate_UI}
    ${Billings}=        Verify EAC Billing Calculation          ${job}     ${EAC_QTY}       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Calculated_Cost_Rate}        ${EAC_QTY}        ${EAC_Cost}
    Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    Append to List      ${MFException_EAC_QTY}      ${EAC_QTY}
    Append to List      ${MFException_Costs}        ${Costs}
    Append to List      ${MFException_Billings}     ${Billings}

Calculate & Verify Working Budget parameters for CR Exception IBU Labor
    [Arguments]      ${Name}     ${job}      ${Pay_Rate}     ${Currency}    ${EAC_QTY}
    ${EAC_Billing}=     Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[8]
    ${EAC_Cost}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[7]
    ${CM}=      Get Text            //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[9]
    ${Cost_Rate_UI}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td/div[text()= '${job}']/ancestor::td/following-sibling::td[4]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Currency}         ${Cost_Rate_UI}
    ${Billings}=        Verify EAC Billing Calculation          ${job}     ${EAC_QTY}       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Calculated_Cost_Rate}        ${EAC_QTY}        ${EAC_Cost}
    #Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    Append to List      ${IBUException_EAC_QTY}      ${EAC_QTY}
    Append to List      ${IBUException_Costs}        ${Costs}
    Append to List      ${IBUException_Billings}     ${Billings}

Calculate & Verify Working Budget parameters for Employee Labor
    [Arguments]         ${labor_list}
    [Documentation]
    ${CR_job}=      Get Substring       @{labor_list}[1]        0       3
    ${OP_Unit}=     Get Substring       @{labor_list}[3]        0       3
    ${CostRate_dict}=       Get Cost Rates      @{labor_list}[2]      ${OP_Unit}
    ${Job_Function}=        Get Element Attribute       //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_list}[1]')]       title
    ${EAC_Billing}=     Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_list}[1]')]/following-sibling::td[7]
    ${EAC_Cost}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_list}[1]')]/following-sibling::td[6]
    ${CM}=          Get Text        //table[@id= 'GridView_DXMainTable']//td[@title= '@{labor_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{labor_list}[1]')]/following-sibling::td[8]
    ${Billings}=        Run Keyword If      '@{labor_list}[4]'=='Billable' and '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Verify EAC Billing Calculation          ${Job_Function}     @{labor_list}[5]       ${EAC_Billing}
    ...             ELSE            Run Keyword And Continue On Failure        Should Be Equal As Strings      ${EAC_Billing}        0.00
    Run Keyword If      '@{labor_list}[4]'=='Non-Billable'      Append to List      ${NonBillable_Hours}        @{labor_list}[5]
    ${Costs}=       Verify EAC Cost Calculation         &{CostRate_dict}[${CR_job}]        @{labor_list}[5]        ${EAC_Cost}
    Run Keyword If      '@{labor_list}[4]'=='Billable' and '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    ${Calculated_EAC_Cost}=     Remove String    ${EAC_Cost}    ,           #//to be removed
    Append to List      ${EmpLabor_Billings}        ${Billings}
    Append to List      ${EmpLabor_Costs}        ${Calculated_EAC_Cost}         #//to be changed
    #Append to List      ${EmpLabor_CM%}        ${CM%}
    Append to List      ${EmpLabor_EAC_QTY}        @{labor_list}[5]
    [Return]        ${EmpLabor_EAC_QTY}     ${EmpLabor_Costs}     ${EmpLabor_Billings}      ${NonBillable_Hours}

Calculate & Verify Working Budget parameters for RH Contractor Labor
    [Arguments]         ${rhc_list}
    ${Job_Function}=        Get Element Attribute       //table[@id= 'GridView1_DXMainTable']//td[@title= '@{rhc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[1]')]      title
    Set List Value      ${rhc_list}     4      @{rhc_list}[4].00
    ${RH BU/LOB}=       Set Variable        @{rhc_list}[2]
    ${BurdenCurrency_dict}      ${BurdenRate_dict}       Get Burden Rates
    ${EAC_Billing}=     Get Text       //table[@id= 'GridView1_DXMainTable']//td[@title= '@{rhc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[1]')]/following-sibling::td[@title= '@{rhc_list}[4]']/following-sibling::td[2]
    ${EAC_Cost}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '@{rhc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[1]')]/following-sibling::td[@title= '@{rhc_list}[4]']/following-sibling::td[1]
    ${CM}=          Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '@{rhc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[1]')]/following-sibling::td[@title= '@{rhc_list}[4]']/following-sibling::td[3]
    ${Cost_Rate}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '@{rhc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[3]')]/following-sibling::td[2]
    ${Cost_Rate_Base_UI}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title= '@{rhc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{rhc_list}[3]')]/following-sibling::td[3]
    ${Cost_Rate}=       Verify Cost Rate Calculation For Rh Contractor        @{rhc_list}[3]       ${Cost_Rate}        &{BurdenRate_dict}[${RH BU/LOB}]      &{BurdenCurrency_dict}[${RH BU/LOB}]
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Set Contract Rate For Different Contract Currency        ${Cost_Rate_Base_UI}        ${Job_Function}
    ${Billings}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'        Verify EAC Billing Calculation          ${Job_Function}     @{rhc_list}[4]       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Cost_Rate}        @{rhc_list}[4]        ${EAC_Cost}
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    ${EAC_Cost}=     Remove String    ${EAC_Cost}    ,
    Append to List      ${RHCLabor_EAC_QTY}     @{rhc_list}[4]
    Append to List      ${RHCLabor_Costs}       ${EAC_Cost}
    Append to List      ${RHCLabor_Billings}        ${Billings}
    [Return]        ${RHCLabor_EAC_QTY}     ${RHCLabor_Costs}       ${RHCLabor_Billings}

Calculate & Verify Working Budget parameters for IH Contractor Labor
    [Arguments]         ${ihc_list}
    ${Job_Function}=        Get Element Attribute       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '@{ihc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[1]')]      title
    Set List Value      ${ihc_list}     2      @{ihc_list}[2].00
    Set List Value      ${ihc_list}     4      @{ihc_list}[4].00
    ${EAC_Billing}=     Get Text       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '@{ihc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[4]')]/following-sibling::td[2]
    ${EAC_Cost}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '@{ihc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[4]')]/following-sibling::td[1]
    ${CM}=          Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '@{ihc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[4]')]/following-sibling::td[3]
    ${Cost_Rate_UI}=       Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '@{ihc_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ihc_list}[2]')]/following-sibling::td[2]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        @{ihc_list}[2]         @{ihc_list}[3]        ${Cost_Rate_UI}
    #Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Set Contract Rate For Different Contract Currency        ${Cost_Rate_Base_UI}        ${Job_Function}
    ${Billings}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'        Verify EAC Billing Calculation          ${Job_Function}     @{ihc_list}[4]       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Calculated_Cost_Rate}        @{ihc_list}[4]        ${EAC_Cost}
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    ${EAC_Cost}=     Remove String    ${EAC_Cost}    ,
    Append to List      ${IHCLabor_EAC_QTY}     @{ihc_list}[4]
    Append to List      ${IHCLabor_Costs}       ${EAC_Cost}
    Append to List      ${IHCLabor_Billings}        ${Billings}
    [Return]        ${IHCLabor_EAC_QTY}     ${IHCLabor_Costs}       ${IHCLabor_Billings}

Calculate & Verify Working Budget parameters for Member Firm Labor
    [Arguments]         ${mf_list}
    ${Job_Function}=        Get Element Attribute       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '@{mf_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_list}[1]')]      title
    ${EAC_Billing}=     Get Text       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '@{mf_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[3]')]/following-sibling::td[5]
    ${EAC_Cost}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '@{mf_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[3]')]/following-sibling::td[4]
    ${CM}=          Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '@{mf_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[3]')]/following-sibling::td[6]
    ${Cost_Rate_UI}=       Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '@{mf_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{mf_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[2]')]/following-sibling::td[contains(normalize-space(.), '@{mf_list}[3]')]/following-sibling::td[1]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        @{mf_list}[2]         @{mf_list}[3]        ${Cost_Rate_UI}
    ${Billings}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'         Verify EAC Billing Calculation          ${Job_Function}     @{mf_list}[4]       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Calculated_Cost_Rate}        @{mf_list}[4]        ${EAC_Cost}
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Verify CM percent Calculation       ${EAC_Billing}      ${EAC_Cost}     ${CM}
    Append to List      ${MFLabor_EAC_QTY}      @{mf_list}[4]
    Append to List      ${MFLabor_Costs}        ${Costs}
    Append to List      ${MFLabor_Billings}     ${Billings}
    [Return]        ${MFLabor_EAC_QTY}      ${MFLabor_Costs}        ${MFLabor_Billings}

Calculate & Verify Working Budget parameters for IBU Labor
    [Arguments]         ${ibu_list}
    ${Job_Function}=        Get Element Attribute       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '@{ibu_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[1]')]      title
    ${EAC_Billing}=     Get Text       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '@{ibu_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[2]')]/following-sibling::td[6]
    ${EAC_Cost}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '@{ibu_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[2]')]/following-sibling::td[5]
    #${CM}=          Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '@{ibu_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[1]')]/following-sibling::td[9]
    ${Cost_Rate_UI}=       Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '@{ibu_list}[0]']/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[1]')]/following-sibling::td[contains(normalize-space(.), '@{ibu_list}[2]')]/following-sibling::td[2]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        @{ibu_list}[2]         @{ibu_list}[3]        ${Cost_Rate_UI}
    ${Billings}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'        Verify EAC Billing Calculation          ${Job_Function}     @{ibu_list}[4]       ${EAC_Billing}
    ${Costs}=       Verify EAC Cost Calculation         ${Calculated_Cost_Rate}        @{ibu_list}[4]        ${EAC_Cost}
    Append to List      ${IBULabor_EAC_QTY}        @{ibu_list}[4]
    Append to List      ${IBULabor_Costs}       ${Costs}
    Append to List      ${IBULabor_Billings}        ${Billings}
    [Return]        ${IBULabor_EAC_QTY}     ${IBULabor_Costs}       ${IBULabor_Billings}

Calculate & Verify Working Budget parameters for Unit Value Estimate Table
    [Arguments]         ${task}     ${Contract_Rate}        ${EAC_QTY}
    ${EAC_Billing}=     Get Text        (//table[@id= 'gvUnitBasedWizard']//td[text()= '${task}']/following-sibling::td)[3]
    ${currency}=        Get From Dictionary        ${budget_dict}       Contract Currency
    ${Contract_Rate_Base}=      Evaluate        ${Contract_Rate}*&{cur_rates}[${currency}]
    ${Contract_Rate_Base}=      Convert To Number       ${Contract_Rate_Base}       2
    ${Calculated_Billing}=      Evaluate        ${Contract_Rate_Base}*${EAC_QTY}
    ${EAC_Billing}=     Remove String       ${EAC_Billing}      ,
    Run Keyword And Continue On Failure        Should Be Equal As Numbers      ${EAC_Billing}       ${Calculated_Billing}
    Append to List      ${UnitValEACQTY}        ${EAC_QTY}
    Append to List      ${UnitValEACBillings}       ${EAC_Billing}
    [Return]        ${UnitValEACQTY}        ${UnitValEACBillings}

Calculate Sub-Totals of table
    [Arguments]     ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${QTY_Total}=       Calculate Sum of Listed items       ${QTY_list}
    ${Cost_Total}=      Calculate Sum of Listed items       ${Cost_list}
    ${Billings_Total}=      Calculate Sum of Listed items       ${Billings_list}
    [Return]        ${QTY_Total}        ${Cost_Total}       ${Billings_Total}

Calculate Sum of Listed items
    [Arguments]     ${list}
    ${SUM}      Set Variable       0.00
    FOR     ${item}  IN  @{list}
        ${SUM}=     Run Keyword if      '${item}'!='None'     Evaluate        ${SUM}+${item}
        ...         ELSE        Evaluate        ${SUM}+0.00
    END
    Log     ${SUM}
    [Return]        ${SUM}

Calculate total Contract Rate Exception Amount for all Exception Labor Resources
    Calculate total Employee Labor Contract Rate Exception Amount
    Calculate total RH Contractor Labor Contract Rate Exception Amount
    Calculate total Independent Contractor Contract Rate Exception Amount

Calculate total Employee Labor Contract Rate Exception Amount
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${Emp_CRException_EAC_QTY}     ${Emp_CRException_Costs}        ${Emp_CRException_Billings}
    Set To Dictionary      ${Labor_dict}       Emp_CR_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       Emp_CR_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       Emp_CR_Exception_Billing        ${Billings_Total}

Calculate total RH Contractor Labor Contract Rate Exception Amount
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${RH_CRException_EAC_QTY}     ${RH_CRException_Costs}        ${RH_CRException_Billings}
    Set To Dictionary      ${Labor_dict}       RH_CR_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       RH_CR_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       RH_CR_Exception_Billing        ${Billings_Total}

Calculate total Independent Contractor Contract Rate Exception Amount
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${IH_CRException_EAC_QTY}     ${IH_CRException_Costs}        ${IH_CRException_Billings}
    Set To Dictionary      ${Labor_dict}       IH_CR_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       IH_CR_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       IH_CR_Exception_Billing        ${Billings_Total}

Calculate total Contract Rate MF/IBU Exception Amount for all Exception Resources
    Calculate total Contract Rate MF Exception Amount for all Exception Resources
    Calculate total Contract Rate IBU Exception Amount for all Exception Resources

Calculate total Contract Rate MF Exception Amount for all Exception Resources
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table        ${MFException_EAC_QTY}      ${MFException_Costs}        ${MFException_Billings}
    Set To Dictionary      ${Labor_dict}       MF_CR_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       MF_CR_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       MF_CR_Exception_Billing        ${Billings_Total}

Calculate total Contract Rate IBU Exception Amount for all Exception Resources
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table        ${IBUException_EAC_QTY}      ${IBUException_Costs}        ${IBUException_Billings}
    Set To Dictionary      ${Labor_dict}       IBU_CR_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       IBU_CR_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       IBU_CR_Exception_Billing        ${Billings_Total}

Calculate total Non Exception Amount for Employee Labor Resources
    [Arguments]     ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    Set To Dictionary      ${Labor_dict}       Emp_Non_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       Emp_Non_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       Emp_Non_Exception_Billing        ${Billings_Total}

Calculate total Non Exception Amount for RHC Labor Resources
    [Arguments]     ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    Set To Dictionary      ${Labor_dict}       RHC_Non_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       RHC_Non_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       RHC_Non_Exception_Billing        ${Billings_Total}

Calculate total Non Exception Amount for IHC Labor Resources
    [Arguments]     ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    Set To Dictionary      ${Labor_dict}       IHC_Non_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       IHC_Non_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       IHC_Non_Exception_Billing        ${Billings_Total}

Calculate total Non Exception Amount for Member Firm Labor Resources
    [Arguments]     ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    Set To Dictionary      ${Labor_dict}       MF_Non_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       MF_Non_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       MF_Non_Exception_Billing        ${Billings_Total}

Calculate total Non Exception Amount for IBU Labor Resources
    [Arguments]     ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    Set To Dictionary      ${Labor_dict}       IBU_Non_Exception_QTY        ${QTY_Total}
    Set To Dictionary      ${Labor_dict}       IBU_Non_Exception_Cost        ${Cost_Total}
    Set To Dictionary      ${Labor_dict}       IBU_Non_Exception_Billing        ${Billings_Total}

Verify Sub-Totals of table
    [Arguments]     ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    ${Billings_UI}=     Run Keyword If      ${Billings_UI}==None
    ...     Set variable    0.00
    ...     ELSE
    ...     Set variable        ${Billings_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${QTY_Total}        ${EACQTY_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Cost_Total}        ${Cost_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_Total}        ${Billings_UI}
    [Return]        ${Billings_UI}

Get Sum From iBudget Dictionary
    [Arguments]      ${VAR1}        ${VAR2}
    ${SUM_Value}=        Evaluate        &{iBudget_Calculation}[${VAR1}]+&{iBudget_Calculation}[${VAR2}]
    [Return]        ${SUM_Value}

Set Non-Billable Hours in Output Dictionary
    [Arguments]     ${Non-Billable_List}
    ${Non-Billable_Hours}=      Calculate Sum of Listed items       ${Non-Billable_List}
    Set To Dictionary      ${iBudget_Calculation}       Non-Billable_Hours          ${Non-Billable_Hours}

Calculate & Verify Sub-Total Employee Labor
    [Documentation]
    ${QTY_Total}=       Evaluate        &{Labor_dict}[Emp_Non_Exception_QTY]+&{Labor_dict}[Emp_CR_Exception_QTY]
    ${Cost_Total}=      Evaluate        &{Labor_dict}[Emp_Non_Exception_Cost]+&{Labor_dict}[Emp_CR_Exception_Cost]
    ${Billings_Total}=      Evaluate        &{Labor_dict}[Emp_Non_Exception_Billing]+&{Labor_dict}[Emp_CR_Exception_Billing]
    Wait Until Page Contains Element        (//td[contains(normalize-space(.), 'Employee Labor Sub-Totals')])[2]/following-sibling::td[7]/span          10s
    ${EACQTY_UI}=       Get Text        (//td[contains(normalize-space(.), 'Employee Labor Sub-Totals')])[2]/following-sibling::td[7]/span
    ${Cost_UI}=     Get Text        (//td[contains(normalize-space(.), 'Employee Labor Sub-Totals')])[2]/following-sibling::td[8]/span
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Get Text        (//td[contains(normalize-space(.), 'Employee Labor Sub-Totals')])[2]/following-sibling::td[9]/span
    ${CM%_UI}=      Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'          Get Text        (//td[contains(normalize-space(.), 'Employee Labor Sub-Totals')])[2]/following-sibling::td[10]/span
    ${CM%}=     Run Keyword If   '${Billings_Total}'!='0.00' and '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'         Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       EmpLabor_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       EmpLabor_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       EmpLabor_EACBillings      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       EmpLabor_CM%      ${CM%}

Calculate & Verify Sub-Total Member Firm Labor
    [Documentation]
    #Scroll Element Into View        ${sub-budget Labor Tab}
    #Run Keyword And Ignore Error         Click Element       ${sub-budget Labor Tab}
    ${QTY_Total}=       Evaluate        &{Labor_dict}[MF_Non_Exception_QTY]+&{Labor_dict}[MF_CR_Exception_QTY]
    ${Cost_Total}=      Evaluate        &{Labor_dict}[MF_Non_Exception_Cost]+&{Labor_dict}[MF_CR_Exception_Cost]
    ${Billings_Total}=      Evaluate        &{Labor_dict}[MF_Non_Exception_Billing]+&{Labor_dict}[MF_CR_Exception_Billing]
    Wait Until Page Contains Element        (//td[contains(normalize-space(.), 'Member Firm Labor Sub-Totals')])[2]/following-sibling::td[8]/span          10s
    ${Status}=     Run Keyword And Return Status       Element Should Be Visible        //b[text()= ' Member Firm Labor']/a[text()= '+']
    Run Keyword If      '${Status}'=='True'       Click Element      //b[text()= ' Member Firm Labor']/a[text()= '+']
    ${EACQTY_UI}=       Get Text        (//td[contains(normalize-space(.), 'Member Firm Labor Sub-Totals')])[2]/following-sibling::td[8]/span
    ${Cost_UI}=     Get Text        (//td[contains(normalize-space(.), 'Member Firm Labor Sub-Totals')])[2]/following-sibling::td[9]/span
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'           Get Text        (//td[contains(normalize-space(.), 'Member Firm Labor Sub-Totals')])[2]/following-sibling::td[10]/span
    ${CM%_UI}=      Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Get Text        (//td[contains(normalize-space(.), 'Member Firm Labor Sub-Totals')])[2]/following-sibling::td[11]/span
    ${CM%}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'          Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       MFLabor_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       MFLabor_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       MFLabor_EACBillings      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       MFLabor_CM%      ${CM%}

Calculate & Verify Sub-Total RH Contractor Labor
    [Documentation]
    ${QTY_Total}=       Evaluate        &{Labor_dict}[RHC_Non_Exception_QTY]+&{Labor_dict}[RH_CR_Exception_QTY]
    ${Cost_Total}=      Evaluate        &{Labor_dict}[RHC_Non_Exception_Cost]+&{Labor_dict}[RH_CR_Exception_Cost]
    ${Billings_Total}=      Evaluate        &{Labor_dict}[RHC_Non_Exception_Billing]+&{Labor_dict}[RH_CR_Exception_Billing]
    #${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    Run Keyword And Ignore Error        Scroll Element Into View         //b[text()= ' RH Contractor Labor']/a[text()= '+']
    Run Keyword And Ignore Error        Scroll Element Into View         //b[text()= ' RH Contractor Labor']/a[text()= '-']
    ${Status}=     Run Keyword And Return Status       Element Should Be Visible        //b[text()= ' RH Contractor Labor']/a[text()= '+']
    Run Keyword If      '${Status}'=='True'       Click Element        //b[text()= ' RH Contractor Labor']/a[text()= '+']
    ${EACQTY_UI}=       Get Text        (//td[contains(normalize-space(.), 'RH Contractor Labor Sub-Totals')])[2]/following-sibling::td[8]/span
    ${Cost_UI}=     Get Text        (//td[contains(normalize-space(.), 'RH Contractor Labor Sub-Totals')])[2]/following-sibling::td[9]/span
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Get Text        (//td[contains(normalize-space(.), 'RH Contractor Labor Sub-Totals')])[2]/following-sibling::td[10]/span
    ${CM%_UI}=      Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Get Text        (//td[contains(normalize-space(.), 'RH Contractor Labor Sub-Totals')])[2]/following-sibling::td[11]/span
    ${CM%}=      Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'          Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=         Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       RHCLabor_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       RHCLabor_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       RHCLabor_EACBillings      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       RHCLabor_CM%      ${CM%}

Calculate & Verify Sub-Total IH Contractor Labor
    [Documentation]
    ${QTY_Total}=       Evaluate        &{Labor_dict}[IHC_Non_Exception_QTY]+&{Labor_dict}[IH_CR_Exception_QTY]
    ${Cost_Total}=      Evaluate        &{Labor_dict}[IHC_Non_Exception_Cost]+&{Labor_dict}[IH_CR_Exception_Cost]
    ${Billings_Total}=      Evaluate        &{Labor_dict}[IHC_Non_Exception_Billing]+&{Labor_dict}[IH_CR_Exception_Billing]
    #${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${Status}=     Run Keyword And Return Status       Element Should Be Visible       //b[text()= ' Independent Contractor Labor']/a[text()= '+']
    Run Keyword If      '${Status}'=='True'       Click Element        //b[text()= ' Independent Contractor Labor']/a[text()= '+']
    ${EACQTY_UI}=       Get Text        (//td[contains(normalize-space(.), 'Independent Contractor Labor Sub-Totals')])[2]/following-sibling::td[8]/span
    ${Cost_UI}=     Get Text        (//td[contains(normalize-space(.), 'Independent Contractor Labor Sub-Totals')])[2]/following-sibling::td[9]/span
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Get Text        (//td[contains(normalize-space(.), 'Independent Contractor Labor Sub-Totals')])[2]/following-sibling::td[10]/span
    ${CM%_UI}=      Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Get Text        (//td[contains(normalize-space(.), 'Independent Contractor Labor Sub-Totals')])[2]/following-sibling::td[11]/span
    ${CM%}=         Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'         Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       IHCLabor_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       IHCLabor_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       IHCLabor_EACBillings      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       IHCLabor_CM%      ${CM%}

Calculate & Verify Sub-Total International BU Labor
    [Documentation]
    ${QTY_Total}=       Evaluate        &{Labor_dict}[IBU_Non_Exception_QTY]+&{Labor_dict}[IBU_CR_Exception_QTY]
    ${Cost_Total}=      Evaluate        &{Labor_dict}[IBU_Non_Exception_Cost]+&{Labor_dict}[IBU_CR_Exception_Cost]
    ${Billings_Total}=      Evaluate        &{Labor_dict}[IBU_Non_Exception_Billing]+&{Labor_dict}[IBU_CR_Exception_Billing]
    ${Status}=     Run Keyword And Return Status       Element Should Be Visible        //b[text()= ' International BU']/a[text()= '+']
    Run Keyword If      '${Status}'=='True'       Click Element      //b[text()= ' International BU']/a[text()= '+']
    #${QTY_Total}        ${Cost_Total}       ${Billings_Total}       Calculate Sub-Totals of table      ${QTY_list}     ${Cost_list}        ${Billings_list}
    ${EACQTY_UI}=       Get Text        (//td[contains(normalize-space(.), 'International BU Professional Services')])[2]/following-sibling::td[8]/span
    ${Cost_UI}=     Get Text        (//td[contains(normalize-space(.), 'International BU Professional Services')])[2]/following-sibling::td[9]/span
    ${Billings_UI}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'       Get Text        (//td[contains(normalize-space(.), 'International BU Professional Services')])[2]/following-sibling::td[10]/span
    #${CM%_UI}=     Get Text        (//td[contains(normalize-space(.), 'International BU Professional Services')])[2]/following-sibling::td[11]/span
    #${CM%}=         Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=         Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       IBULabor_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       IBULabor_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       IBULabor_EACBillings      ${Billings_UI}
    #Set To Dictionary      ${iBudget_Calculation}       IBULabor_CM%      ${CM%}

Calculate & Verify Unit/Value-Based Services Total
    [Arguments]     ${EACQTY_List}      ${EACBillings_List}
    ${EACQTY_Total}=     Calculate Sum of Listed items        ${EACQTY_List}
    ${Billings_Total}=     Calculate Sum of Listed items        ${EACBillings_List}
    ${EACQTY_UI}=       Get Text         //tr[@id= 'gvUnitBasedWizard_DXFooterRow']/td[4]
    ${Billing_UI}=       Get Text         //tr[@id= 'gvUnitBasedWizard_DXFooterRow']/td[5]
    ${Billing_UI}=      Remove String       ${Billing_UI}       ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${EACQTY_UI}        ${EACQTY_Total}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billing_UI}        ${Billings_Total}
    Set To Dictionary      ${iBudget_Calculation}       Unit/Val_Services_EACQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       Unit/Val_Services_EACBilling      ${Billing_UI}

Calculate & Verify Adjusted Net Unit/Value-Based fees
    ${Total_Discount}=      Evaluate        &{iBudget_Calculation}[Unit/Val_VolumeDiscount]+&{iBudget_Calculation}[Unit/Val_PlannedInvestment]
    Set To Dictionary       ${iBudget_Calculation}      Unit/Val_Discount&Adjustments       ${Total_Discount}
    ${QTY_Total}=       Evaluate        &{iBudget_Calculation}[Unit/Val_Services_EACQTY]+0.00
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[Unit/Val_Services_EACBilling]+&{iBudget_Calculation}[Unit/Val_Discount&Adjustments]
    ${EACQTY_UI}=       Get Text        //table[@id= 'tblUnitwizardDiscounts']//tr[@class= 'total']/td[2]
    ${Billings_UI}=     Get Text        //table[@id= 'tblUnitwizardDiscounts']//tr[@class= 'total']/td[3]
    ${Billings_UI}=      Remove String       ${Billings_UI}       ,
    ${Adjusted_Billings_UI}=       Get Text        //table[@id= 'tblUnitwizardDiscounts']//tr[@class= 'total'][2]/td[3]
    ${Adjusted_Billings_UI}=      Remove String       ${Adjusted_Billings_UI}       ,
    ${currency}=        Get From Dictionary        ${budget_dict}       Contract Currency
    ${Calculated_Adjusted_Billings}=        Evaluate        ${Billings_UI}/&{cur_rates}[${currency}]
    ${Calculated_Adjusted_Billings}=      Convert To Number       ${Calculated_Adjusted_Billings}       2
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${EACQTY_UI}        ${QTY_Total}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_UI}        ${Billings_Total}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Adjusted_Billings_UI}        ${Calculated_Adjusted_Billings}
    Set To Dictionary      ${iBudget_Calculation}       AdjNet-Unit/Val_EACQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       AdjNet-Unit/Val_EACBilling      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       AdjNet-Unit/Val_EACBilling_ContractCurrency      ${Adjusted_Billings_UI}

Calculate And Verify Net Professional BU/IBU Services on Labor Tab
    Calculate And Verify BU Professional Services
    Calculate And Verify Adjusted Net Professional Fees
    Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'      Calculate And Verify IBU Adjusted Net Professional Fees
    Calculate And Verify Global Net Professional Services

Calculate And Verify BU Professional Services
    ${QTY_Total}=       Evaluate        &{iBudget_Calculation}[EmpLabor_EMPQTY]+&{iBudget_Calculation}[RHCLabor_EMPQTY]+&{iBudget_Calculation}[IHCLabor_EMPQTY]+&{iBudget_Calculation}[MFLabor_EMPQTY]
    ${Cost_Total}=       Evaluate        &{iBudget_Calculation}[EmpLabor_EACCost]+&{iBudget_Calculation}[RHCLabor_EACCost]+&{iBudget_Calculation}[IHCLabor_EACCost]+&{iBudget_Calculation}[MFLabor_EACCost]
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[EmpLabor_EACBillings]+&{iBudget_Calculation}[RHCLabor_EACBillings]+&{iBudget_Calculation}[IHCLabor_EACBillings]+&{iBudget_Calculation}[MFLabor_EACBillings]
    ${EACQTY_UI}=       Get Element Attribute           //div[@id= 'divBUServicesTotals']//tr/td[3]      title
    ${Cost_UI}=         Get Element Attribute           //div[@id= 'divBUServicesTotals']//tr/td[4]      title
    ${Billings_UI}=           Get Element Attribute           //div[@id= 'divBUServicesTotals']//tr/td[5]      title
    ${CM%_UI}=          Get Text           //div[@id= 'divBUServicesTotals']//tr/td[6]
    Log      ${CM%_UI}
    ${CM%}=      Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'         Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=    Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       BUProfServices_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       BUProfServices_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       BUProfServices_EACBillings      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       BUProfServices_CM%      ${CM%}

Calculate And Verify Adjusted Net Professional Fees
    ${QTY_Total}=       Evaluate        &{iBudget_Calculation}[BUProfServices_EMPQTY]-&{iBudget_Calculation}[Non-Billable_Hours]
    ${Cost_Total}=      Set Variable        &{iBudget_Calculation}[BUProfServices_EACCost]
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[BUProfServices_EACBillings]-&{iBudget_Calculation}[BUProfServices_Dis&Adj_EACBillings]
    ${EACQTY_UI}=       Get Element Attribute           //div[@id= 'divBUServicesTotals']//table[@class= 'total']//tr/td[3]      title
    ${Cost_UI}=         Get Element Attribute           //div[@id= 'divBUServicesTotals']//table[@class= 'total']//tr/td[4]      title
    ${Billings_UI}=     Get Element Attribute           //div[@id= 'divBUServicesTotals']//table[@class= 'total']//tr/td[5]      title
    ${CM%_UI}=          Get Text              //div[@id= 'divBUServicesTotals']//table[@class= 'total']//tr/td[6]
    Log      ${CM%_UI}
    ${CM%}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'           Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=     Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       AdjNetProfFees_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       AdjNetProfFees_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       AdjNetProfFees_EACBillings      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       AdjNetProfFees_CM%      ${CM%}

Calculate And Verify IBU Adjusted Net Professional Fees
    ${QTY_Total}=       Set Variable        &{iBudget_Calculation}[IBULabor_EMPQTY]
    ${Cost_Total}=      Set Variable        &{iBudget_Calculation}[IBULabor_EACCost]
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[IBULabor_EACBillings]-&{iBudget_Calculation}[IBUPlannedInvestments]
    ${EACQTY_UI}=       Get Element Attribute           //div[@id= 'divGlobalServicesTotals']//table[@class= 'subtotal']//tr/td[3]      title
    ${Cost_UI}=         Get Element Attribute           //div[@id= 'divGlobalServicesTotals']//table[@class= 'subtotal']//tr/td[4]      title
    ${Billings_UI}=     Get Element Attribute           //div[@id= 'divGlobalServicesTotals']//table[@class= 'subtotal']//tr/td[5]      title
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=     Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       IBUAdjNetProfFees_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       IBUAdjNetProfFees_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       IBUAdjNetProfFees_EACBillings      ${Billings_UI}
    #Set To Dictionary      ${iBudget_Calculation}       AdjNetProfFees_CM%      ${CM%}

Calculate And Verify Global Net Professional Services
    ${QTY_Total}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'
    ...         Get Sum From iBudget Dictionary        AdjNetProfFees_EMPQTY        IBUAdjNetProfFees_EMPQTY
    ...         ELSE
    ...         Get Sum From iBudget Dictionary        AdjNetProfFees_EMPQTY        IBULabor_EMPQTY
    ${Cost_Total}=        Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'
    ...         Get Sum From iBudget Dictionary        AdjNetProfFees_EACCost        IBUAdjNetProfFees_EACCost
    ...         ELSE
    ...         Get Sum From iBudget Dictionary        AdjNetProfFees_EACCost        IBULabor_EACCost
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[AdjNetProfFees_EACBillings]+&{iBudget_Calculation}[IBUAdjNetProfFees_EACBillings]
    ${EACQTY_UI}=       Get Element Attribute           //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[3]      title
    ${Cost_UI}=         Get Element Attribute           //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[4]      title
    ${Billings_UI}=     Get Element Attribute           //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[5]      title
    ${CM%_UI}=          Get Text              //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[6]
    ${CM%}=     Run Keyword If      '${budget_dict["Rate Card Type"]}'!='Unit/Value-Based'           Verify CM percent Calculation      ${Billings_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billings_UI}=     Remove String    ${Billings_UI}    ,
    ${Billings_UI}=     Verify Sub-Totals of table      ${QTY_Total}        ${Cost_Total}       ${Billings_Total}       ${EACQTY_UI}     ${Cost_UI}        ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       GlobalNetProfFees_EMPQTY      ${EACQTY_UI}
    Set To Dictionary      ${iBudget_Calculation}       GlobalNetProfFees_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       GlobalNetProfFees_EACBillings      ${Billings_UI}
    Set To Dictionary      ${iBudget_Calculation}       GlobalNetProfFees_CM%      ${CM%}

Calculate & Verify Sub-Total of Expenses Tab
    [Arguments]     ${BudgetCost_list}        ${BudgetBillings_list}        ${Footer_X-Path}
    ${Cost_Total}=     Calculate Sum of Listed items        ${BudgetCost_list}
    ${Billings_Total}=     Calculate Sum of Listed items        ${BudgetBillings_list}
    ${Cost_UI}=       Get Text         //tr[@id= '${Footer_X-Path}']/td[7]
    ${Billing_UI}=       Get Text         //tr[@id= '${Footer_X-Path}']/td[8]
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Cost_Total}        ${Cost_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_Total}        ${Billing_UI}
    [Return]        ${Cost_UI}      ${Billing_UI}

Calculate And verify Global BU/IBU Expenses on sub-budget
    Calculate & Verify Total BU Expenses
    Calculate & Verify Global Expenses

Calculate & Verify Total BU Expenses
    ${Cost_Total}=       Evaluate        &{iBudget_Calculation}[EmpExpenses_BudgetCost]+&{iBudget_Calculation}[RHCExpenses_BudgetCost]+&{iBudget_Calculation}[IHCExpenses_BudgetCost]+&{iBudget_Calculation}[MFExpenses_BudgetCost]
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[EmpExpenses_BudgetBillings]+&{iBudget_Calculation}[RHCExpenses_BudgetBillings]+&{iBudget_Calculation}[IHCExpenses_BudgetBillings]+&{iBudget_Calculation}[MFExpenses_BudgetBillings]
    ${Cost_UI}=        Get Text      //div[@id= 'divBUSummery']//tr/td[6]
    ${Billing_UI}=       Get Text      //div[@id= 'divBUSummery']//tr/td[7]
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billing_UI}=     Remove String    ${Billing_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Cost_Total}        ${Cost_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_Total}        ${Billing_UI}
    Set To Dictionary      ${iBudget_Calculation}       TotalBUExpenses_BudgetCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       TotalBUExpenses_BudgetBillings      ${Billing_UI}

Calculate & Verify Global Expenses
    ${Cost_Total}=       Evaluate        &{iBudget_Calculation}[TotalBUExpenses_BudgetCost]+&{iBudget_Calculation}[IBUExpenses_BudgetCost]
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[TotalBUExpenses_BudgetBillings]+&{iBudget_Calculation}[IBUExpenses_BudgetBillings]
    ${Cost_UI}=        Get Text      //div[@id= 'divGlobalSummery']//tr/td[6]
    ${Billing_UI}=       Get Text      //div[@id= 'divGlobalSummery']//tr/td[7]
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billing_UI}=     Remove String    ${Billing_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Cost_Total}        ${Cost_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_Total}        ${Billing_UI}
    Set To Dictionary      ${iBudget_Calculation}       GlobalExpenses_BudgetCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       GlobalExpenses_BudgetBillings      ${Billing_UI}

Calculate & Verify Sub-Total of Other Fees Tab
    [Arguments]     ${BudgetCost_list}     ${BudgetBillings_list}
    ${Cost_Total}=     Calculate Sum of Listed items        ${BudgetCost_list}
    ${Billings_Total}=     Calculate Sum of Listed items        ${BudgetBillings_list}
    ${Cost_UI}=       Get Text         //tr[@id= 'otherFeesView_DXFooterRow']/td[3]
    ${Billing_UI}=       Get Text         //tr[@id= 'otherFeesView_DXFooterRow']/td[4]
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billing_UI}=     Remove String    ${Billing_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Cost_Total}        ${Cost_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_Total}        ${Billing_UI}
    Set To Dictionary      ${iBudget_Calculation}       OtherFees&Charges_BudgetCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       OtherFees&Charges_BudgetBillings      ${Billing_UI}

Verify Calculated Net Labor/Expenses Values on Consolidated Tab
    ${GlobalNetProf_EACQTY_UI}=     Get Element Attribute       //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[3]     title
    ${GlobalNetProf_EACCost_UI}=     Get Element Attribute       //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[4]        title
    ${GlobalNetProf_EACBilling_UI}=     Get Element Attribute       //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[5]        title
    ${GlobalNetProf_CM%_UI}=        Get Text        //div[@id= 'divGlobalServicesTotals']//table[@class= 'total']//tr/td[6]
    ${GlobalNetProf_CM%_UI}=       Fetch From Left     ${GlobalNetProf_CM%_UI}      %
    ${GlobalNetProf_EACCost_UI}=     Remove String    ${GlobalNetProf_EACCost_UI}    ,
    ${GlobalNetProf_EACBilling_UI}=     Remove String    ${GlobalNetProf_EACBilling_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetProf_EACQTY_UI}        &{iBudget_Calculation}[GlobalNetProfFees_EMPQTY]
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetProf_EACCost_UI}        &{iBudget_Calculation}[GlobalNetProfFees_EACCost]
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetProf_EACBilling_UI}        &{iBudget_Calculation}[GlobalNetProfFees_EACBillings]
    #Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetProf_CM%_UI}        &{iBudget_Calculation}[GlobalNetProfFees_CM%]
    ${GlobalNetotherFee_Cost_UI}=       Get Text        //table[@id= 'gvConsOtherFee']/following-sibling::table[@class= 'subtotal']//tr/td[4]
    ${GlobalNetotherFee_Billing_UI}=       Get Text        //table[@id= 'gvConsOtherFee']/following-sibling::table[@class= 'subtotal']//tr/td[5]
    ${GlobalNetotherFee_Cost_UI}=     Remove String    ${GlobalNetotherFee_Cost_UI}    ,
    ${GlobalNetotherFee_Billing_UI}=     Remove String    ${GlobalNetotherFee_Billing_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetotherFee_Cost_UI}        &{iBudget_Calculation}[OtherFees&Charges_BudgetCost]
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetotherFee_Billing_UI}        &{iBudget_Calculation}[OtherFees&Charges_BudgetBillings]
    ${GlobalNetExpenses_Cost_UI}=       Get Text        (//table[@id= 'gvConsOtherFee']/following-sibling::table[@class= 'subtotal'])[2]//tr/td[4]
    ${GlobalNetExpenses_Billing_UI}=       Get Text        (//table[@id= 'gvConsOtherFee']/following-sibling::table[@class= 'subtotal'])[2]//tr/td[5]
    ${GlobalNetExpenses_Cost_UI}=     Remove String    ${GlobalNetExpenses_Cost_UI}    ,
    ${GlobalNetExpenses_Billing_UI}=     Remove String    ${GlobalNetExpenses_Billing_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetExpenses_Cost_UI}        &{iBudget_Calculation}[GlobalExpenses_BudgetCost]
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${GlobalNetExpenses_Billing_UI}        &{iBudget_Calculation}[GlobalExpenses_BudgetBillings]

Verify Calculated Unit-Based Wizard on Consolidated Tab
    ${EACQTY_UI}=       Get Text          //table[@class= 'total']//tr/td[contains(normalize-space(.),'Global Net Unit/Value-Based Services')]/following-sibling::td[2]
    ${Discount_UI}=         Get Text          //table[@class= 'subtotal']//tr/td[contains(normalize-space(.),'Unit/Value Based Services Discounts & Adjustments')]/following-sibling::td[4]
    ${Billings_UI}=     Get Text          //table[@class= 'total']//tr/td[contains(normalize-space(.),'Global Net Unit/Value-Based Services')]/following-sibling::td[4]
    ${Billings_UI}=     Remove String    ${Billings_UI}    ,
    ${Discount_UI}=     Remove String    ${Discount_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${EACQTY_UI}        &{iBudget_Calculation}[AdjNet-Unit/Val_EACQTY]
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_UI}        &{iBudget_Calculation}[AdjNet-Unit/Val_EACBilling]
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Discount_UI}        &{iBudget_Calculation}[Unit/Val_Discount&Adjustments]

Calculate And Verify Total Net Fees & Expenses QTC
    ${Cost_Total}=       Evaluate        &{iBudget_Calculation}[GlobalNetProfFees_EACCost]+&{iBudget_Calculation}[OtherFees&Charges_BudgetCost]+&{iBudget_Calculation}[GlobalExpenses_BudgetCost]
    ${Billings_Total}=       Evaluate        &{iBudget_Calculation}[GlobalNetProfFees_EACBillings]+&{iBudget_Calculation}[OtherFees&Charges_BudgetBillings]+&{iBudget_Calculation}[GlobalExpenses_BudgetBillings]+&{iBudget_Calculation}[AdjNet-Unit/Val_EACBilling]
    ${Cost_UI}=        Get Text      //table[@class= 'total']//td[contains(normalize-space(.), 'Total Net Fees & Expenses QTC')]/following-sibling::td[3]
    ${Billing_UI}=       Get Text      //table[@class= 'total']//td[contains(normalize-space(.), 'Total Net Fees & Expenses QTC')]/following-sibling::td[4]
    ${CM%_UI}=          Get Text              //table[@class= 'total']//td[contains(normalize-space(.), 'Total Net Fees & Expenses QTC')]/following-sibling::td[5]
    ${CM%}=         Verify CM percent Calculation      ${Billing_UI}         ${Cost_UI}      ${CM%_UI}
    ${Cost_UI}=     Remove String    ${Cost_UI}    ,
    ${Billing_UI}=     Remove String    ${Billing_UI}    ,
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Cost_Total}        ${Cost_UI}
    Run Keyword And Continue On Failure          Should Be Equal As Numbers      ${Billings_Total}        ${Billing_UI}
    Set To Dictionary      ${iBudget_Calculation}       TotalNetfees&Expenses_EACCost      ${Cost_UI}
    Set To Dictionary      ${iBudget_Calculation}       TotalNetfees&Expenses_EACBillings      ${Billing_UI}
    Set To Dictionary      ${iBudget_Calculation}       TotalNetfees&Expenses_CM%      ${CM%}
    Remove List Data

Remove List Data
    Run Keyword And Continue On Failure         Empty List      ${Emp_CRException_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${Emp_CRException_Costs}
    Run Keyword And Continue On Failure         Empty List      ${Emp_CRException_Billings}
    Run Keyword And Continue On Failure         Empty List      ${RH_CRException_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${RH_CRException_Costs}
    Run Keyword And Continue On Failure         Empty List      ${RH_CRException_Billings}
    Run Keyword And Continue On Failure         Empty List      ${IH_CRException_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${IH_CRException_Costs}
    Run Keyword And Continue On Failure         Empty List      ${IH_CRException_Billings}
    Run Keyword And Continue On Failure         Empty List      ${MFException_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${MFException_Costs}
    Run Keyword And Continue On Failure         Empty List      ${MFException_Billings}
    Run Keyword And Continue On Failure         Empty List      ${IBUException_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${IBUException_Costs}
    Run Keyword And Continue On Failure         Empty List      ${IBUException_Billings}
    Run Keyword And Continue On Failure         Empty List      ${EmpLabor_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${EmpLabor_Costs}
    Run Keyword And Continue On Failure         Empty List      ${EmpLabor_Billings}
    Run Keyword And Continue On Failure         Empty List      ${NonBillable_Hours}
    Run Keyword And Continue On Failure         Empty List      ${RHCLabor_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${RHCLabor_Costs}
    Run Keyword And Continue On Failure         Empty List      ${RHCLabor_Billings}
    Run Keyword And Continue On Failure         Empty List      ${IHCLabor_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${IHCLabor_Costs}
    Run Keyword And Continue On Failure         Empty List      ${IHCLabor_Billings}
    Run Keyword And Continue On Failure         Empty List      ${MFLabor_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${MFLabor_Costs}
    Run Keyword And Continue On Failure         Empty List      ${MFLabor_Billings}
    Run Keyword And Continue On Failure         Empty List      ${IBULabor_EAC_QTY}
    Run Keyword And Continue On Failure         Empty List      ${IBULabor_Costs}
    Run Keyword And Continue On Failure         Empty List      ${IBULabor_Billings}
    Run Keyword And Continue On Failure         Empty List      ${UnitValEACQTY}
    Run Keyword And Continue On Failure         Empty List      ${UnitValEACBillings}

Empty List
    [Arguments]     ${List}
    FOR     ${elem}    IN    @{List}
        Remove values from list    ${List}    ${elem}
    END

#
#......Activation Calculation.....
#

Fetch Consolidated Calculated Values on Activated sub-budget
    [Arguments]      ${iBudget_Calculation}
    Click Element       ${sub-budget Consolidated budget Tab}
    Sleep       3s
    Wait Until Element Is Visible       //h6[text()= 'Employee Labor']      10s
    ${Emp EAC QTY}=       Get Element Attribute        //h6[text()= 'Employee Labor']/ancestor::div[1]/following-sibling::table//tr[@id= 'GridView_DXFooterRow']//td[16]/span          title
    ${Emp EAC Cost}=       Get Element Attribute        //h6[text()= 'Employee Labor']/ancestor::div[1]/following-sibling::table//tr[@id= 'GridView_DXFooterRow']//td[17]/span          title
    ${Emp EAC Billings}=       Get Element Attribute        //h6[text()= 'Employee Labor']/ancestor::div[1]/following-sibling::table//tr[@id= 'GridView_DXFooterRow']//td[18]/span          title
    ${Emp CM%}=       Get Text        //h6[text()= 'Employee Labor']/ancestor::div[1]/following-sibling::table//tr[@id= 'GridView_DXFooterRow']//td[19]/span
    Compare Consolidated Budget Values         ${Emp EAC QTY}       ${Emp EAC Cost}         ${Emp EAC Billings}         ${Emp CM%}      &{iBudget_Calculation["EmpLabor_EMPQTY"]}           &{iBudget_Calculation["EmpLabor_EACCost"]}       &{iBudget_Calculation["EmpLabor_EACBillings"]}       &{iBudget_Calculation["EmpLabor_CM%"]}
    ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}        Get UI Consolidated Budget Values         RH Contractor Labor           GridView1_DXFooterRow
    Compare Consolidated Budget Values         ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}      &{iBudget_Calculation["RHCLabor_EMPQTY"]}           &{iBudget_Calculation["RHCLabor_EACCost"]}       &{iBudget_Calculation["RHCLabor_EACBillings"]}       &{iBudget_Calculation["RHCLabor_CM%"]}
    ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}        Get UI Consolidated Budget Values         Independent Contractor Labor           gvIndenpendentContrLabor_DXFooterRow
    Compare Consolidated Budget Values         ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}      &{iBudget_Calculation["IHCLabor_EMPQTY"]}           &{iBudget_Calculation["IHCLabor_EACCost"]}       &{iBudget_Calculation["IHCLabor_EACBillings"]}       &{iBudget_Calculation["IHCLabor_CM%"]}
    ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}        Get UI Consolidated Budget Values         Member Firm Labor           gvMemberFirmLabor_DXFooterRow
    Compare Consolidated Budget Values         ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}      &{iBudget_Calculation["MFLabor_EMPQTY"]}           &{iBudget_Calculation["MFLabor_EACCost"]}       &{iBudget_Calculation["MFLabor_EACBillings"]}       &{iBudget_Calculation["MFLabor_CM%"]}
    ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}        Get UI Consolidated Budget Values         International BU           gvInternationalBU_DXFooterRow
    Compare Consolidated Budget Values         ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}      &{iBudget_Calculation["IBULabor_EMPQTY"]}           &{iBudget_Calculation["IBULabor_EACCost"]}       &{iBudget_Calculation["IBULabor_EACBillings"]}       &{iBudget_Calculation["IBULabor_CM%"]}
    ${Global EAC QTY}=       Get Element Attribute        //table[@class= 'tblbuservices total']//td[12]          title
    ${Global EAC Cost}=       Get Element Attribute        //table[@class= 'tblbuservices total']//td[13]          title
    ${Global EAC Billings}=       Get Element Attribute        //table[@class= 'tblbuservices total']//td[14]          title
    ${Global CM%}=       Get Text        //table[@class= 'tblbuservices total']//td[15]
    Compare Consolidated Budget Values         ${Global EAC QTY}      ${Global EAC Cost}      ${Global EAC Billings}      ${Global CM%}      &{iBudget_Calculation["GlobalNetProfFees_EMPQTY"]}           &{iBudget_Calculation["GlobalNetProfFees_EACCost"]}       &{iBudget_Calculation["GlobalNetProfFees_EACBillings"]}       &{iBudget_Calculation["GlobalNetProfFees_CM%"]}

Get UI Consolidated Budget Values
    [Arguments]         ${Header}       ${Footer_Path}
    ${QTY_UI}=      Get Element Attribute       //h6[text()= '${Header}']/ancestor::div[1]/following-sibling::table//tr[@id= '${Footer_Path}']//td[17]/span     title
    ${Cost_UI}=      Get Element Attribute       //h6[text()= '${Header}']/ancestor::div[1]/following-sibling::table//tr[@id= '${Footer_Path}']//td[18]/span     title
    ${Billings_UI}=      Get Element Attribute       //h6[text()= '${Header}']/ancestor::div[1]/following-sibling::table//tr[@id= '${Footer_Path}']//td[19]/span     title
    ${CM%_UI}=      Get Text       //h6[text()= '${Header}']/ancestor::div[1]/following-sibling::table//tr[@id= '${Footer_Path}']//td[20]/span
    [Return]        ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}

Compare Consolidated Budget Values
    [Arguments]      ${QTY_UI}      ${Cost_UI}      ${Billings_UI}      ${CM%_UI}       ${EAC_QTY}      ${EAC_Cost}     ${EAC_Billings}     ${CM%}
    Run Keyword And Continue On Failure      Should Be Equal As Numbers         ${QTY_UI}       ${EAC_QTY}
    Run Keyword And Continue On Failure      Should Be Equal As Numbers         ${Cost_UI}       ${EAC_Cost}
    Run Keyword And Continue On Failure      Should Be Equal As Numbers         ${Billings_UI}       ${EAC_Billings}
    Run Keyword And Continue On Failure      Should Be Equal As Numbers         ${CM%_UI}       ${CM%}

#
#.......Re-estimation Calculations.........
#

Fetch Calculated Employee Labor Exception Data and allign in DataFrame
    [Documentation]
    [Arguments]      ${Name}        ${Rate}      ${ETC_QTY}      ${Key}      ${new_row}         ${Existing_Rate_ETC_QTY}
    Run Keyword And Ignore Error       Click Element       ${Re-estimation Collapse ETC/EAC}
    ${EAC Cost}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[11]
    ${EAC Billings}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[12]
    ${CM%}=      Get Text         //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[13]
    ${QTY Variance}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[14]
    ${Cost Variance}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[15]
    ${Billings Variance}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[16]
    ${LAB QTY}=         Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[1]
    ${LAB Cost}=        Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[2]
    ${LAB Billings}=       Get Text     //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[3]
    ${CR_job}=      Get Text        //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td/div
    ${CR_job}=      Get Substring      ${CR_job}      0     3
    ${Department_Name}=     Get Text         //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[2]/div
    ${OP_Unit}=     Get Text         //table[@id= 'GridView_DXMainTable']//td[@title='${Name}']/following-sibling::td[3]/div
    ${OP_Unit}=     Get Substring      ${OP_Unit}      0     3
    ${CostRate_dict}=       Get Cost Rates      ${Department_Name}      ${OP_Unit}
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${new_row}=       Run Keyword If      '${new_row}'=='True'        Add New Exception Row & Set Values in DataFrame     ${Key}      &{CostRate_dict}[${CR_job}]       ${Rate}       ${Existing_Rate_ETC_QTY}      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     Employee Labor
    ...         ELSE        Update Estimated Row & Set Values in DataFrame      ${Key}      &{CostRate_dict}[${CR_job}]     ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     Employee Labor
    [Return]        ${new_row}

Fetch Calculated RH Contractor Labor Exception Data and allign in DataFrame
    [Arguments]     ${Name}        ${Rate}     ${Pay_rate}      ${ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    Run Keyword And Ignore Error       Click Element       ${Re-estimation Collapse ETC/EAC}
    ${EAC Cost}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[4]
    ${RH BU/LOB}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[11]
    ${BurdenCurrency_dict}      ${BurdenRate_dict}       Get Burden Rates
    ${Cost_Rate}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[8]
    ${Cost_Rate}=       Verify Cost Rate Calculation For Rh Contractor        ${Pay_rate}       ${Cost_Rate}        &{BurdenRate_dict}[${RH BU/LOB}]      &{BurdenCurrency_dict}[${RH BU/LOB}]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${new_row}=       Run Keyword If      '${new_row}'=='True'        Add New Exception Row & Set Values in DataFrame     ${Key}      ${Cost_Rate}       ${Rate}       ${Existing_Rate_ETC_QTY}      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        RHC Labor
    ...         ELSE        Update Estimated Row & Set Values in DataFrame      ${Key}      ${Cost_Rate}     ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        RHC Labor
    [Return]        ${new_row}

Fetch Calculated Independent Contractor Labor Exception Data and allign in DataFrame
    [Arguments]     ${Name}        ${Rate}     ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    Run Keyword And Ignore Error       Click Element       ${Re-estimation Collapse ETC/EAC}
    ${EAC Cost}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[4]
    ${Cost_Rate}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[text()= '${Pay_rate}']/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[8]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Pay_rate_currency}        ${Cost_Rate}
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${new_row}=       Run Keyword If      '${new_row}'=='True'        Add New Exception Row & Set Values in DataFrame     ${Key}      ${Calculated_Cost_Rate}       ${Rate}       ${Existing_Rate_ETC_QTY}      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     IHC Labor
    ...         ELSE        Update Estimated Row & Set Values in DataFrame      ${Key}      ${Calculated_Cost_Rate}     ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     IHC Labor
    [Return]        ${new_row}

Fetch Calculated IBU Labor Exception Data and allign in DataFrame
    [Arguments]     ${Name}        ${Rate}     ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}      ${Key}       ${new_row}     ${Existing_Rate_ETC_QTY}
    ${EAC Cost}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[4]
    ${Cost_Rate}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[8]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Pay_rate_currency}        ${Cost_Rate}
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${new_row}=       Run Keyword If      '${new_row}'=='True'        Add New Exception Row & Set Values in DataFrame     ${Key}      ${Calculated_Cost_Rate}       ${Rate}       ${Existing_Rate_ETC_QTY}      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     IBU Labor
    ...         ELSE        Update Estimated Row & Set Values in DataFrame      ${Key}      ${Calculated_Cost_Rate}     ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     IBU Labor
    [Return]        ${new_row}

Fetch Calculated Member Firm Labor Exception Data and allign in DataFrame
    [Arguments]     ${Name}        ${Rate}       ${Pay_rate}        ${Pay_rate_currency}       ${ETC_QTY}      ${Key}         ${new_row}     ${Existing_Rate_ETC_QTY}
    ${EAC Cost}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[4]
    ${Cost_Rate}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[contains(normalize-space(.), '${Pay_rate}')]/following-sibling::td[text()= '${Rate}']/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[8]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Pay_rate_currency}        ${Cost_Rate}
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${new_row}=       Run Keyword If      '${new_row}'=='True'        Add New Exception Row & Set Values in DataFrame     ${Key}      ${Calculated_Cost_Rate}       ${Rate}       ${Existing_Rate_ETC_QTY}      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     MF Labor
    ...         ELSE        Update Estimated Row & Set Values in DataFrame      ${Key}      ${Calculated_Cost_Rate}     ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     MF Labor
    [Return]        ${new_row}

Fetch Calculated Employee Labor Details and allign in DataFrame
     [Arguments]        ${Name}     ${Job_Function}     ${Department}     ${OP_Unit}     ${Task}     ${ETC_QTY}     ${key}
     ${Job}=        Get Element Attribute       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]       title
     ${CR_job}=      Get Substring      ${Job_Function}      0     3
     ${OP_Unit}=     Get Substring      ${OP_Unit}      0     3
     ${EAC Cost}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[4]
     ${EAC Billings}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[5]
     ${CM%}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[6]
     ${QTY Variance}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[7]
     ${Cost Variance}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[8]
     ${Billings Variance}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[9]
     ${LAB QTY}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/preceding-sibling::td[6]
     ${LAB Cost}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/preceding-sibling::td[5]
     ${LAB Billings}=        Get Text       //table[@id= 'GridView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${Department}']/following-sibling::td[contains(normalize-space(.),'${OP_Unit}')]/following-sibling::td[contains(normalize-space(.),'${Task}')]/following-sibling::td[@title= '${ETC_QTY}']/preceding-sibling::td[4]
     ${CostRate_dict}=       Get Cost Rates      ${Department}      ${OP_Unit}
     ${Job}=        Run Keyword If     '${Task}'=='Non-Billable'        Set Variable        ${Task}
     ...            ELSE        Set Variable        ${Job}
     ${Contract_rate}=      Run Keyword If          '&{Last_Approved_dict["Rate Card Type "]}'!='Unit/Value-Based'       Set Variable        &{Revised_ContractRate_dict}[${Job}]
     ...            ELSE        Set Variable        0
     ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
     Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      &{CostRate_dict}[${CR_job}]      ${Contract_rate}        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       Employee Labor

Fetch Calculated RH Contractor Labor Details and allign in DataFrame
    [Arguments]     ${Name}      ${Job_Function}        ${RH/LOB}       ${Pay_Rate}     ${ETC_QTY}      ${key}
    ${Job}=        Get Element Attribute       //table[@id= 'GridView1_DXMainTable']//td[@title= '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]       title
    ${EAC Cost}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/preceding-sibling::td[4]
    ${BurdenCurrency_dict}      ${BurdenRate_dict}       Get Burden Rates
    ${Cost_Rate}=       Get Text        //table[@id= 'GridView1_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[@title= '${RH/LOB}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[@title= '${ETC_QTY}']/preceding-sibling::td[8]
    ${Cost_Rate}=       Verify Cost Rate Calculation For Rh Contractor        ${Pay_rate}       ${Cost_Rate}        &{BurdenRate_dict}[${RH/LOB}]      &{BurdenCurrency_dict}[${RH/LOB}]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${Contract_rate}=      Run Keyword If          '&{Last_Approved_dict["Rate Card Type "]}'!='Unit/Value-Based'       Set Variable        &{Revised_ContractRate_dict}[${Job}]
    ...            ELSE        Set Variable        0
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      ${Cost_Rate}      ${Contract_rate}        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       RHC Labor

Fetch Calculated IH Contractor Labor Details and allign in DataFrame
    [Arguments]      ${Name}      ${Job_Function}        ${Pay_Rate}       ${Currency}     ${ETC_QTY}      ${key}
    ${Job}=        Get Element Attribute       //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]       title
    ${EAC Cost}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[4]
    ${Cost_Rate}=        Get Text        //table[@id= 'gvIndenpendentContrLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[8]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Currency}        ${Cost_Rate}
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${Contract_rate}=      Run Keyword If          '&{Last_Approved_dict["Rate Card Type "]}'!='Unit/Value-Based'       Set Variable        &{Revised_ContractRate_dict}[${Job}]
    ...            ELSE        Set Variable        0
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      ${Cost_Rate}      ${Contract_rate}        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       IHC Labor

Fetch Calculated Member Firm Labor Details and allign in DataFrame
    [Arguments]     ${Name}      ${Job_Function}        ${Pay_Rate}       ${Currency}     ${ETC_QTY}      ${key}
    ${Job}=        Get Element Attribute       //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title= '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]       title
    ${EAC Cost}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[4]
    ${Cost_Rate}=        Get Text        //table[@id= 'gvMemberFirmLabor_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[8]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Currency}        ${Cost_Rate}
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${Contract_rate}=      Run Keyword If          '&{Last_Approved_dict["Rate Card Type "]}'!='Unit/Value-Based'       Set Variable        &{Revised_ContractRate_dict}[${Job}]
    ...            ELSE        Set Variable        0
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      ${Cost_Rate}      ${Contract_rate}        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       MF Labor

Fetch Calculated IBU Labor Details and allign in DataFrame
    [Arguments]      ${Name}      ${Job_Function}        ${Pay_Rate}       ${Currency}     ${ETC_QTY}      ${key}
    ${Job}=        Get Element Attribute       //table[@id= 'gvInternationalBU_DXMainTable']//td[@title= '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]       title
    ${EAC Cost}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[4]
    ${EAC Billings}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[5]
    ${CM%}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[6]
    ${QTY Variance}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[7]
    ${Cost Variance}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[8]
    ${Billings Variance}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/following-sibling::td[9]
    ${LAB QTY}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[6]
    ${LAB Cost}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[5]
    ${LAB Billings}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[4]
    ${Cost_Rate}=        Get Text        //table[@id= 'gvInternationalBU_DXMainTable']//td[@title='${Name}']/following-sibling::td[@title= '${Job}']/following-sibling::td[contains(normalize-space(.), '${Pay_Rate}')]/following-sibling::td[contains(normalize-space(.), '${ETC_QTY}')]/preceding-sibling::td[8]
    ${Calculated_Cost_Rate}=        Verify Cost Rate Calculation        ${Pay_rate}         ${Currency}        ${Cost_Rate}
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${Contract_rate}=      Run Keyword If          '&{Last_Approved_dict["Rate Card Type "]}'!='Unit/Value-Based'       Set Variable        &{Revised_ContractRate_dict}[${Job}]
    ...            ELSE        Set Variable        0
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      ${Cost_Rate}      ${Contract_rate}        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       IBU Labor

Fetch Calculated Employee Expenses Details and allign in DataFrame
     [Arguments]        ${Name}     ${Job_Function}     ${Department}     ${OP_Unit}      ${ETC Cost}     ${ETC Billings}     ${key}
     ${EAC Cost}=       Get Text        //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[contains(normalize-space(.), '${Department}')]/following-sibling::td[contains(normalize-space(.), '${OP_Unit}')]/following-sibling::td[8]
     ${EAC Billings}=       Get Text        //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[contains(normalize-space(.), '${Department}')]/following-sibling::td[contains(normalize-space(.), '${OP_Unit}')]/following-sibling::td[9]
     ${Cost Variance}=       Get Text        //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[contains(normalize-space(.), '${Department}')]/following-sibling::td[contains(normalize-space(.), '${OP_Unit}')]/following-sibling::td[10]
     ${Billings Variance}=       Get Text        //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[contains(normalize-space(.), '${Department}')]/following-sibling::td[contains(normalize-space(.), '${OP_Unit}')]/following-sibling::td[11]
     ${LAB Cost}=       Get Text        //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[contains(normalize-space(.), '${Department}')]/following-sibling::td[contains(normalize-space(.), '${OP_Unit}')]/following-sibling::td[2]
     ${LAB Billings}=       Get Text        //table[@id= 'EmpExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[contains(normalize-space(.), '${Department}')]/following-sibling::td[contains(normalize-space(.), '${OP_Unit}')]/following-sibling::td[3]
     ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        0.00       0.00        ${Cost Variance}        ${Billings Variance}     0.00      ${LAB Cost}     ${LAB Billings}
     Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      0.00      0.00        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}      Employee Expense

Fetch Calculated RH Contractor Expenses Details and allign in DataFrame
    [Arguments]       ${Name}      ${Job_Function}       ${ETC Cost}     ${ETC Billings}     ${key}
    ${EAC Cost}=       Get Text        //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[10]
    ${EAC Billings}=       Get Text        //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[11]
    ${Cost Variance}=       Get Text        //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[12]
    ${Billings Variance}=       Get Text        //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[13]
    ${LAB Cost}=       Get Text        //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[4]
    ${LAB Billings}=       Get Text        //table[@id= 'RhExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[5]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        0.00       0.00        ${Cost Variance}        ${Billings Variance}     0.00      ${LAB Cost}     ${LAB Billings}
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      0.00      0.00        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       RHC Expense

Fetch Calculated IH Contractor Expenses Details and allign in DataFrame
    [Arguments]      ${Name}      ${Job_Function}       ${ETC Cost}     ${ETC Billings}     ${key}
    ${EAC Cost}=       Get Text        //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[10]
    ${EAC Billings}=       Get Text        //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[11]
    ${Cost Variance}=       Get Text        //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[12]
    ${Billings Variance}=       Get Text        //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[13]
    ${LAB Cost}=       Get Text        //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[4]
    ${LAB Billings}=       Get Text        //table[@id= 'IndExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[5]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        0.00       0.00        ${Cost Variance}        ${Billings Variance}     0.00      ${LAB Cost}     ${LAB Billings}
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      0.00      0.00        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       IHC Expense

Fetch Calculated Member Firm Expenses Details and allign in DataFrame
    [Arguments]      ${Name}      ${Job_Function}       ${ETC Cost}     ${ETC Billings}     ${key}
    ${EAC Cost}=       Get Text        //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[10]
    ${EAC Billings}=       Get Text        //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[11]
    ${Cost Variance}=       Get Text        //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[12]
    ${Billings Variance}=       Get Text        //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[13]
    ${LAB Cost}=       Get Text        //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[4]
    ${LAB Billings}=       Get Text        //table[@id= 'MemExpGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[5]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        0.00       0.00        ${Cost Variance}        ${Billings Variance}     0.00      ${LAB Cost}     ${LAB Billings}
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      0.00      0.00        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       MF Expense

Fetch Calculated International BU Expenses Details and allign in DataFrame
    [Arguments]      ${Name}      ${Job_Function}       ${ETC Cost}     ${ETC Billings}     ${key}
    ${EAC Cost}=       Get Text        //table[@id= 'IntGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[10]
    ${EAC Billings}=       Get Text        //table[@id= 'IntGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[11]
    ${Cost Variance}=       Get Text        //table[@id= 'IntGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[12]
    ${Billings Variance}=       Get Text        //table[@id= 'IntGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[13]
    ${LAB Cost}=       Get Text        //table[@id= 'IntGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[4]
    ${LAB Billings}=       Get Text        //table[@id= 'IntGridView_DXMainTable']//td[@title = '${Name}']/following-sibling::td[contains(normalize-space(.), '${Job_Function}')]/following-sibling::td[5]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        0.00       0.00        ${Cost Variance}        ${Billings Variance}     0.00      ${LAB Cost}     ${LAB Billings}
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      0.00      0.00        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       IBU Expense

Fetch Calculated Other Fees & Charges Details and allign in DataFrame
    [Arguments]     ${Name}         ${ETC Cost}     ${ETC Billings}     ${key}
    ${EAC Cost}     Get Text        //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[7]
    ${EAC Billings}=       Get Text        //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[8]
    ${Cost Variance}=       Get Text        //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[9]
    ${Billings Variance}=       Get Text        //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[10]
    ${LAB Cost}=       Get Text        //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[1]
    ${LAB Billings}=       Get Text        //table[@id= 'otherFeesView_DXMainTable']//td[@title= '${Name}']/following-sibling::td[2]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        ${EAC Cost}      ${EAC Billings}        0.00       0.00        ${Cost Variance}        ${Billings Variance}     0.00      ${LAB Cost}     ${LAB Billings}
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      0.00      0.00        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       Other Fees

Fetch Calculated Unit-Value Based Data & assign in DataFrame
    [Arguments]      ${Name}        ${Contract_Rate}        ${EAC_QTY}      ${Key}
    ${EAC Billings}=        Get Text        //table[@id= 'gvUnitBasedWizard']//td[text()= '${Name}']/following-sibling::td[9]
    ${QTY Variance}=        Get Text        //table[@id= 'gvUnitBasedWizard']//td[text()= '${Name}']/following-sibling::td[10]
    ${Billings Variance}=        Get Text        //table[@id= 'gvUnitBasedWizard']//td[text()= '${Name}']/following-sibling::td[11]
    ${LAB QTY}=        Get Text        //table[@id= 'gvUnitBasedWizard']//td[text()= '${Name}']/following-sibling::td[2]
    ${LAB Billings}=        Get Text        //table[@id= 'gvUnitBasedWizard']//td[text()= '${Name}']/following-sibling::td[3]
    ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        Arange String to Numeric        0.00      ${EAC Billings}        0.00       ${QTY Variance}        0.00        ${Billings Variance}     ${LAB QTY}      0.00     ${LAB Billings}
    Update Estimated Row Contract Rates & Set Values in DataFrame      ${key}      0.00      ${Contract_Rate}        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       Unit-Value

Add New Exception Row & Set Values in DataFrame
    [Arguments]      ${Key}      ${Cost_rate}        ${Contract_Rate}        ${Existing_Rate_ETC_QTY}     ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}       ${type}
    ${Row}=        Get Row Data From CSV       ${ibudget resource data}        ${Key}
    ${index}=       iBudgetCalculations.addnewindex       ${Key}.old      ${Row[1:]}
    ${dataframe}=       iBudgetCalculations.add_rate        ${Key}.old      ${Cost_rate}        ${type}
    ${dataframe}=       iBudgetCalculations.update_oldrate      ${Key}.old      ${Contract_Rate}      ${Existing_Rate_ETC_QTY}
    ${dataframe}=       iBudgetCalculations.set_calculated_values       ${Key}.old      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    Log         ${dataframe}
    Append To List      ${Resource_List}        ${Key}.old
    Log     ${Resource_List}
    [Return]        False

Update Estimated Row & Set Values in DataFrame
    [Arguments]     ${Key}      ${rate}     ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}     ${type}
    ${dataframe}=       iBudgetCalculations.add_rate        ${Key}      ${rate}     ${type}
    ${dataframe}=       iBudgetCalculations.set_calculated_values       ${Key}      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    Log         ${dataframe}
    Append To List      ${Resource_List}        ${Key}
    Log     ${Resource_List}
    [Return]        False

Update Estimated Row Contract Rates & Set Values in DataFrame
    [Arguments]     ${key}      ${rate}     ${Contract_Rate}        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}     ${LAB QTY}      ${LAB Cost}     ${LAB Billings}        ${type}
    ${dataframe}=       iBudgetCalculations.add_rate        ${Key}      ${rate}     ${type}
    ${dataframe}=       iBudgetCalculations.addContractRate      ${Key}      ${Contract_Rate}
    ${dataframe}=       iBudgetCalculations.set_calculated_values       ${Key}      ${EAC Cost}     ${EAC Billings}     ${CM%}      ${QTY Variance}     ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    Log         ${dataframe}
    Append To List      ${Resource_List}        ${Key}
    Log     ${Resource_List}

Arange String to Numeric
    [Arguments]     ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}
    ${EAC Cost}=     Remove String    ${EAC Cost}    ,
    ${EAC Billings}=     Remove String    ${EAC Billings}    ,
    ${CM%}=     Remove String    ${CM%}    %
    ${QTY Variance}=     Remove String    ${QTY Variance}    ,
    ${Cost Variance}=     Remove String    ${Cost Variance}    ,
    ${Billings Variance}=     Remove String    ${Billings Variance}    ,
    ${LAB QTY}=       Remove String       ${LAB QTY}      ,
    ${LAB QTY}=      Run Keyword If      '${LAB QTY}'=='' or '${LAB QTY}'==' '        Set Variable        0
    ...         ELSE        Set Variable        ${LAB QTY}
    ${LAB Cost}=      Remove String       ${LAB Cost}     ,
    ${LAB Cost}=      Run Keyword If      '${LAB Cost}'=='' or '${LAB Cost}'==' '       Set Variable        0
    ...         ELSE        Set Variable        ${LAB Cost}
    ${LAB Billings}=      Remove String       ${LAB Billings}     ,
    ${LAB Billings}=      Run Keyword If      '${LAB Billings}'=='' or '${LAB Billings}'==' '       Set Variable        0
    ...         ELSE        Set Variable        ${LAB Billings}
    [Return]        ${EAC Cost}      ${EAC Billings}        ${CM%}       ${QTY Variance}        ${Cost Variance}        ${Billings Variance}        ${LAB QTY}      ${LAB Cost}     ${LAB Billings}



