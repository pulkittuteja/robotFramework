*** Settings ***
Documentation    Keyword Library for iManage Change Order Functionality

*** Variables ***

*** Keywords ***
From Main Shell Navigate to Change Order
    [Arguments]         ${ChangeOrder}
    Open iManage Assistant
    Expand Assistant Section        ${ASSIST MY OPP&ENGAGE Link}
    Wait Until Page Contains Element        ${ASSIST New Change Order Link}
    Click Element       ${ASSIST MY OPP&ENGAGE Link}/following-sibling::ul//a[@title= '${ChangeOrder}']
    Wait Until Page Contains Element        //span[contains(normalize-space(.), '${ChangeOrder}') and contains(@id, 'shellname')]


