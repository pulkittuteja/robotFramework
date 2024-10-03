import pandas as pd
import os


df1 = pd.read_csv("Data/Sub-Budget Resource-Data.csv")
decimals = 2


def create_dataframe():
    #df1 = pd.read_csv("Data/Sub-Budget Resource-Data.csv")
    global df1
    df1.set_index('Data', inplace=True)
    return df1
    #df1.loc['Contract Rate Card Exceptions2', 'ETC Cost'] = qty
    #headers = ['Cost_Rate', 'ETC_QTY', 'Costs', 'Billings', 'CM%']
    #data = [[340, 45, 4500, 1800, 64], [430, 90, 5600, 4700, 39]]
    #index = ['Resource1', 'Resource2']
    #df = pd.DataFrame(data, index, headers)
    #if not os.path.isfile('filename.csv'):
    #df1.to_csv('filename.csv', header=df1.columns)
    #return df1.columns, df1.loc['Contract Rate Card Exceptions2']
    #else:  # else it exists so append without writing the header
    #    df.to_csv('filename.csv', mode='a', header=False)
    #    return df, df.iloc[1]


def set_calculated_values(resourcename, cost, billings, cm, qty_var, cost_var, billings_var,LAB_QTY,LAB_Cost,LAB_Billings):
    df1.loc[resourcename, 'ETC Cost'] = cost
    df1.loc[resourcename, 'ETC Billings'] = billings
    df1.loc[resourcename, 'CM%'] = cm
    df1.loc[resourcename, 'QTY Variance'] = qty_var
    df1.loc[resourcename, 'Cost Variance'] = cost_var
    df1.loc[resourcename, 'Billings Variance'] = billings_var
    df1.loc[resourcename, 'LAB QTY'] = LAB_QTY
    df1.loc[resourcename, 'LAB Cost'] = LAB_Cost
    df1.loc[resourcename, 'LAB Billings'] = LAB_Billings
    return df1


def add_rate(resourcename, rate, type):
    df1.loc[resourcename, 'Pay Rate'] = rate
    df1.loc[resourcename, 'RE Type'] = type
    return df1


def addContractRate(resourcename, Contract_Rate):
    df1.loc[resourcename, 'Contract Rate'] = Contract_Rate
    return df1


def update_oldrate(resourcename, rate, eac_qty):
    df1.loc[resourcename, 'Contract Rate'] = rate
    df1.loc[resourcename, 'EAC QTY'] = eac_qty
    return df1


def dataframe_tocsv(filename):
    df1.to_csv(filename, header=df1.columns)
    return True


def remove_unwanted(resource_list):
    for inde in df1.index:
        if inde not in resource_list:
            df1.drop(inde, inplace=True)
        else:
            continue
    df1.drop('Existing_Rate_ETC_QTY', inplace=True, axis=1)
    return df1.index


def replaceNan():
    df1['EAC QTY'].fillna(value=0, inplace=True)
    df1['ETC Cost'].fillna(value=0, inplace= True)
    df1['ETC Billings'].fillna(value=0, inplace= True)
    df1['CM%'].fillna(value=0, inplace= True)
    df1['QTY Variance'].fillna(value=0, inplace= True)
    df1['Cost Variance'].fillna(value=0, inplace= True)
    df1['Billings Variance'].fillna(value=0, inplace= True)
    df1['LAB QTY'].fillna(value=0, inplace= True)
    df1['LAB Cost'].fillna(value=0, inplace= True)
    df1['LAB Billings'].fillna(value=0, inplace= True)
    return df1['EAC QTY']


def addnewindex(key, rate_list):
    print(key)
    df1.loc[key] = rate_list
    return df1.index, df1


def calculate_values():
    df1['Pay Rate'] = pd.to_numeric(df1['Pay Rate'], downcast='float', errors='coerce').fillna(0)
    df1['EAC QTY'] = pd.to_numeric(df1['EAC QTY'], downcast='float', errors='coerce').fillna(0)
    df1['Contract Rate'] = pd.to_numeric(df1['Contract Rate'], downcast='float', errors='coerce').fillna(0)
    df1['ETC Cost'] = pd.to_numeric(df1['ETC Cost'], downcast='float', errors='coerce').fillna(0)
    df1['ETC Billings'] = pd.to_numeric(df1['ETC Billings'], downcast='float', errors='coerce').fillna(0)
    df1['CM%'] = pd.to_numeric(df1['CM%'], downcast='float', errors='coerce').fillna(0)
    df1['CM%'] = df1['CM%'].apply(lambda x: round(x, decimals))
    df1['LAB QTY'] = pd.to_numeric(df1['LAB QTY'], downcast='float', errors='coerce').fillna(0)
    df1['LAB Cost'] = pd.to_numeric(df1['LAB Cost'], downcast='float', errors='coerce').fillna(0)
    df1['LAB Billings'] = pd.to_numeric(df1['LAB Billings'], downcast='float',errors='coerce').fillna(0)
    df1['QTY Variance'] = pd.to_numeric(df1['QTY Variance'], downcast='float', errors='coerce').fillna(0)
    df1['Cost Variance'] = pd.to_numeric(df1['Cost Variance'], downcast='float', errors='coerce').fillna(0)
    df1['Billings Variance'] = pd.to_numeric(df1['Billings Variance'], downcast='float', errors='coerce').fillna(0)
    print(df1['EAC QTY'])
    print(df1['Pay Rate'])
    df1.loc[df1['EAC QTY'] != '' , 'Calculated ETC Cost'] = df1['Pay Rate'] * df1['EAC QTY']
    df1.loc[df1['EAC QTY'] == 0.0 , 'Calculated ETC Cost'] = df1['Budget Cost']
    df1.loc[df1['EAC QTY'] != '', 'Calculated ETC Billings'] = df1['Contract Rate'] * df1['EAC QTY']
    df1.loc[df1['EAC QTY'] == 0.0, 'Calculated ETC Billings'] = df1['Budget Billings']
    df1.loc[df1['EAC QTY'] != '', 'Calculated CM%'] = ((df1['Calculated ETC Billings']-df1['Calculated ETC Cost'])/df1['Calculated ETC Billings'])*100
    df1.loc[df1['EAC QTY'] == 0.0, 'Calculated CM%'] = 0
    df1['Calculated CM%'] = df1['Calculated CM%'].apply(lambda x: round(x, decimals))
    df1['Calculated QTY Variance'] = df1['EAC QTY'] - df1['LAB QTY']
    df1['Calculated Cost Variance'] = df1['Calculated ETC Cost'] - df1['LAB Cost']
    df1['Calculated Billings Variance'] = df1['Calculated ETC Billings'] - df1['LAB Billings']
    return df1


def validate_calculations():
    df1['verify_ETC_cost'] = df1['ETC Cost'].astype(float) == df1['Calculated ETC Cost'].astype(float)
    df1['verify_ETC_billings'] = df1['ETC Billings'].astype(float) == df1['Calculated ETC Billings'].astype(float)
    df1['verify_CM%'] = df1['CM%'].astype(float) == df1['Calculated CM%'].astype(float)
    df1['verify_QTY_Variance'] = df1['QTY Variance'].astype(float) == df1['Calculated QTY Variance'].astype(float)
    df1['verify_Cost_Variance'] = df1['Cost Variance'].astype(float) == df1['Calculated Cost Variance'].astype(float)
    df1['verify_Billings_Variance'] = df1['Billings Variance'].astype(float) == df1['Calculated Billings Variance'].astype(float)
    return df1


def validate_calculations1():
    for val in df1.index:
        print(df1.loc[val]['ETC Cost'])
        print(df1.loc[val]['Calculated ETC Cost'])
        if df1.loc[val]['ETC Cost'] == df1.loc[val]['Calculated ETC Cost']:
            df1['verify_ETC_cost'] = True
        else:
            df1['verify_ETC_cost'] = False
    for val in df1.index:
        print(df1.loc[val]['ETC Billings'])
        print(df1.loc[val]['Calculated ETC Billings'])
        if df1.loc[val]['ETC Billings'] == df1.loc[val]['Calculated ETC Billings']:
            df1['verify_ETC_billings'] = True
        else:
            df1['verify_ETC_billings'] = False
    for val in df1.index:
        if df1.loc[val]['CM%'] == df1.loc[val]['Calculated CM%']:
            df1['verify_CM%'] = True
        else:
            df1['verify_CM%'] = False
    for val in df1.index:
        print(df1.loc[val]['QTY Variance'])
        print(df1.loc[val]['Calculated QTY Variance'])
        if df1.loc[val]['QTY Variance'] == df1.loc[val]['Calculated QTY Variance']:
            df1['verify_QTY_Variance'] = True
        else:
            df1['verify_QTY_Variance'] = False
    for val in df1.index:
        print(df1.loc[val]['Cost Variance'])
        print(df1.loc[val]['Calculated Cost Variance'])
        if df1.loc[val]['Cost Variance'] == df1.loc[val]['Calculated Cost Variance']:
            df1['verify_Cost_Variance'] = True
        else:
            df1['verify_Cost_Variance'] = False
    for val in df1.index:
        print(df1.loc[val]['Billings Variance'])
        print(df1.loc[val]['Calculated Billings Variance'])
        if df1.loc[val]['Billings Variance'] == df1.loc[val]['Calculated Billings Variance']:
            df1['verify_Billings_Variance'] = True
        else:
            df1['verify_Billings_Variance'] = False
    return df1


def validate_calculations2test():
    for val in df1.index:
        print("Cost : ", df1.loc[val]['ETC Cost'])
        print(df1.loc[val]['Calculated ETC Cost'])
        print("Billings : ", df1.loc[val]['ETC Billings'])
        print(df1.loc[val]['Calculated ETC Billings'])
        print("CM% : ", df1.loc[val]['CM%'])
        print(df1.loc[val]['Calculated CM%'])
        print("QTY Variance : ", df1.loc[val]['QTY Variance'])
        print(df1.loc[val]['Calculated QTY Variance'])
        print("Cost Variance : ", df1.loc[val]['Cost Variance'])
        print(df1.loc[val]['Calculated Cost Variance'])
        print("Billings Variance : ", df1.loc[val]['Billings Variance'])
        print(df1.loc[val]['Calculated Billings Variance'])
        df1.loc[val]['verify_ETC_cost'] = df1.loc[val]['ETC Cost'].astype(float) == df1.loc[val]['Calculated ETC Cost'].astype(float)
        df1.loc[val]['verify_ETC_billings'] = df1.loc[val]['ETC Billings'].astype(float) == df1.loc[val]['Calculated ETC Billings'].astype(float)
        df1.loc[val]['verify_CM%'] = df1.loc[val]['CM%'].astype(float) == df1.loc[val]['Calculated CM%'].astype(float)
        df1.loc[val]['verify_QTY_Variance'] = df1.loc[val]['QTY Variance'].astype(float) == df1.loc[val]['Calculated QTY Variance'].astype(float)
        df1.loc[val]['verify_Cost_Variance'] = df1.loc[val]['Cost Variance'].astype(float) == df1.loc[val]['Calculated Cost Variance'].astype(float)
        df1.loc[val]['verify_Billings_Variance'] = df1.loc[val]['Billings Variance'].astype(float) == df1.loc[val]['Calculated Billings Variance'].astype(float)
    df1['verify_ETC_cost'] = df1['ETC Cost'].astype(float) == df1['Calculated ETC Cost'].astype(float)
    df1['verify_ETC_billings'] = df1['ETC Billings'].astype(float) == df1['Calculated ETC Billings'].astype(float)
    df1['verify_CM%'] = df1['CM%'].astype(float) == df1['Calculated CM%'].astype(float)
    df1['verify_QTY_Variance'] = df1['QTY Variance'].astype(float) == df1['Calculated QTY Variance'].astype(float)
    df1['verify_Cost_Variance'] = df1['Cost Variance'].astype(float) == df1['Calculated Cost Variance'].astype(float)
    df1['verify_Billings_Variance'] = df1['Billings Variance'].astype(float) == df1['Calculated Billings Variance'].astype(float)






