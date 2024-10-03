*** Settings ***
Documentation     Keyword file for ERA specific keywords and tests.

*** Variables ***

*** Keywords ***
${aprv_rjct} ERA as ${role}
    Click ERA Tile
    Click Button    ${ERA AWAITING APPROVE Btn}
    Open ERA From Filter List    ${ERA NAME}
    Click Link    ${APPROVALS Link}
    Run Keyword And Continue On Failure    Run Keyword If    '${role.upper()}'=='ADMIN'    Admin Approval    ${data_dict}    ${aprv_rjct}
    Run Keyword And Continue On Failure    Run Keyword If    '${role.upper()}'=='EMD'    EMD Approval    ${data_dict}    ${aprv_rjct}
    Run Keyword And Continue On Failure    Run Keyword If    '${role.upper()}'=='QRMMD'    QRMMD Approval    ${data_dict}    ${aprv_rjct}
    Run Keyword And Continue On Failure    Run Keyword If    '${role.upper()}'=='QCMD'    QCMD Approval    ${data_dict}    ${aprv_rjct}
    Run Keyword And Continue On Failure    Run Keyword If    '${role.upper()}'=='RMD'    RMD Approval    ${data_dict}    ${aprv_rjct}

Admin Approval
    [Arguments]    ${data_dict}    ${aprv/rjct}
    Set Selenium Speed    0
    Wait Until Page Contains Element    ${APPROVERS Header}    30s
    Sleep    1s
    Run Keyword And Continue On Failure    Page Should Contain Element    ${EMD APPROVER Header}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${EMD APPROVER Name}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${EMD APPROVE Button}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${EMD REJECT Button}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QRMMD"]}'!=''    Element Should Be Visible    ${QRMMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QCMD"]}'!=''    Element Should Be Visible    ${QCMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T' or '${data_dict["isPciEngagement"].upper()}'=='T'    Element Should Be Visible    ${QCMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH' or '${data_dict["CRAR"].upper()}'=='INCREASED'    Element Should Be Visible    ${RMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH'    Element Should Be Visible    ${QRMMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["EMDApprove"].upper()}'!=''    EMD Approval    ${data_dict}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QCMDApprove"].upper()}'!=''    QCMD Approval    ${data_dict}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QRMMDApprove"].upper()}'!=''    QRMMD Approval    ${data_dict}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["RMDApprove"].upper()}'!=''    RMD Approval    ${data_dict}

EMD Approval
    [Arguments]    ${data_dict}
    ${aprv_rjct}=    Set Variable If    '${data_dict["EMDApprove"]}'=='T'    'APPROVE'    'REJECT'
    Log    In EMD Approval
    Wait Until Page Contains Element    ${EMD APPROVE Button}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Click Element    ${EMD APPROVE Button}
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Click Element    ${EMD REJECT Button}
    Wait Until Page Contains Element    ${EMD APPROVER Status}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Element Text Should Be    ${EMD APPROVER Status}    Approved
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Element Text Should Be    ${EMD APPROVER Status}    Rejected
    Run Keyword And Continue On Failure    Page Should Contain Element    ${EMD APPROVAL TRACKING Status}
    #Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH'    Element Should Be Visible    ${QRMMD APPROVAL Pending txt}
    #Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T' or '${data_dict["isPciEngagement"].upper()}'=='T'    Element Should Be Visible    ${QCMD APPROVAL Pending txt}
    #Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH' or '${data_dict["CRAR"].upper()}'=='INCREASED'    Element Should Be Visible    ${RMD APPROVAL Pending txt}
    Run Keyword And Continue On Failure    Element Text Should Be    ${EMD APPROVAL TRACKING Status}    Approved

QRMMD Approval
    [Arguments]    ${data_dict}
    ${aprv_rjct}=    Set Variable If    '${data_dict["EMDApprove"]}'=='T'    'APPROVE'    'REJECT'
    Log    In QRMMD Approval
    Wait Until Page Contains Element    ${QRMMD APPROVE Button}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Click Element    ${QRMMD APPROVE Button}
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Click Element    ${QRMMD REJECT Button}
    Wait Until Page Contains Element    ${QRMMD APPROVER Status}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Element Text Should Be    ${QRMMD APPROVER Status}    Approved
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Element Text Should Be    ${QRMMD APPROVER Status}    Rejected
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Element Text Should Be    ${QRMMD APPROVAL TRACKING Status}    Approved
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Element Text Should Be    ${QRMMD APPROVAL TRACKING Status}    Rejected

QCMD Approval
    [Arguments]    ${data_dict}
    ${aprv_rjct}=    Set Variable If    '${data_dict["EMDApprove"]}'=='T'    'APPROVE'    'REJECT'
    Log    In eQA Lead Approval
    Wait Until Page Contains Element    ${eQA Lead APPROVE Button}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Click Element    ${eQA Lead APPROVE Button}
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Click Element    ${eQA Lead REJECT Button}
    Wait Until Page Contains Element    ${eQA APPROVER Status}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Element Text Should Be    ${eQA APPROVER Status}    Approved
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Element Text Should Be    ${eQA APPROVER Status}    Rejected
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Element Text Should Be    ${eQA Lead APPROVAL TRACKING Status}    Approved
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Element Text Should Be    ${eQA Lead APPROVAL TRACKING Status}    Rejected

RMD Approval
    [Arguments]    ${data_dict}
    ${aprv_rjct}=    Set Variable If    '${data_dict["EMDApprove"]}'=='T'    'APPROVE'    'REJECT'
    Log    In RMD Approval
    Wait Until Page Contains Element    ${RMD APPROVE Button}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Click Element    ${RMD APPROVE Button}
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Click Element    ${RMD REJECT Button}
    Wait Until Page Contains Element    ${RMD APPROVER Status}    30s
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Element Text Should Be    ${RMD APPROVER Status}    Approved
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Element Text Should Be    ${RMD APPROVER Status}    Rejected
    Run Keyword And Continue On Failure    Run Keyword If    ${aprv_rjct.upper()}=='APPROVE'    Element Text Should Be    ${RMD APPROVAL TRACKING Status}    Approved
    ...    ELSE IF    ${aprv_rjct.upper()}=='REJECT'    Element Text Should Be    ${RMD APPROVAL TRACKING Status}    Rejected

Approve ERA
    [Arguments]    ${data_dict}    ${Submit_STATUS}
    Set Selenium Speed    0
    Wait Until Page Contains Element    ${APPROVERS Header}    30s
    Sleep    1s
    Run Keyword And Continue On Failure    Wait Until Page Contains Element    ${EMD APPROVER Header}
    Run Keyword And Continue On Failure    Page Should Contain Element    ${EMD APPROVER Name}
    Run Keyword And Ignore Error    Page Should Contain Element    ${EMD APPROVE Button}
    Run Keyword And Ignore Error    Page Should Contain Element    ${EMD REJECT Button}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QRMMD"]}'!=''    Element Should Be Visible    ${QRMMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QCMD"]}'!=''    Element Should Be Visible    ${eQA APPROVER Name}    #${QCMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH' or '${data_dict["isDueDillgenceEngagement"].upper()}'=='T' or '${data_dict["isPciEngagement"].upper()}'=='T'    Element Should Be Visible    ${eQA APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH' or '${data_dict["CRAR"].upper()}'=='INCREASED'    Element Should Be Visible    ${RMD APPROVER Name}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["CRAR"].upper()}'=='HIGH'    Element Should Be Visible    ${QRMMD APPROVER Name}
    log    ${data_dict['EMDApprove']}
    log    ${Submit_STATUS}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["EMDApprove"].upper()}'!='' and '${Submit_STATUS.upper()}'=='YES'    EMD Approval    ${data_dict}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QCMDApprove"].upper()}'!='' and '${Submit_STATUS.upper()}'=='YES'    QCMD Approval    ${data_dict}
    log    ${Submit_STATUS}
    log    ${data_dict['QRMMDApprove']}
    log    ${data_dict['RMDApprove']}
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["QRMMDApprove"].upper()}'!='' and '${Submit_STATUS.upper()}'=='YES'    QRMMD Approval    ${data_dict}    #previously it was not equal to Yes and then i did it to Equal to Yes'${data_dict["QRMMDApprove"].upper()}'!='' and '${Submit_STATUS.upper()}'!='YES'
    Run Keyword And Continue On Failure    Run Keyword If    '${data_dict["RMDApprove"].upper()}'!='' and '${Submit_STATUS.upper()}'=='YES'    RMD Approval    ${data_dict}
