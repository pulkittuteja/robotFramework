*** Settings ***
Documentation     Keyword file for ERA specific keywords and tests.

*** Variables ***

*** Keywords ***
Validate Part 1 Questions
    [Arguments]    ${data_dict}
    Set Selenium Speed    0
    Wait Until Page Contains Element    ${PART 1 Header}    30s
    Validate Question 1A    ${data_dict}
    Validate Question 1B    ${data_dict}
    Validate Question 2    ${data_dict}
    Validate Question 3    ${data_dict}
    Validate Question 4A    ${data_dict}
    Validate Question 4A-1    ${data_dict}
    Validate Question 4A-2    ${data_dict}
    Validate Question 4A-3    ${data_dict}
    Validate Question 4B    ${data_dict}
    Validate Question 4C    ${data_dict}
    Validate Question 5    ${data_dict}
    Validate Question 6A    ${data_dict}
    Validate Question 6B    ${data_dict}
    Validate Question 6C    ${data_dict}
    Validate Question 6D    ${data_dict}
    Validate Question 7    ${data_dict}
    Validate Question 8A    ${data_dict}
    Validate Question 8B    ${data_dict}
    Validate Question 9    ${data_dict}
    Validate Question 10    ${data_dict}
    Validate Question 11a    ${data_dict}
    Validate Question 11b    ${data_dict}
    Validate Question 11c    ${data_dict}
    Validate Question 12    ${data_dict}
    Validate Question 13    ${data_dict}
    Set Selenium Speed    ${DELAY}

Validate Part 2 Questions
    [Arguments]    ${data_dict}
    Set Selenium Speed    0
    Wait Until Page Contains Element    ${PART 2 Header}    30s
    Validate Question 14    ${data_dict}
    Validate Question 15    ${data_dict}
    Validate Question 16a-1    ${data_dict}
    Validate Question 16a-2    ${data_dict}
    Validate Question 16a-3    ${data_dict}
    Validate Question 16a-4    ${data_dict}
    Validate Question 16a-5    ${data_dict}
    Validate Question 16a-6    ${data_dict}
    Validate Question 16b    ${data_dict}
    Validate Question 17a    ${data_dict}
    Validate Question 17b    ${data_dict}
    Validate Question 18    ${data_dict}
    Validate Question 19    ${data_dict}
    Validate Question 20    ${data_dict}
    Validate Question 21    ${data_dict}
    Set Selenium Speed    ${DELAY}

Validate Question 1A
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 1a
    ...    1) If isNewClient checkbox is 'T' then the section is Visible
    ...    2) If isNewClient checkbox is 'F' then the section is Hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isNewClient"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 1a YES Radio}
    ...    ELSE IF    '${data_dict["isNewClient"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 1a YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isNewClient"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 1a NO Radio}
    ...    ELSE IF    '${data_dict["isNewClient"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 1a NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isNewClient"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 1a Textarea}
    ...    ELSE IF    '${data_dict["isNewClient"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 1a Textarea}
    Return From Keyword If    '${data_dict["isNewClient"].upper()}'=='F'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["1A"].upper()}'=='Y'    Click Element    ${QUESTION 1a YES Radio}
    ...    ELSE IF    '${data_dict["1A"].upper()}'=='N'    Click Element    ${QUESTION 1a NO Radio}
    Return From Keyword If    '${data_dict["isNewClient"].upper()}'=='F'
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 1a Textarea}    This is a test message for 1a ${LONG MSG}

Validate Question 1B
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 1b
    ...    1) If isNewClient checkbox is 'T' then the section is hidden
    ...    2) If isNewClient checkbox is 'F' then the section is Visible
    ...    3) If isNewClient checkbox is 'F' and the 'Yes' checkbox is selected then the textbox is visable
    ...    4) If isNewClient checkbox is 'F' and the 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isNewClient"].upper()}'=='F'    Element Should Be Visible    ${QUESTION 1b YES Radio}
    ...    ELSE IF    '${data_dict["isNewClient"].upper()}'=='T'    Element Should Not Be Visible    ${QUESTION 1b YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isNewClient"].upper()}'=='F'    Element Should Be Visible    ${QUESTION 1b NO Radio}
    ...    ELSE IF    '${data_dict["isNewClient"].upper()}'=='T'    Element Should Not Be Visible    ${QUESTION 1b NO Radio}
    Return From Keyword If    '${data_dict["isNewClient"].upper()}'=='T'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["1B"].upper()}'=='Y'    Click Element    ${QUESTION 1b YES Radio}
    ...    ELSE IF    '${data_dict["1B"].upper()}'=='N'    Click Element    ${QUESTION 1b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["1B"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 1b Textarea}
    ...    ELSE IF    '${data_dict["1B"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 1b Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["1B"].upper()}'=='Y'    Input Text    ${QUESTION 1b Textarea}    This is a test message for 1b ${LONG MSG}

Validate Question 2
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 2
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 2 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 2 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["2"].upper()}'=='Y'    Click Element    ${QUESTION 2 YES Radio}
    ...    ELSE IF    '${data_dict["2"].upper()}'=='N'    Click Element    ${QUESTION 2 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["2"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 2 Textarea}
    ...    ELSE IF    '${data_dict["2"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 2 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["2"].upper()}'=='Y'    Input Text    ${QUESTION 2 Textarea}    This is a test message for 2 ${LONG MSG}

Validate Question 3
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 3
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 3 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 3 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["3"].upper()}'=='Y'    Click Element    ${QUESTION 3 YES Radio}
    ...    ELSE IF    '${data_dict["3"].upper()}'=='N'    Click Element    ${QUESTION 3 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["3"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 3 Textarea}
    ...    ELSE IF    '${data_dict["3"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 3 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["3"].upper()}'=='Y'    Input Text    ${QUESTION 3 Textarea}    This is a test message for 3 ${LONG MSG}

Validate Question 4A
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 4a
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isPciEngagement"].upper()}'=='T' or '${data_dict["isFinancialModelEngagement"].upper()}'=='T' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T'    Element Should Not Be Visible    ${QUESTION 4a(1) YES Radio}
    ...    ELSE IF    '${data_dict["isPciEngagement"].upper()}'=='F' or '${data_dict["isFinancialModelEngagement"].upper()}'=='F' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='F'    Element Should Be Visible    ${QUESTION 4a(1) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isPciEngagement"].upper()}'=='T' or '${data_dict["isFinancialModelEngagement"].upper()}'=='T' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T'    Element Should Not Be Visible    ${QUESTION 4a(1) NO Radio}
    ...    ELSE IF    '${data_dict["isPciEngagement"].upper()}'=='F' or '${data_dict["isFinancialModelEngagement"].upper()}'=='F' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='F'    Element Should Be Visible    ${QUESTION 4a(1) NO Radio}
    Return From Keyword If    '${data_dict["isPciEngagement"].upper()}'=='T' or '${data_dict["isFinancialModelEngagement"].upper()}'=='T' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T'
    #Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 4a(1) YES Radio}
    #Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 4a(1) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(1)"].upper()}'=='Y'    Click Element    ${QUESTION 4a(1) YES Radio}
    ...    ELSE IF    '${data_dict["4a(1)"].upper()}'=='N'    Click Element    ${QUESTION 4a(1) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(1)"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 4a(1) Textarea}
    ...    ELSE IF    '${data_dict["4a(1)"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 4a(1) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(1)"].upper()}'=='Y'    Input Text    ${QUESTION 4a(1) Textarea}    This is a test message for 4a ${LONG MSG}
    Return From Keyword If    '${data_dict["4a(1)"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a(2) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a(2) NO Radio}
    ...    ELSE IF    '${data_dict["4a(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a(2) Textarea}
    ...    ELSE IF    '${data_dict["4a(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a(2) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(2)"].upper()}'=='Y'    Click Element    ${QUESTION 4a(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a(2)"].upper()}'=='N'    Click Element    ${QUESTION 4a(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a(1)"].upper()}'=='N'    Input Text    ${QUESTION 4a(2) Textarea}    This is a test message for 4a ${LONG MSG}

Validate Question 4A-1
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 4a
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    ...    TBD
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isPciEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 4a-1(1) YES Radio}
    ...    ELSE IF    '${data_dict["isPciEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 4a-1(1) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isPciEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 4a-1(1) NO Radio}
    ...    ELSE IF    '${data_dict["isPciEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 4a-1(1) NO Radio}
    ###
    Return From Keyword If    '${data_dict["isPciEngagement"].upper()}'=='F'
    ###
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(1)"].upper()}'=='Y'    Click Element    ${QUESTION 4a-1(1) YES Radio}
    ...    ELSE IF    '${data_dict["4a-1(1)"].upper()}'=='N'    Click Element    ${QUESTION 4a-1(1) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(1)"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 4a-1(1) Textarea}
    ...    ELSE IF    '${data_dict["4a-1(1)"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 4a-1(1) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(1)"].upper()}'=='Y'    Input Text    ${QUESTION 4a-1(1) Textarea}    This is a test message for 4a-1 ${LONG MSG}
    Return From Keyword If    '${data_dict["4a-1(1)"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-1(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a-1(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-1(2) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-1(2) NO Radio}
    ...    ELSE IF    '${data_dict["4a-1(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-1(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-1(2) Textarea}
    ...    ELSE IF    '${data_dict["4a-1(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-1(2) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(2)"].upper()}'=='Y'    Click Element    ${QUESTION 4a-1(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a-1(2)"].upper()}'=='N'    Click Element    ${QUESTION 4a-1(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-1(1)"].upper()}'=='N'    Input Text    ${QUESTION 4a-1(2) Textarea}    This is a test message for 4a-1 ${LONG MSG}

Validate Question 4A-2
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 4a
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    ...    TBD
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isFinancialModelEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 4a-2(1) YES Radio}
    ...    ELSE IF    '${data_dict["isFinancialModelEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 4a-2(1) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isFinancialModelEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 4a-2(1) NO Radio}
    ...    ELSE IF    '${data_dict["isFinancialModelEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 4a-2(1) NO Radio}
    ###
    Return From Keyword If    '${data_dict["isFinancialModelEngagement"].upper()}'=='F'
    ###
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(1)"].upper()}'=='Y'    Click Element    ${QUESTION 4a-2(1) YES Radio}
    ...    ELSE IF    '${data_dict["4a-2(1)"].upper()}'=='N'    Click Element    ${QUESTION 4a-2(1) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(1)"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 4a-2(1) Textarea}
    ...    ELSE IF    '${data_dict["4a-2(1)"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 4a-2(1) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(1)"].upper()}'=='Y'    Input Text    ${QUESTION 4a-2(1) Textarea}    This is a test message for 4a-2 ${LONG MSG}
    Return From Keyword If    '${data_dict["4a-2(1)"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-2(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a-2(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-2(2) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-2(2) NO Radio}
    ...    ELSE IF    '${data_dict["4a-2(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-2(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-2(2) Textarea}
    ...    ELSE IF    '${data_dict["4a-2(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-2(2) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(2)"].upper()}'=='Y'    Click Element    ${QUESTION 4a-2(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a-2(2)"].upper()}'=='N'    Click Element    ${QUESTION 4a-2(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-2(1)"].upper()}'=='N'    Input Text    ${QUESTION 4a-2(2) Textarea}    This is a test message for 4a-2 ${LONG MSG}

Validate Question 4A-3
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 4a
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    ...    TBD
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isDueDillgenceEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 4a-3(1) YES Radio}
    ...    ELSE IF    '${data_dict["isDueDillgenceEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 4a-3(1) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isDueDillgenceEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 4a-3(1) NO Radio}
    ...    ELSE IF    '${data_dict["isDueDillgenceEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 4a-3(1) NO Radio}
    ###
    Return From Keyword If    '${data_dict["isDueDillgenceEngagement"].upper()}'=='F'
    ###
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(1)"].upper()}'=='Y'    Click Element    ${QUESTION 4a-3(1) YES Radio}
    ...    ELSE IF    '${data_dict["4a-3(1)"].upper()}'=='N'    Click Element    ${QUESTION 4a-3(1) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(1)"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 4a-3(1) Textarea}
    ...    ELSE IF    '${data_dict["4a-3(1)"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 4a-3(1) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(1)"].upper()}'=='Y'    Input Text    ${QUESTION 4a-3(1) Textarea}    This is a test message for 4a-3 ${LONG MSG}
    Return From Keyword If    '${data_dict["4a-3(1)"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-3(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a-3(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-3(2) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-3(2) NO Radio}
    ...    ELSE IF    '${data_dict["4a-3(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-3(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(1)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4a-3(2) Textarea}
    ...    ELSE IF    '${data_dict["4a-3(1)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4a-3(2) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(2)"].upper()}'=='Y'    Click Element    ${QUESTION 4a-3(2) YES Radio}
    ...    ELSE IF    '${data_dict["4a-3(2)"].upper()}'=='N'    Click Element    ${QUESTION 4a-3(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4a-3(1)"].upper()}'=='N'    Input Text    ${QUESTION 4a-3(2) Textarea}    This is a test message for 4a-3 ${LONG MSG}

Validate Question 4B
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 4a
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 4b(1) YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 4b(1) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(1)"].upper()}'=='Y'    Click Element    ${QUESTION 4b(1) YES Radio}
    ...    ELSE IF    '${data_dict["4b(1)"].upper()}'=='N'    Click Element    ${QUESTION 4b(1) NO Radio}
    Return From Keyword If    '${data_dict["4b(1)"].upper()}'=='N'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(1)"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 4b(2) YES Radio}
    ...    ELSE IF    '${data_dict["4b(1)"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 4b(2) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(1)"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 4b(2) NO Radio}
    ...    ELSE IF    '${data_dict["4b(1)"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 4b(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(2)"].upper()}'=='Y'    Click Element    ${QUESTION 4b(2) YES Radio}
    ...    ELSE IF    '${data_dict["4b(2)"].upper()}'=='N'    Click Element    ${QUESTION 4b(2) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(2)"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 4b(2) Textarea}
    ...    ELSE IF    '${data_dict["4b(2)"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 4b(2) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(2)"].upper()}'=='Y'    Input Text    ${QUESTION 4b(2) Textarea}    This is a test message for 4b ${LONG MSG}
    Return From Keyword If    '${data_dict["4b(2)"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(2)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4b(3) YES Radio}
    ...    ELSE IF    '${data_dict["4b(2)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4b(3) YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(2)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4b(3) NO Radio}
    ...    ELSE IF    '${data_dict["4b(2)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4b(3) NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(2)"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 4b(3) Textarea}
    ...    ELSE IF    '${data_dict["4b(2)"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 4b(3) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["4b(3)"].upper()}'=='Y'    Click Element    ${QUESTION 4b(3) YES Radio}
    ...    ELSE IF    '${data_dict["4b(3)"].upper()}'=='N'    Click Element    ${QUESTION 4b(3) NO Radio}
    Return From Keyword If    '${data_dict["4b(2)"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Run Keyword    Input Text    ${QUESTION 4b(3) Textarea}    This is a test message for 4b ${LONG MSG}

Validate Question 4C
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 2
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isSocialEngineeringEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 4c Textarea}
    ...    ELSE IF    '${data_dict["isSocialEngineeringEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 4c Textarea}
    Return From Keyword If    '${data_dict["isSocialEngineeringEngagement"].upper()}'=='F'
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 4c Textarea}    This is a test message for 4c ${LONG MSG}

Validate Question 5
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 3
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 5 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 5 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["5"].upper()}'=='Y'    Click Element    ${QUESTION 5 YES Radio}
    ...    ELSE IF    '${data_dict["5"].upper()}'=='N'    Click Element    ${QUESTION 5 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["5"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 5 Textarea}
    ...    ELSE IF    '${data_dict["5"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 5 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["5"].upper()}'=='Y'    Input Text    ${QUESTION 5 Textarea}    This is a test message for 5 ${LONG MSG}

Validate Question 6a
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 6a
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 6a YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 6a NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6a"].upper()}'=='Y'    Click Element    ${QUESTION 6a YES Radio}
    ...    ELSE IF    '${data_dict["6a"].upper()}'=='N'    Click Element    ${QUESTION 6a NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6a"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 6a Textarea}
    ...    ELSE IF    '${data_dict["6a"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 6a Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6a"].upper()}'=='Y'    Input Text    ${QUESTION 6a Textarea}    This is a test message for 6a ${LONG MSG}

Validate Question 6b
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 6b
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 6b YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 6b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6b"].upper()}'=='Y'    Click Element    ${QUESTION 6b YES Radio}
    ...    ELSE IF    '${data_dict["6b"].upper()}'=='N'    Click Element    ${QUESTION 6b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6b"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 6b(1) Textarea}
    ...    ELSE IF    '${data_dict["6b"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 6b(1) Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6b"].upper()}'=='Y'    Input Text    ${QUESTION 6b(1) Textarea}    This is a test message for 6b(1) ${LONG MSG}
    #Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6b"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 6b(2) Textarea}
    #ELSE IF    '${data_dict["6b"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 6b(2) Textarea}
    #Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6b"].upper()}'=='Y'    Input Text    ${QUESTION 6b(2) Textarea}    This is a test message for 6b(2)

Validate Question 6c
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 6c
    ...    1) If isLoanStaff checkbox is 'T' then the section is Visible
    ...    2) If isLoanStaff checkbox is 'F' then the section is Hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isLoanStaff"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 6c YES Radio}
    ...    ELSE IF    '${data_dict["isLoanStaff"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 6c YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isLoanStaff"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 6c NO Radio}
    ...    ELSE IF    '${data_dict["isLoanStaff"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 6c NO Radio}
    Return From Keyword If    '${data_dict["isLoanStaff"].upper()}'=='F'
    ##
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6c"].upper()}'=='Y'    Click Element    ${QUESTION 6c YES Radio}
    ...    ELSE IF    '${data_dict["6c"].upper()}'=='N'    Click Element    ${QUESTION 6c NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["6c"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 6c Textarea}
    ...    ELSE IF    '${data_dict["6c"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 6c Textarea}
    Return From Keyword If    '${data_dict["6c"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 6c Textarea}    This is a test message for 6c ${LONG MSG}

Validate Question 6d
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 6d
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isSoftwareResell"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 6d Textarea}
    ...    ELSE IF    '${data_dict["isSoftwareResell"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 6d Textarea}
    Return From Keyword If    '${data_dict["isSoftwareResell"].upper()}'=='F'
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 6d Textarea}    This is a test message for 6d ${LONG MSG}

Validate Question 7
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 7
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 7 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 7 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["7"].upper()}'=='Y'    Click Element    ${QUESTION 7 YES Radio}
    ...    ELSE IF    '${data_dict["7"].upper()}'=='N'    Click Element    ${QUESTION 7 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["7"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 7 Textarea}
    ...    ELSE IF    '${data_dict["7"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 7 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["7"].upper()}'=='Y'    Input Text    ${QUESTION 7 Textarea}    This is a test message for 7 ${LONG MSG}

Validate Question 8a
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 8a
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isCrossBorderTravel"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 8a YES Radio}
    ...    ELSE IF    '${data_dict["isCrossBorderTravel"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 8a YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isCrossBorderTravel"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 8a NO Radio}
    ...    ELSE IF    '${data_dict["isCrossBorderTravel"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 8a NO Radio}
    Return From Keyword If    '${data_dict["isCrossBorderTravel"].upper()}'=='F'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["8a"].upper()}'=='Y'    Click Element    ${QUESTION 8a YES Radio}
    ...    ELSE IF    '${data_dict["8a"].upper()}'=='N'    Click Element    ${QUESTION 8a NO Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 8a Textarea}
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 8a Textarea}    This is a test message for 8a ${LONG MSG}

Validate Question 8b
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 8b
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isCrossBorderTravel"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 8b YES Radio}
    ...    ELSE IF    '${data_dict["isCrossBorderTravel"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 8b YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isCrossBorderTravel"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 8b NO Radio}
    ...    ELSE IF    '${data_dict["isCrossBorderTravel"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 8b NO Radio}
    Return From Keyword If    '${data_dict["isCrossBorderTravel"].upper()}'=='F'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["8b"].upper()}'=='Y'    Click Element    ${QUESTION 8b YES Radio}
    ...    ELSE IF    '${data_dict["8b"].upper()}'=='N'    Click Element    ${QUESTION 8b NO Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 8b Textarea}
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 8b Textarea}    This is a test message for 8b ${LONG MSG}

Validate Question 9
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 9
    ...    1) The Question 9 section is Visible
    ...    9) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 9 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 9 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["9"].upper()}'=='Y'    Click Element    ${QUESTION 9 YES Radio}
    ...    ELSE IF    '${data_dict["9"].upper()}'=='N'    Click Element    ${QUESTION 9 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["9"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 9 Textarea}
    ...    ELSE IF    '${data_dict["9"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 9 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["9"].upper()}'=='Y'    Input Text    ${QUESTION 9 Textarea}    This is a test message for 9 ${LONG MSG}

Validate Question 10
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 10
    ...    1) The Question 10 section is Visible
    ...    10) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 10 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 10 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["10"].upper()}'=='Y'    Click Element    ${QUESTION 10 YES Radio}
    ...    ELSE IF    '${data_dict["10"].upper()}'=='N'    Click Element    ${QUESTION 10 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["10"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 10 Textarea}
    ...    ELSE IF    '${data_dict["10"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 10 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["10"].upper()}'=='Y'    Input Text    ${QUESTION 10 Textarea}    This is a test message for 10 ${LONG MSG}

Validate Question 11a
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 11a
    ...    1) The Question 11a section is Visible
    ...    11a) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 11a YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 11a NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11a"].upper()}'=='Y'    Click Element    ${QUESTION 11a YES Radio}
    ...    ELSE IF    '${data_dict["11a"].upper()}'=='N'    Click Element    ${QUESTION 11a NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11a"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 11a Textarea}
    ...    ELSE IF    '${data_dict["11a"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 11a Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11a"].upper()}'=='Y'    Input Text    ${QUESTION 11a Textarea}    This is a test message for 11a ${LONG MSG}

Validate Question 11b
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 11b
    ...    1) The Question 11b section is Visible
    ...    11b) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 11b YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 11b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11b"].upper()}'=='Y'    Click Element    ${QUESTION 11b YES Radio}
    ...    ELSE IF    '${data_dict["11b"].upper()}'=='N'    Click Element    ${QUESTION 11b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11b"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 11b Textarea}
    ...    ELSE IF    '${data_dict["11b"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 11b Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11b"].upper()}'=='Y'    Input Text    ${QUESTION 11b Textarea}    This is a test message for 11b ${LONG MSG}

Validate Question 11c
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 11c
    ...    1) The Question 11c section is Visible
    ...    11c) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 11c YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 11c NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11c"].upper()}'=='Y'    Click Element    ${QUESTION 11c YES Radio}
    ...    ELSE IF    '${data_dict["11c"].upper()}'=='N'    Click Element    ${QUESTION 11c NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11c"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 11c Textarea}
    ...    ELSE IF    '${data_dict["11c"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 11c Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["11c"].upper()}'=='Y'    Input Text    ${QUESTION 11c Textarea}    This is a test message for 11c ${LONG MSG}

Validate Question 12
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 2
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isGovernmentEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 12 Textarea}
    ...    ELSE IF    '${data_dict["isGovernmentEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 12 Textarea}
    Return From Keyword If    '${data_dict["isGovernmentEngagement"].upper()}'=='F'
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 12 Textarea}    This is a test message for 12 ${LONG MSG}

Validate Question 13
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 13
    ...    1) The Question 13 section is Visible
    ...    13) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 13 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 13 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["13"].upper()}'=='Y'    Click Element    ${QUESTION 13 YES Radio}
    ...    ELSE IF    '${data_dict["13"].upper()}'=='N'    Click Element    ${QUESTION 13 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["13"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 13 Textarea}
    ...    ELSE IF    '${data_dict["13"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 13 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["13"].upper()}'=='Y'    Input Text    ${QUESTION 13 Textarea}    This is a test message for 13 ${LONG MSG}

Validate Question 14
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 2
    ...    1) The Question 2 section is Visible
    ...    2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isGovernmentEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 14 YES Radio}
    ...    ELSE IF    '${data_dict["isGovernmentEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 14 YES Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isGovernmentEngagement"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 14 NO Radio}
    ...    ELSE IF    '${data_dict["isGovernmentEngagement"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 14 NO Radio}
    Return From Keyword If    '${data_dict["isGovernmentEngagement"].upper()}'=='F'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["14"].upper()}'=='Y'    Click Element    ${QUESTION 14 YES Radio}
    ...    ELSE IF    '${data_dict["14"].upper()}'=='N'    Click Element    ${QUESTION 14 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["14"].upper()}'=='N'    Element Should Be Visible    ${QUESTION 14 Textarea}
    ...    ELSE IF    '${data_dict["14"].upper()}'=='Y'    Element Should Not Be Visible    ${QUESTION 14 Textarea}
    Return From Keyword If    '${data_dict["14"].upper()}'=='Y'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["14"].upper()}'=='N'    Input Text    ${QUESTION 14 Textarea}    This is a test message for 14 ${LONG MSG}

Validate Question 15
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 15
    ...    1) The Question 15 section is Visible
    ...    15) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 15 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 15 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["15"].upper()}'=='Y'    Click Element    ${QUESTION 15 YES Radio}
    ...    ELSE IF    '${data_dict["15"].upper()}'=='N'    Click Element    ${QUESTION 15 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["15"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 15 Textarea}
    ...    ELSE IF    '${data_dict["15"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 15 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["15"].upper()}'=='Y'    Input Text    ${QUESTION 15 Textarea}    This is a test message for 15 ${LONG MSG}

Validate Question 16a-1
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 16a-1
    ...    1) The Question 16a-1 section is Visible
    ...    16a-1) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-1 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-1 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-1"].upper()}'=='Y'    Click Element    ${QUESTION 16a-1 YES Radio}
    ...    ELSE IF    '${data_dict["16a-1"].upper()}'=='N'    Click Element    ${QUESTION 16a-1 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-1"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 16a-1 Textarea}
    ...    ELSE IF    '${data_dict["16a-1"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 16a-1 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-1"].upper()}'=='Y'    Input Text    ${QUESTION 16a-1 Textarea}    This is a test message for 16a-1 ${LONG MSG}

Validate Question 16a-2
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 16a-2
    ...    1) The Question 16a-2 section is Visible
    ...    16a-2) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-2 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-2 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-2"].upper()}'=='Y'    Click Element    ${QUESTION 16a-2 YES Radio}
    ...    ELSE IF    '${data_dict["16a-2"].upper()}'=='N'    Click Element    ${QUESTION 16a-2 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-2"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 16a-2 Textarea}
    ...    ELSE IF    '${data_dict["16a-2"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 16a-2 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-2"].upper()}'=='Y'    Input Text    ${QUESTION 16a-2 Textarea}    This is a test message for 16a-2 ${LONG MSG}

Validate Question 16a-3
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 16a-3
    ...    1) The Question 16a-3 section is Visible
    ...    16a-3) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-3 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-3 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-3"].upper()}'=='Y'    Click Element    ${QUESTION 16a-3 YES Radio}
    ...    ELSE IF    '${data_dict["16a-3"].upper()}'=='N'    Click Element    ${QUESTION 16a-3 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-3"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 16a-3 Textarea}
    ...    ELSE IF    '${data_dict["16a-3"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 16a-3 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-3"].upper()}'=='Y'    Input Text    ${QUESTION 16a-3 Textarea}    This is a test message for 16a-3 ${LONG MSG}

Validate Question 16a-4
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 16a-4
    ...    1) The Question 16a-4 section is Visible
    ...    16a-4) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-4 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-4 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-4"].upper()}'=='Y'    Click Element    ${QUESTION 16a-4 YES Radio}
    ...    ELSE IF    '${data_dict["16a-4"].upper()}'=='N'    Click Element    ${QUESTION 16a-4 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-4"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 16a-4 Textarea}
    ...    ELSE IF    '${data_dict["16a-4"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 16a-4 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-4"].upper()}'=='Y'    Input Text    ${QUESTION 16a-4 Textarea}    This is a test message for 16a-4 ${LONG MSG}

Validate Question 16a-5
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 16a-5
    ...    1) The Question 16a-5 section is Visible
    ...    16a-5) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-5 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-5 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-5"].upper()}'=='Y'    Click Element    ${QUESTION 16a-5 YES Radio}
    ...    ELSE IF    '${data_dict["16a-5"].upper()}'=='N'    Click Element    ${QUESTION 16a-5 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-5"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 16a-5 Textarea}
    ...    ELSE IF    '${data_dict["16a-5"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 16a-5 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-5"].upper()}'=='Y'    Input Text    ${QUESTION 16a-5 Textarea}    This is a test message for 16a-5 ${LONG MSG}

Validate Question 16a-6
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 16a-6
    ...    1) The Question 16a-6 section is Visible
    ...    16a-6) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-6 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16a-6 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-6"].upper()}'=='Y'    Click Element    ${QUESTION 16a-6 YES Radio}
    ...    ELSE IF    '${data_dict["16a-6"].upper()}'=='N'    Click Element    ${QUESTION 16a-6 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-6"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 16a-6 Textarea}
    ...    ELSE IF    '${data_dict["16a-6"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 16a-6 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16a-6"].upper()}'=='Y'    Input Text    ${QUESTION 16a-6 Textarea}    This is a test message for 16a-6 ${LONG MSG}

Validate Question 16b
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 16b
    ...    1) The Question 16b section is Visible
    ...    16b) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16b YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 16b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16b"].upper()}'=='Y'    Click Element    ${QUESTION 16b YES Radio}
    ...    ELSE IF    '${data_dict["16b"].upper()}'=='N'    Click Element    ${QUESTION 16b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16b"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 16b Textarea}
    ...    ELSE IF    '${data_dict["16b"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 16b Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["16b"].upper()}'=='Y'    Input Text    ${QUESTION 16b Textarea}    This is a test message for 16b ${LONG MSG}

Validate Question 17a
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 17a
    ...    1) The Question 17a section is Visible
    ...    17a) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 17a YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 17a NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["17a"].upper()}'=='Y'    Click Element    ${QUESTION 17a YES Radio}
    ...    ELSE IF    '${data_dict["17a"].upper()}'=='N'    Click Element    ${QUESTION 17a NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["17a"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 17a Textarea}
    ...    ELSE IF    '${data_dict["17a"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 17a Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["17a"].upper()}'=='Y'    Input Text    ${QUESTION 17a Textarea}    This is a test message for 17a ${LONG MSG}

Validate Question 17b
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 17b
    ...    1) The Question 17b section is Visible
    ...    17b) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 17b YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 17b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["17b"].upper()}'=='Y'    Click Element    ${QUESTION 17b YES Radio}
    ...    ELSE IF    '${data_dict["17b"].upper()}'=='N'    Click Element    ${QUESTION 17b NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["17b"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 17b Textarea}
    ...    ELSE IF    '${data_dict["17b"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 17b Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["17b"].upper()}'=='Y'    Input Text    ${QUESTION 17b Textarea}    This is a test message for 17b ${LONG MSG}

Validate Question 18
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 18
    ...    1) The Question 18 section is Visible
    ...    18) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 18 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 18 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["18"].upper()}'=='Y'    Click Element    ${QUESTION 18 YES Radio}
    ...    ELSE IF    '${data_dict["18"].upper()}'=='N'    Click Element    ${QUESTION 18 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["18"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 18 Textarea}
    ...    ELSE IF    '${data_dict["18"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 18 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["18"].upper()}'=='Y'    Input Text    ${QUESTION 18 Textarea}    This is a test message for 18 ${LONG MSG}

Validate Question 19
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 19
    ...    1) If isContractorUsed checkbox is 'T' then the section is Visible
    ...    2) If isContractorUsed checkbox is 'F' then the section is Hidden
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["isContractorUsed"].upper()}'=='T'    Element Should Be Visible    ${QUESTION 19 Textarea}
    ...    ELSE IF    '${data_dict["isContractorUsed"].upper()}'=='F'    Element Should Not Be Visible    ${QUESTION 19 Textarea}
    Return From Keyword If    '${data_dict["isContractorUsed"].upper()}'=='F'
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 19 Textarea}    This is a test message for 19 ${LONG MSG}

Validate Question 20
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 20
    ...    1) The Question 20 section is Visible
    ...    20) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 20 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 20 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["20"].upper()}'=='Y'    Click Element    ${QUESTION 20 YES Radio}
    ...    ELSE IF    '${data_dict["20"].upper()}'=='N'    Click Element    ${QUESTION 20 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["20"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 20 Textarea}
    ...    ELSE IF    '${data_dict["20"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 20 Textarea}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["20"].upper()}'=='Y'    Input Text    ${QUESTION 20 Textarea}    This is a test message for 20 ${LONG MSG}

Validate Question 21
    [Arguments]    ${data_dict}
    [Documentation]    Validates the following requirements for question 21
    ...    1) The Question 21 section is Visible
    ...    21) If 'Yes' checkbox is selected then the textbox is visable
    ...    3) If 'No' checkbox is selected then the textbox is hidden
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 21 Textarea1}
    Run Keyword And Continue On Failure    Input Text    ${QUESTION 21 Textarea1}    This is a test message for 21(1) ${LONG MSG}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 21 YES Radio}
    Run Keyword And Continue On Failure    Element Should Be Visible    ${QUESTION 21 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["21"].upper()}'=='Y'    Click Element    ${QUESTION 21 YES Radio}
    ...    ELSE IF    '${data_dict["21"].upper()}'=='N'    Click Element    ${QUESTION 21 NO Radio}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["21"].upper()}'=='Y'    Element Should Be Visible    ${QUESTION 21 Textarea2}
    ...    ELSE IF    '${data_dict["21"].upper()}'=='N'    Element Should Not Be Visible    ${QUESTION 21 Textarea2}
    Log     ${data_dict["21"].upper()}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["21"].upper()}'=='Y'    Input Text    ${QUESTION 21 Textarea2}    This is a test message for 21(2) ${LONG MSG}
