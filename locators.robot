*** Settings ***
Documentation     A resource file for page element locators.

*** Variables ***
#
#****** MICROSOFT LOGIN (MSL) ******
#
${MSL SIGNOUT Txt}    //div[@id='login_workload_logo_text']
${MSL USE ANOTHER ACCOUNT}    //div[@id='otherTileText']
${MSL USERNAME Input}    //input[@aria-label='Enter your email, phone, or Skype.']
${MSL PASSWORD Input}    //input[@name='passwd']
${MSL NEXT Btn}    //input[@value='Next']
${MSL SIGN IN Btn}    //input[@value='Sign in']
${MSL BACK ARROW Btn}    //button[@id='idBtn_Back']
#
#****** COMMON ELEMENTS (COM) ******
#
${FILTER Input}    //input[@id='quickFilterInput']
${EXPORT Btn}     //button[text()='Export']
${PREVIOUS Btn}    //li[text()='Previous']
${NEXT Btn}       //li[text()='Next']
${N SAVE Button}    //button[@class='save-btn']
${REFRESH Button}    //button[contains(normalize-space(.), 'Refresh')]
${SAVE Button}    //button[text()='Save']
${Shell Save Button}    (//button[@id= 'saveShellButton'])[2]
${Close Opp Save Button}    //button[contains(normalize-space(.), 'Save & Close')]
${Close Opp Close Button}    //button[@name='close']/span
#
#****** TOP NAVIGATION ******
#
${IMANAGE HOME Link}    //a/span[@class="sprite_iManageAssistantLogo2"]
${IBudget-IManage Link}    //a[@href= '${TEST_URL}']
${HOME Link}      //a[text()="Home"]
${ADD ENGAGE Link}    //a[text()="Add Engagement"]
${LOGOUT Link}    //span[@class='logoutbtn']
#
#
#****************************************** HOME PAGE ******************************************
#
#****** IMANAGE HOME PAGE ******
#
${MY OPP&ENGAGE TILE Link}    //img[@src="/assets/iManage_ShellFilterlistTile.png"]
#${MY OPP&ENGAGE TILE Link}    //a[@ng-reflect-router-link="/engagements/shellFilter"]
${ACCOUNTS TILE Link}    //li[@id='account']/QRMMD SEARCH imga
${OPPORTUNITIES TILE Link}    //li[@id='opportunity']/a
${BUDGETS TILE Link}    //li[@id='Budgets']/a
${ERA TILE Link}    //li[@id='era']/a
${ISHARE TILE Link}    //li[@id='permission']/a
${PMTOOLBOX TILE Link}    //li[@id='pmToolbox']/a
${HUB TILE Link}    //li[@id='hub']/a
#
#
#****************************************** PERMISSIONS ******************************************
#
#
${PERM MANAGE PERMISSIONS Btn}    //button[@class='manage-permission-btn']    #(//button[@class='ng-tns-c11-1'])[2]
${PERM GO BACK btn}    //button[text()='Go Back']
${PERM GRANT USER Input}    //div[text()='Select a user to share this engagement with:']/following-sibling::div[1]//input[@class='dx-texteditor-input']
${PERM REMOVE USER Input}    //div[text()='Current Permissions:']/following-sibling::div[1]//input[@class='dx-texteditor-input']
${PERM REMOVE USER ERROR MSG}    //div[text()='Cannot remove permissions for auto-assigned user.']
${PERM REMOVE USER ALERT Text}    You have selected a person to remove access from the current Engagement. Are you sure?
#
#
#****************************************** ASSISTANT ******************************************
#
${HAMBURGER Btn}    //div[contains(@class, 'hamburger')]
${ASSIST LOGO img}    //span[contains(@class, 'sprite_iManageAssistantLogo')]
${ASSIST HOME Link}    //a[contains(normalize-space(.), 'Home')]
${ASSIST MY OPP&ENGAGE Link}    //a[contains(normalize-space(.), 'iManage Shell') and contains(@class, 'dropdown-toggle')]
${ASSIST ACCOUNT/CLIENT Link}    //a[contains(normalize-space(.), 'Account / Client') and contains(@class, 'dropdown-toggle')]
${ASSIST NO ACCOUNT/CLIENT TEXT}    //p[contains(normalize-space(.), 'No Account/Client record selected.')]
${ASSIST SALESFORCE ACCOUNT Link}    //a[contains(normalize-space(.), 'Salesforce Account')]
${ASSIST COLLABORATION Link}    //a[contains(normalize-space(.), 'Collaboration') and contains(@class, 'dropdown-toggle')]
${ASSIST NO COLLABORATION TEXT SHELL FILTER LIST}    //p[contains(normalize-space(.), 'Teams Site has not been created.')]
${ASSIST TEAMS SITE Link}    //a[contains(normalize-space(.), 'Teams Site')]
${ASSIST OPPORTUNITY Link}    //a[contains(normalize-space(.), 'Opportunity') and contains(@class, 'dropdown-toggle')]
${ASSIST New Change Order Link}    //img[@id= 'imgCreateOpportunity']
${ASSIST NO OPPORTUNITY TEXT SHELL FILTERLIST}    //p[contains(normalize-space(.), 'No Salesforce opportunity has been linked for this engagement.')]
${ASSIST SALESFORCE Opportunity Link}    //a[contains(normalize-space(.), 'Salesforce Opportunity')]
${ASSIST ERA Link}    //a[contains(normalize-space(.), 'ERA') and contains(@class, 'dropdown-toggle')]
${ASSIST ERA Unlink Confirmation OK}    //button[text()='OK']
${ASSIST ERA Unlink Confirmation Cancel}    //button[text()='Cancel']
${ASSIST NO ERA TEXT SHELL FILTERLIST}    //p[contains(normalize-space(.), 'No ERA has been created/linked for this engagement.')]
${ASSIST BUDGETS Link}    //a[contains(normalize-space(.), 'Budgets')]
${ASSIST NO SUB BUDGET TEXT SHELL FILTERLIST}    //p[contains(normalize-space(.), 'Main Budget has not been created/linked for this engagement.')]
${ASSIST NO COLLABORATION TEXT}    //p[contains(normalize-space(.), 'Shell is incomplete; Teams Site has not been created.')]
${ASSIST COLLABORATION CREATION TEXT}    //p[contains(normalize-space(.), 'Teams Site creation in progress.')]
${ASSIST CREATE TEAMS Link}    //li[span[contains(normalize-space(.), 'Teams')]]//img[@title='Create']
${ASSIST TEAMS SITE Link}    //a[contains(normalize-space(.), 'Teams Site')]
${ASSIST OPPORTUNITY Link}    //a[contains(normalize-space(.), 'Opportunity') and contains(@class, 'dropdown-toggle')]
${ASSIST NO OPPORTUNITY TEXT}    //p[contains(normalize-space(.), 'Shell is incomplete; Salesforce Opportunity has not been created.')]
${ASSIST OPPORTUNITY CREATION TEXT}    //p[contains(normalize-space(.), 'Salesforce Opportunity creation in progress.')]
${ASSIST SALESFORCE Opportunity Link}    //a[contains(normalize-space(.), 'Salesforce Opportunity')]
${ASSIST ERA Link}    //a[contains(normalize-space(.), 'ERA') and contains(@class, 'dropdown-toggle')]
${ASSIST NO ERA TEXT}    //p[contains(normalize-space(.), 'Shell is incomplete; ERA has not been created/linked.')]
${ASSIST ERA CREATE img}    //img[@title='Create']
${ASSIST ERA LINK img}    //img[@title='Link']
${ASSIST ERA UNLINK img}    //li[a[contains(normalize-space(.), 'ERA')]]//img[@title='Unlink']
${ASSIST BUDGETS Link}    //a[contains(normalize-space(.), 'Budgets')]
${ASSIST BUDGETS CREATE img}    //img[@title= 'Create']
${ASSIST NO SUB BUDGET TEXT}    //p[contains(normalize-space(.), 'Shell is incomplete; Main Budget has not been created.')]
${ASSIST BUDGET CREATION TEXT}    //p[contains(normalize-space(.), 'Main Budget creation in progress.')]
${ASSIST SUB BUDGET CREATE img}    //img[@title='Create']
${ASSIST SUB BUDGET COPY img}    //img[@title='Copy']
${ASSIST SUB BUDGET LINK img}    //img[@title='Link']
${ASSIST SUB BUDGET UNLINK img}    //img[@title='Unlink']
${ASSIST PKIC REQUEST Link}    //a[contains(normalize-space(.), 'PKIC Request')]
${ASSIST PKIC INCOMPLETE TEXT}    //p[contains(normalize-space(.), 'Shell is incomplete.')]
${ASSIST CDR CREATE Link}    //li[span[contains(normalize-space(.), 'Company Discovery Packet')]]//img[@title='Create']
${ASSIST PKIC CREATE Link}    //li[span[contains(normalize-space(.), 'Proposal, Research, Design')]]//img[@title='Create']
${ASSIST VIEW PKIC Link}    //a[contains(normalize-space(.), 'View My Requests')]
${ASSIST MESSAGE text}    //p[contains(normalize-space(.), 'This object has not been created/linked through iManage Assistant.')]
${ASSIST OPPORTUNITY CREATED LINK}    //div[contains(normalize-space(.), 'Original Salesforce Opportunity')]
${ASSIST CHANGE ORDER IMG}    //img[@id='imgCreateOpportunity']
${ASSIST COLLABORATION IMG}    //img[@id='imgCreateTeam']
${ASSIST COLLABORATION TeamSiteTEXT}    //span[@id='spanCreateTeam']
#
#****************************************** OPPORTUNITIES AND ENGAGEMENT ******************************************
#
#****** OPPORTUNITIES AND ENGAGEMENT PAGE (Filter List) ******
#
${SHELL HEADER Link}    //a[span[text()='My Opportunities & Engagements']]
${OPEN Btn}       //button[text()='Open']
${Shell Tab dropdown}    //div[@class= 'open-filter-dropdown']//div[@role= 'button']
${CREATE NEW SHELL Btn}    //button[text()='New']
${EXPORT SHELL Btn}    //button[text()='Export']
${SHELL ACCOUNT/CLIENT FILTER input}    //td[@aria-label="Column Account/Client, Filter cell"]//input
${SHELL OPP/ENG FILTER input}    //td[@aria-label="Column Shell Name, Filter cell"]//input
${SHELL DEPT FILTER input}    //td[@aria-label="Column Department, Filter cell"]//input
${SHELL LEAD EMD FILTER input}    //td[@aria-label="Column Lead EMD, Filter cell"]//input
${SHELL LEAD EM FILTER input}    //td[@aria-label="Column Lead EM, Filter cell"]//input
${SHELL STATUS FILTER input}    //td[@aria-label="Column Status, Filter cell"]//input
${SHELL CREATED BY FILTER input}    //td[@aria-label="Column Created By, Filter cell"]//input
${SHELL CREATED FILTER input}    //td[@aria-label="Column Created, Filter cell"]//input
${SHELL CLOSED FILTER input}    //td[@aria-label="Column Closed, Filter cell"]//input
${SHELL BOTTOM ERROR MSG Label}    //div[@class="error"]
${SHELL ALERT CANNOT DELETE text}    Record cannot be deleted when objects are linked. Please unlink objects through the iManage Assistant and retry.
${OPP CREATE NEW btn}    //button[contains(normalize-space(.), 'Create New Opportunity')]
${OPP LINK EXISTING btn}    //button[contains(normalize-space(.), 'Link Existing Opportunity')]
${OPP LINK EXISTING CONFIRM HEADER}    //h4[text()= 'Was your Opportunity created directly in Salesforce?']
${OPP LINK EXISTING CONFIRM text}    //button[contains(normalize-space(.), 'Yes, I need to link an existing opportunity')]
${OPP LINK EXISTING NEGATE text}    //button[contains(normalize-space(.), 'Cancel & Return to Shell Filter List')]
${Link Opp Button}    (//div[text()='Link'])[1]
${No Data Txt}    //div[@role= 'presentation']//span[contains(normalize-space(.), 'No data')]
${ASSIST SHELL FILTER LIST}    //div[@class= 'detailTop']
#
#****** NEW ENGAGEMENT FORM ******
#
${SHELL FILTER Link}    //span[contains(normalize-space(.), 'iManage')]
${SFDC Opportunity Creation Link}    //a[contains(normalize-space(.), 'Click here to access / update')]
${OPPORTUNITY STATUS MAX/MIN BUTTON}    //button[@class= 'progress-minimize-button']
${OPPORTUNITY STATUS BAR}    //div[@class='right progress-minimize-bar']
${CO OPPORTUNITY STATUS BAR}    //div[@class='progress-minimize-bar']
${OPPORTUNITY STATUS-INCOMPLETE SHELL}    //div[contains(normalize-space(.),'Form is incomplete; no Salesforce Opportunity has been created.')]
${OPPORTUNITY STATUS-CREATION TEXT}    //div[contains(normalize-space(.),'Salesforce Opportunity creation in progress.')]
${OPPORTUNITY STATUS-SUCCESS CREATION}    //div[contains(normalize-space(.),'Opportunity created. ')]
${OPPORTUNITY STATUS-SFDC LINK}    //a[contains(normalize-space(.),'View in Salesforce')]
${CO OPPORTUNITY STATUS-CREATION TEXT}    //div[contains(normalize-space(.),'Change Order Salesforce Opportunity creation in progress.')]
${CO OPPORTUNITY STATUS-INCOMPLETE SHELL}    //div[contains(normalize-space(.),'Form is incomplete; no Change Order Salesforce Opportunity has been created.')]
${CO OPPORTUNITY STATUS-SUCCESS CREATION}    //span[contains(normalize-space(.),'Change Order Opportunity created. ')]
${Checked SFDC Opportunity}    //a[contains(normalize-space(.), 'Click here to access / update')]/ancestor::div[@class='form-wrapper']//fa/i
${SHELL NAME Title}    //span[@id='shellname']
${DELETE DRAFT Btn}    //button[@id='deleteButton']
${Delete Comfirmation}    //div[@class= 'prompt']//button[contains(normalize-space(.),'OK')]
${Probability Custom}    //input[@id= 'probability']
${OPPORUNITY DETAIL CLOSED STAGE}    //div[@class= 'form-wrapper']
${ACCOUNT/CLIENT Input}    //input[@id='clientSelect']
${Primary Key Buyer Input}    //input[@id="primaryKeyBuyerSelect"]
${OPPORT/ENGAGE NAME Input}    //input[@id='name']
${DESCRIPTION Textarea}    //textarea[@id='description']
${CONFIDENTIAL Select}    //dx-select-box[@id='confidentialSelect']/div/div/input
${BU/DEPT Select}    //input[@id="departmentSelect"]
${OPP CURRENCY Select}    //input[@id='opportunityCurrencySelect']
${OPP MD Input}    //input[@id='opportunityMDSelect']
${OPP OWNER Input}    //input[@id='opportunityOwnerSelect']
${LEAD EMD Input}    //input[@id='leadEMDSelect']
${LEAD EM Input}    //input[@id='leadEMSelect']
${MANAGE PURSUIT button}    //button[text()='Manage Pursuit Team']
${ADDITIONAL PURSUIT textarea}    //textarea[@id='pursuitTeamMembersSelect']
${SERVICE OFFERING Select}    //input[@id='serviceOfferingSelect']
${SERVICE AMOUNT OPP CUR input}    //input[@id='serviceAmount']
${SERVICE AMOUNT BASE CUR input}    //input[@id='serviceBaseCurrencyAmount']
${ADD SERVICE OFFERING btn}    //button[@id='addServiceOffering']
${DELETE SERVICE OFFERING img}    //img[@src='/assets/Trash_Delete.png']
${IA NATURE Input}    //div[label[@for= 'IANatureSelect']]//input[@role='combobox']
${TRANS SERVICES Input}    //div[label[text()='Transaction Services']]//input[@role='combobox']
${ECOSYSTEM Input}    //input[@id='ecosystemSelect']
${DIGITAL Input}    //div[label[@for= 'DigitalSelect']]//input[@role='combobox']
${MANAGED Solutions Input}    //div[label[text()='Managed Solutions ']]//input[@role='combobox']
${MANAGED SERVICES Input}    //div[label[@for= 'managedServicesSelect']]//input[@role='combobox']
${OPP STAGE Input}    //div[label[text()='Closed Stage']]//input[@role='combobox']
#${OPP CLOSE DATE Input}    //input[@id='opportunityCloseDateSelect']
#${OPP CLOSE DATE Input}    //input[@name='opportunityCloseDateSelect']
${OPP CLOSE DATE Input}    //div[label[text()='Opportunity Close Date']]//input[@role='combobox']
${PRIMARY REASON Input}    //div[label[text()='Primary Win / Loss Reason ']]//input[@role='combobox']
${OPP SF OPPORTUNITY Input}    //textarea[@id="opportunityURL"]
${Revenue Schedule Link}    //a[contains(normalize-space(.), 'Revenue Schedule')]
${Revenue Schedule Start Date Link}    //dx-date-box[@id= 'calculateForMeStartDateSelect']//div[@role= 'button']
#${Revenue Schedule Start Date-Year Link}    //label[contains(normalize-space(.), 'Start Date - Year')]/following-sibling::div//input[@class]
${Revenue Schedule Number of months input}    //input[@formcontrolname= 'calculateForMeNumberOfMonthsSelect']
${Revenue Schedule Calculate button}    //button[text()=' Calculate']
${Revenue Schedule Clear Schedule}    //a[text()= 'Clear Schedule']
${Save & Close}    //button[text()='Save & Close']    #For Closing the Oppurtunity
#
#******Error Msgs On Shell
#
${ErrorSectionPath}    //div[@class='error-section']
${WrapperErrorSectionPath}    //div[@class= 'error-wrapper']
${ErrorMsg_ApprovedERA}    Please unlink the Submitted/Approved ERA before updating the Account to a company from a different Account Hierarchy (i.e., with a different Parent Account).
${ErrorMsg_SFDC_ERA}    Client cannot be updated because there is a linked Salesforce ERA.
${ErrorMsgNonMandatory}    Form saved with missing fields. The fields highlighted in red are required to progress with opportunity/engagement setup.
#
#******Engagement Checklist******
#
${Checked Salesforce opportunity created}    //span[contains(normalize-space(.), 'Salesforce Opportunity Created') and contains(@class, 'checklist-item-checked')]
${Checked Primary Key Identifier}    //span[contains(normalize-space(.), 'Primary Key Buyer Identified') and contains(@class, 'checklist-item-checked')]
${Checked ERA Created}    //span[contains(normalize-space(.), 'ERA Created') and contains(@class, 'checklist-item-checked')]
${Checked ERA Approved}    //span[contains(normalize-space(.), 'ERA Approved') and contains(@class, 'checklist-item-checked')]
${UnChecked ERA created}    //span[contains(normalize-space(.), 'ERA Created') and contains(@class, 'checklist-item-nocheck')]
${UnChecked ERA Approved}    //span[contains(normalize-space(.), 'ERA Approved') and contains(@class, 'checklist-item-nocheck')]
#
#****** ADDITIONAL PURSUIT TEAM / Manage Permission ******
#
${APT NAME FILTER input}    //td[@aria-label="Column Name, Filter cell"]//input
${ADD/DELETE img}    //td[text()='QA, qasamsha05pod2']/following-sibling::td//img
${OTHER PURSUIT INPUT textarea}    //textarea[@id='pursuitTeamOthers']
#
#****** Link ERA Page ******
#
${IManageERA Button}    //button[contains(normalize-space(.), 'iManage ERA')]
${Salerforce ERA Button}    //button[contains(normalize-space(.), 'Salesforce ERA')]
${ApprovedERALink}    //div[@class= 'closePopupBtn'][1]
${SFDC URL Input}    //div[@class='saleforceView ng-star-inserted']//input
${SFDC Save Button}    //button[text()= 'Save']
#
#****** EXISTING ENGAGEMENT FORM ******
#
${SHELL NAME Title}    //span[@id='shellname']
#${MANAGE PERM Btn}    //button[@id='managePermissionsButton']    #Duplicate.. not needed.. Use the ${PERM MANAGE PERMISSIONS Btn} locator for tests
${DELETE DRAFT Btn}    //button[@id='deleteButton']
${ACCOUNT/CLIENT Input}    //input[@id='clientSelect']
${OPPORT/ENGAGE NAME Input}    //input[@id='name']
${DESCRIPTION Textarea}    //textarea[@id='description']
${SERVICE OFFERING Select}    //input[@id='serviceOfferingSelect']
${BU/DEPT Select}    //input[@id="departmentSelect"]
${LEAD EMD Input}    //input[@id='leadEMDSelect']
${LEAD EM Input}    //input[@id='leadEMSelect']
${IA NATURE Input}    //div[label[text()='IA Nature of Work']]//input[@role='combobox']
${TRANS SERVICES Input}    //div[label[text()='Transaction Services']]//input[@role='combobox']
${DIGITAL Input}    //div[label[text()='Digital']]//input[@role='combobox']
${MANAGED SERVICES Input}    //div[label[text()='Managed Services']]//input[@role='combobox']
${CONFIDENTIAL Select}    //dx-select-box[@id='confidentialSelect']/div/div/input
${OP SF OPPORTUNITY Input}    //textarea[@id="opportunityURL"]
${OP CLOSE DATE Input}    //input[@id='closeDateSelect']
#
#
#****************************************** ERA ******************************************
#
#
#****** ERA FILTER LIST ******
#
${ERA HOME Link}    //span[contains(normalize-space(.),'ERA')]
${FILTER LIST Link}    //a[text()="Filter List"]
${DRAFT ERA Btn}    //button[text()='Draft ERAs']
${ERA AWAITING APPROVE Btn}    //button[text()='ERAs Awaiting Approval']
${APPROVED ERAS Btn}    //button[text()='Approved ERAs']
${CREATE NEW ERA Btn}    //button[text()='New']    #No longer available
${CLIENT NAME FILTER Input}    //td[@aria-label="Column Client Name, Filter cell"]//input
${ERA NAME FILTER Input}    //td[@aria-label="Column ERA Name, Filter cell"]//input
${EMD FILTER Input}    //td[@aria-label="Column EMD, Filter cell"]//input
${EM FILTER Input}    //td[@aria-label="Column EM, Filter cell"]//input
${STATUS FILTER Input}    //td[@aria-label="Column Status, Filter cell"]//input
${ASSIGN TO FILTER Input}    //td[@aria-label="Column Assigned To, Filter cell"]//input
${FINAL RISK RATING FILTER Input}    //td[@aria-label="Column Final Risk Rating, Filter cell"]//input
${CREATED BY FILTER Input}    //td[@aria-label="Column Created By, Filter cell"]//input
${CREATED DATE FILTER Input}    //td[@aria-label="Column Created Date, Filter cell"]//input
${APPROVED DATE FILTER Input}    //td[@aria-label="Column Approved Date, Filter cell"]//input
${EMD REVIEW RadioBtn}    //label[@id='EMDReview']/input
${SUBMITTED RadioBtn}    //label[@id='submitted1']/input
${ALL RadioBtn}    //label[@id='all1']/input
${RECENT ERAS RadioBtn}    //label[@id='approved1']/input
${ALL ERAS RadioBtn}    //label[@id='approved']/input
${FILTER Btn}     //div[@title='Apply filter']
#
#****** PERMISSIONS PAGE ******
#
${TBD}            //input[@id='quickFilterInput']
#
#****** ERA PAGE ******
#
${ENGAGEMENT TITLE}    //div[@id='quickFilterInput']
${PART1 Link}     (//a[contains(normalize-space(.), 'Part')])[1]
${PART2 Link}     (//a[contains(normalize-space(.), 'Part')])[2]
${FINAL SUMMARY Link}    //a[contains(normalize-space(.), 'Final Summary')]
${RMAP Link}      //a[contains(normalize-space(.), 'RMAP')]
${QC MD PLAN Link}    //a[contains(normalize-space(.), 'QC MD Plan')]
${eQA Plan Link}    //a[contains(normalize-space(.), 'eQA Plan')]
${APPROVALS Link}    //a[contains(normalize-space(.), 'Approvals')]
${ApproveByADMIN}    //input[@value='Approve']
${OVERALL RISK Gauge}    //div[@id='o']
${HEADER CERA RATING Text}    xpath=(//div[contains(normalize-space(.), 'Client / ERA Setup')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
#${HEADER BICC RATING Text}    xpath=(//div[contains(normalize-space(.), 'Client / ERA Setup')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
${HEADER PART1 RATING Text}    xpath=(//div[contains(normalize-space(.), 'Part 1')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
${HEADER PART2 RATING Text}    xpath=(//div[contains(normalize-space(.), 'Part 2')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
#${ERA NAME Input}    //textarea[@name="eraName"]
${ERA NAME Input}    //input[@name="eraName"]
#${SF OPPORTUNITY Input}    //textarea[@name="SalesforceOpportunity"]
${SF OPPORTUNITY Input}    //textarea[@id="salesforceUrlText"]
${SF OPPORTUNITY ERROR MSG Label}    //div[contains(normalize-space(.), 'Salesforce Opportunity')]/label
${NEW CLIENT chkbox}    //input[@name="isNewClient"]
${LOAN STAFF chkbox}    //input[@name="isLoanStaff"]
${PCI ENGAGE chkbox}    //input[@name="isPciEngagement"]
${SOFTWARE RESELL chkbox}    //input[@name="isSoftwareResell"]
${FINANCIAL MODEL chkbox}    //input[@name="isFinancialModelEngagement"]
${CROSS BORDER TRAVEL chkbox}    //input[@name="isCrossBorderTravel"]
${M&A DUE DIL ENGAGE chkbox}    //input[@name="isDueDillgenceEngagement"]
${GOV ENGAGE chkbox}    //input[@name="isGovernmentEngagement"]
${VUL PEN SOL ENG ENGAGE chkbox}    //input[@name="isSocialEngineeringEngagement"]
${USE CONTRACTORS chkbox}    //input[@name="isContractorUsed"]
${CLIENT NAME Input}    //input[@name='clientName']
${CLIENT SEARCH img}    //span[@id='clientSelect']
${CLIENT CODE Input}    //input[@name='clientCode']
${CLIENT SIZE Select}    //*[@id='clientSizes']/div/div/input
${CLIENT LEGAL STRUCTURE Select}    //*[@id='clientLegalStructure']/div/div/input
${CLIENT LEGAL DISPLAY TEXT}    //*[@id='clientLegalStructure']/div/input
${ENGAGE DESCRIPT Textarea}    //textarea[@name='engagementDescription']
${PCOUNTRY JOB CONTRACTED Select}    //*[@id='principalCountryJobCreated']/div[1]/div/input
${PCOUNTRY WORK PERFORMED Input}    //input[@name='principalCountryWorkPerformed']
${EMD SEARCH img}    xpath=(//span[@id='EMDSelect'])[1]
${EMD Input}      //input[@name='managingDirectorName']
${EMD OFFICE Input}    //input[@name='emdOffice']
${EM SEARCH img}    xpath=(//span[@id='EMDSelect'])[2]
${EM Input}       //input[@name='engagementManager']
${MSA REQUIRED Select}    //*[@id='isMsaRequired']/div/div/input
${SOW REQUIRED Select}    //*[@id='isSowRequired']/div/div/input
${ERA CONFIDENTIAL Select}    //*[@id='isConfidential']/div/input
#${ERA CONFIDENTIAL Select}    //*[@id='isConfidential']/div/div/input    ##Testing new input
${EST DURATION Select}    //*[@id='estimatedDuration']/div/div/input
${EST NET FEES Select}    //*[@id='estimatedNetFees']/div/div/input
${EST CONT MARGIN Input}    //input[@name='estimatedContributionMargin']
#${SAVE Button}    //button[text()='Save']    # See common elements for dynamic Save Button Locator
${PREVIOUS Button}    //button[text()='Previous']
${SAVE & NEXT Button}    //button[text()='Save & Next']
${Validate & Submit to EMD}    //button[contains(normalize-space(.), 'Validate & Submit to EMD')]
#
#****** ERA PART1 ******
#
${PART 1 Header}    //div[@id='EraQuestionsPart1']/h2
${QUESTION 1a YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q1a.pickedValue1"]
${QUESTION 1a NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q1a.pickedValue1"]
${QUESTION 1a Textarea}    //textarea[@id='1aTextArea']
${QUESTION 1b YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q1b.pickedValue1"]
${QUESTION 1b NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q1b.pickedValue1"]
${QUESTION 1b Textarea}    //textarea[@id='1bTextArea']
${QUESTION 2 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q2.pickedValue1"]
${QUESTION 2 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q2.pickedValue1"]
${QUESTION 2 Textarea}    //textarea[@id='2TextArea']
${QUESTION 3 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q3.pickedValue1"]
${QUESTION 3 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q3.pickedValue1"]
${QUESTION 3 Textarea}    //textarea[@id='3TextArea']
${QUESTION 4a(1) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a.pickedValue1"]
${QUESTION 4a(1) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a.pickedValue1"]
${QUESTION 4a(1) Textarea}    //textarea[@id='4aTextArea']
${QUESTION 4a(2) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a.pickedValue2"]
${QUESTION 4a(2) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a.pickedValue2"]
${QUESTION 4a(2) Textarea}    //textarea[@id='4aaTextArea']
${QUESTION 4a-1(1) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a1.pickedValue1"]
${QUESTION 4a-1(1) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a1.pickedValue1"]
${QUESTION 4a-1(1) Textarea}    //textarea[@id='4a1TextArea']
${QUESTION 4a-1(2) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a1.pickedValue2"]
${QUESTION 4a-1(2) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a1.pickedValue2"]
${QUESTION 4a-1(2) Textarea}    //textarea[@id='4a1aTextArea']
${QUESTION 4a-2(1) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a2.pickedValue1"]
${QUESTION 4a-2(1) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a2.pickedValue1"]
${QUESTION 4a-2(1) Textarea}    //textarea[@id='4a2TextArea']
${QUESTION 4a-2(2) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a2.pickedValue2"]
${QUESTION 4a-2(2) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a2.pickedValue2"]
${QUESTION 4a-2(2) Textarea}    //textarea[@id='4a2aTextArea']
${QUESTION 4a-3(1) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a3.pickedValue1"]
${QUESTION 4a-3(1) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a3.pickedValue1"]
${QUESTION 4a-3(1) Textarea}    //textarea[@id='4a3TextArea']
${QUESTION 4a-3(2) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4a3.pickedValue2"]
${QUESTION 4a-3(2) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4a3.pickedValue2"]
${QUESTION 4a-3(2) Textarea}    //textarea[@id='4a3aTextArea']
${QUESTION 4b(1) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4b.pickedValue1"]
${QUESTION 4b(1) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4b.pickedValue1"]
${QUESTION 4b(2) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4b.pickedValue2"]
${QUESTION 4b(2) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4b.pickedValue2"]
${QUESTION 4b(2) Textarea}    xpath=(//textarea[@id='4baTextArea'])[1]
${QUESTION 4b(3) YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q4b.pickedValue3"]
${QUESTION 4b(3) NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q4b.pickedValue3"]
${QUESTION 4b(3) Textarea}    xpath=(//textarea[@id='4baTextArea'])[2]
${QUESTION 4c Textarea}    //textarea[@id='4cTextArea']
${QUESTION 5 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q5.pickedValue1"]
${QUESTION 5 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q5.pickedValue1"]
${QUESTION 5 Textarea}    //textarea[@id='5TextArea']
${QUESTION 6a YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q6a.pickedValue1"]
${QUESTION 6a NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q6a.pickedValue1"]
${QUESTION 6a Textarea}    //textarea[@id='6aTextArea']
${QUESTION 6b YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q6b.pickedValue1"]
${QUESTION 6b NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q6b.pickedValue1"]
${QUESTION 6b(1) Textarea}    xpath=(//textarea[@id='6bTextArea'])[1]
${QUESTION 6b(2) Textarea}    xpath=(//textarea[@id='6bTextArea'])[2]
${QUESTION 6c YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q6c.pickedValue1"]
${QUESTION 6c NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q6c.pickedValue1"]
${QUESTION 6c Textarea}    //textarea[@name="q6c.note1"]    #ID of element is blank
${QUESTION 6d YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q6d.pickedValue1"]
${QUESTION 6d NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q6d.pickedValue1"]
${QUESTION 6d Textarea}    //textarea[@name='q6d.note1']    #differs in locator name from other textarea instances
${QUESTION 7 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q7.pickedValue1"]
${QUESTION 7 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q7.pickedValue1"]
${QUESTION 7 Textarea}    //textarea[@id='7TextArea']
${QUESTION 8a YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q8a.pickedValue1"]
${QUESTION 8a NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q8a.pickedValue1"]
${QUESTION 8a Textarea}    //textarea[@id='8aTextArea']
${QUESTION 8b YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q8b.pickedValue1"]
${QUESTION 8b NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q8b.pickedValue1"]
${QUESTION 8b Textarea}    //textarea[@id='8bTextArea']
${QUESTION 9 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q9.pickedValue1"]
${QUESTION 9 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q9.pickedValue1"]
${QUESTION 9 Textarea}    //textarea[@id='9TextArea']
${QUESTION 10 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q10.pickedValue1"]
${QUESTION 10 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q10.pickedValue1"]
${QUESTION 10 Textarea}    //textarea[@id='10TextArea']
${QUESTION 11a YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q11a.pickedValue1"]
${QUESTION 11a NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q11a.pickedValue1"]
${QUESTION 11a Textarea}    //textarea[@id='11aTextArea']
${QUESTION 11b YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q11b.pickedValue1"]
${QUESTION 11b NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q11b.pickedValue1"]
${QUESTION 11b Textarea}    //textarea[@id='11bTextArea']
${QUESTION 11c YES Radio}    //fieldset[@id='Q11c']//input[@ng-reflect-value="2"]    #Differs from other similar element names    #//div[contains(normalize-space(.), 'Yes')]/input[@name="q11c.pickedValue1"]
${QUESTION 11c NO Radio}    //fieldset[@id='Q11c']//input[@ng-reflect-value="1"]    #Differs from other similar element names    #//div[contains(normalize-space(.), 'No')]/input[@name="q11c.pickedValue1"]
${QUESTION 11c Textarea}    //textarea[@id='11cTextArea']
${QUESTION 12 Textarea}    //textarea[@id='12TextArea']
${QUESTION 13 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q13.pickedValue1"]
${QUESTION 13 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q13.pickedValue1"]
${QUESTION 13 Textarea}    //textarea[@id='13TextArea']
#
#
#****** ERA PART2 ******
#
${PART 2 Header}    //div/h2[text()='Part 2']
${QUESTION 14 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q14.pickedValue1"]
${QUESTION 14 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q14.pickedValue1"]
${QUESTION 14 Textarea}    //textarea[@name="q14.note1"]
${QUESTION 15 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q15.pickedValue1"]
${QUESTION 15 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q15.pickedValue1"]
${QUESTION 15 Textarea}    //textarea[@name="q15.note1"]
${QUESTION 16a YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q16a.pickedValue1"]
${QUESTION 16a NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q16a.pickedValue1"]
${QUESTION 16a Textarea}    //textarea[@name="q16a.note1"]
${QUESTION 16a-1 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name=".q16a1.pickedValue1"]
${QUESTION 16a-1 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name=".q16a1.pickedValue1"]
${QUESTION 16a-1 Textarea}    //textarea[@name="q16a1.note1"]
${QUESTION 16a-2 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q16a2.pickedValue1"]
${QUESTION 16a-2 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q16a2.pickedValue1"]
${QUESTION 16a-2 Textarea}    //textarea[@name="q16a2.note1"]
${QUESTION 16a-3 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q16a3.pickedValue1"]
${QUESTION 16a-3 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q16a3.pickedValue1"]
${QUESTION 16a-3 Textarea}    //textarea[@name="q16a3.note1"]
${QUESTION 16a-4 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q16a4.pickedValue1"]
${QUESTION 16a-4 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q16a4.pickedValue1"]
${QUESTION 16a-4 Textarea}    //textarea[@name="q16a4.note1"]
${QUESTION 16a-5 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q16a5.pickedValue1"]
${QUESTION 16a-5 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q16a5.pickedValue1"]
${QUESTION 16a-5 Textarea}    //textarea[@name="q16a5.note1"]
${QUESTION 16a-6 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q16a6.pickedValue1"]
${QUESTION 16a-6 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q16a6.pickedValue1"]
${QUESTION 16a-6 Textarea}    //textarea[@name="q16a6.note1"]
${QUESTION 16b YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q16b.pickedValue1"]
${QUESTION 16b NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q16b.pickedValue1"]
${QUESTION 16b Textarea}    //textarea[@name="q16b.note1"]
${QUESTION 17a YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q17a.pickedValue1"]
${QUESTION 17a NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q17a.pickedValue1"]
${QUESTION 17a Textarea}    //textarea[@name="q17a.note1"]
${QUESTION 17b YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q17b.pickedValue1"]
${QUESTION 17b NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q17b.pickedValue1"]
${QUESTION 17b Textarea}    //textarea[@name="q17b.note1"]
${QUESTION 18 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q18.pickedValue1"]
${QUESTION 18 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q18.pickedValue1"]
${QUESTION 18 Textarea}    //textarea[@name="q18.note1"]
${QUESTION 19 Textarea}    //textarea[@name="q19.note1"]
${QUESTION 20 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q20.pickedValue1"]
${QUESTION 20 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q20.pickedValue1"]
${QUESTION 20 Textarea}    //textarea[@name="q20.note1"]
${QUESTION 21 Textarea1}    //textarea[@name="q21.note2"]
${QUESTION 21 YES Radio}    //div[contains(normalize-space(.), 'Yes')]/input[@name="q21.pickedValue1"]
${QUESTION 21 NO Radio}    //div[contains(normalize-space(.), 'No')]/input[@name="q21.pickedValue1"]
${QUESTION 21 Textarea2}    //textarea[@name="q21.note1"]
#
#****** ERA RMAP/QCMD ******
#
${RMAP Header}    //div/h2[text()='RMAP']
${QCMD Plan Header}    //div/h2[text()='QC MD Plan']
${STEP Input}     //div/div/div[@class="blulabel"]//div/textarea
${EXPORT RMAP Button}    //button[text()='Export RMAP']
${EXPORT QCMD PLAN Button}    //button[text()='Export QC MD Plan']
${EXPORT eQA Lead Plan Button}    //button[text()=' Export eQA Lead Plan ']
${ADD Button}     //button[text()='Add Row']
${DELRTR ROW Button}    //button[text()='Delete unused rows']
${eQA Lead Plan Header}    //div/h2[text()='eQA Lead Plan']
#
#****** RATING SUMMARY ******
#
${SUMMARY Header}    //div/h2[text()='Rating Summary']
#${BICC RATING Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'ERA Setup')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
${CERA RATING Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'ERA Setup')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
${PART1 RATING Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'Part 1')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
${PART2 RATING Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'Part 2')]/following-sibling::div[span[contains(normalize-space(.), 'Rating:')]])[1]
${CERA STATUS Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'ERA Setup')]/following-sibling::div[span[contains(normalize-space(.), 'Status:')]]/a)[1]
#${BICC STATUS Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'ERA Setup')]/following-sibling::div[span[contains(normalize-space(.), 'Status:')]]/a)[1]
${PART1 STATUS Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'Part 1')]/following-sibling::div[span[contains(normalize-space(.), 'Status:')]]/a)[1]
${PART2 STATUS Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'Part 2')]/following-sibling::div[span[contains(normalize-space(.), 'Status:')]]/a)[1]
${RMAP STATUS Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'RMAP')]/following-sibling::div[span[contains(normalize-space(.), 'Status:')]]/a)[1]
${QCMD STATUS Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'QC MD Plan')]/following-sibling::div[span[contains(normalize-space(.), 'Status:')]]/a)[1]
${eQA Lead STATUS Text}    xpath=//fieldset/legend[contains(normalize-space(.), 'Engagement Quality Assessment Lead (eQA Lead)')]
${SUMMARY STATUS Text}    xpath=(//fieldset//div[contains(normalize-space(.), 'Summary')]/following-sibling::div[span[contains(normalize-space(.), 'Status:')]]/a)[1]
${CRAR VALUE text}    //fieldset/legend[text()='Calculated Risk Assessment Rating']/following-sibling::div[2]
${FRAR Select}    //fieldset[legend[text()='Final Risk Assessment Rating']]/div/select
${FRAR Textarea}    //div[contains(normalize-space(.), 'Please explain if the Final Risk')]/following-sibling::div//textarea
${GLMD SECTION HEAD}    //fieldset/legend[text()='Geography Lead Managing Director']
${GLMD NAME text}    //fieldset/legend[text()='Geography Lead Managing Director']/following-sibling::div[2]
${RMD SECTION HEAD}    //fieldset/legend[text()='Regional Managing Director']
${RMD NAME text}    //fieldset/legend[text()='Regional Managing Director']/following-sibling::div[2]
${QRMMD Input}    a
${EMD Input}      //input[@name='managingDirectorName']
${QRMMD SECTION HEAD}    //fieldset/legend[contains(normalize-space(.), 'Quality Risk Management Managing Director (QRM MD)')]
${QRMMD SEARCH img}    (//fieldset/legend[contains(normalize-space(.), 'Quality Risk Management Managing Director (QRM MD)')]/following::div/div/input)[1]
#${QRMMD SEARCH img}    //span[@id='QRMMDSelect']
${QCMD Input}     a
${QCMD SECTION HEAD}    //fieldset/legend[contains(normalize-space(.), 'Quality Control/Second Managing Director (QC MD)')]
${eQA Plan SECTION HEAD}    //fieldset/legend[contains(normalize-space(.), 'Engagement Quality Assessment Lead (eQA Lead)')]
${QCMD SEARCH img}    (//fieldset/legend[contains(normalize-space(.), 'Quality Control/Second Managing Director (QC MD)')]/following::div/div/input)[1]
${eQA SEARCH img}    (//fieldset/legend[contains(normalize-space(.), 'Engagement Quality Assessment Lead (eQA Lead)')]/following::div/div/input)[1]
#${QCMD SEARCH img}    //span[@id='QCMDSelect']
${SUBMIT TO EMD Button}    //button[contains(normalize-space(.), 'Submit to EMD')]
${TOP ERROR MSG Label}    //div[@id='submit_error']/label[text()!='']
${BOTTOM ERROR MSG Label}    //label[@id="eraErrorInfo2" and text()!='']
${BOTTOM ERROR MSG2 Label}    //label[@id="eraErrorInfo3" and text()!='']
${Section:RMAP}    //fieldset[@class='well']//div[contains(normalize-space(.), 'RMAP')]
${FieldRequired}    //i[contains(normalize-space(.), '(Required)')]
${FieldStatus}    //a[contains(normalize-space(.), 'Incomplete')]
${Section: QC MD}    //fieldset[@class='well']//div[contains(normalize-space(.), ' QC MD Plan')]
${Section: eQA Lead Plan}    //fieldset[@class='well']//div[contains(normalize-space(.), ' eQA Lead Plan')]
#
#****** NEW ERA APPROVAL ******
#
${APPROVERS Header}    //div/h2[contains(normalize-space(.), 'Approvers')]
${EMD APPROVER Header}    //legend[text()='Engagement Managing Director (EMD)']
${EMD APPROVE Button}    //legend[text()='Engagement Managing Director (EMD)']/following-sibling::div/ul/li/input[@id='btnApprove']    # use Click Element keyword
${EMD REJECT Button}    //legend[text()='Engagement Managing Director (EMD)']/following-sibling::div/ul/li/input[@id='btnReject']    # use Click Element keyword
${EMD APPROVER Status}    //legend[text()='Engagement Managing Director (EMD)']/following-sibling::div/ul/li[2]/span
${QCMD APPROVE Button}    //legend[text()='Quality Control / Second Managing Director (QC MD)']/following-sibling::div/ul/li/input[@id='btnApprove']
${eQA Lead APPROVE Button}    //legend[text()='Engagement Quality Assessment Lead (eQA Lead)']/following-sibling::div/ul/li/input[@id='btnApprove']
${QCMD REJECT Button}    //legend[text()='Quality Control / Second Managing Director (QC MD)']/following-sibling::div/ul/li/input[@id='btnReject']
${eQA Lead REJECT Button}    //legend[text()='Engagement Quality Assessment Lead (eQA Lead)']/following-sibling::div/ul/li/input[@id='btnReject']
${QCMD APPROVER Status}    //legend[text()='Quality Control / Second Managing Director (QC MD)']/following-sibling::div/ul/li[2]/span
${eQA APPROVER Status}    //legend[text()='Engagement Quality Assessment Lead (eQA Lead)']/following-sibling::div/ul/li[2]/span
${RMD APPROVE Button}    //legend[text()='Regional / Country Market Leader (RMD / CML)']/following-sibling::div/ul/li/input[@id='btnApprove']
${RMD REJECT Button}    //legend[text()='Regional / Country Market Leader (RMD / CML)']/following-sibling::div/ul/li/input[@id='btnReject']
${RMD APPROVER Status}    //legend[text()='Regional / Country Market Leader (RMD / CML)']/following-sibling::div/ul/li[2]/span
${QRMMD APPROVER Status}    //legend[text()='Quality Risk Management Managing Director (QRM MD)']/following-sibling::div/ul/li[2]/span
${QRMMD APPROVE Button}    //legend[text()='Quality Risk Management Managing Director (QRM MD)']/following-sibling::div/ul/li/input[@id='btnApprove']
${QRMMD REJECT Button}    //legend[text()='Quality Risk Management Managing Director (QRM MD)']/following-sibling::div/ul/li/input[@id='btnReject']
${SUBMIT FOR EMD APPROVAL TRACKING Status}    //legend[text()='Submitted for EMD Review']/following-sibling::div//li[text()='Approval Status:']/following-sibling::li/span
${EMD APPROVAL TRACKING Status}    //legend[text()='Engagement Managing Director (EMD)']/following-sibling::div//li[text()='Approval Status:']/following-sibling::li/span
${QCMD APPROVAL TRACKING Status}    //legend[text()='Quality Control / Second Managing Director (QC MD)']/following-sibling::div//li[text()='Approval Status:']/following-sibling::li/span
${eQA Lead APPROVAL TRACKING Status}    //legend[text()='Engagement Quality Assessment Lead (eQA Lead)']/following-sibling::div//li[text()='Approval Status:']/following-sibling::li/span
${QRMMD APPROVAL TRACKING Status}    //legend[text()='Quality Risk Management Managing Director (QRM MD)']/following-sibling::div//li[text()='Approval Status:']/following-sibling::li/span
${RMD APPROVAL TRACKING Status}    //legend[text()='Regional / Country Market Leader (RMD / CML)']/following-sibling::div//li[text()='Approval Status:']/following-sibling::li/span
${QRMMD APPROVAL Pending txt}    //legend[text()='Quality Risk Management Managing Director (QRM MD)']/following-sibling::div/ul/li/span[text()='Pending']
${QCMD APPROVAL Pending txt}    //legend[text()='Quality Control / Second Managing Director (QC MD)']/following-sibling::div/ul/li/span[text()='Pending']
${eQA Lead APPROVAL Pending txt}    //legend[text()='Engagement Quality Assessment Lead (eQA Lead)']/following-sibling::div/ul/li/span[text()='Pending']
${RMD APPROVAL Pending txt}    //legend[text()='Regional / Country Market Leader (RMD / CML)']/following-sibling::div/ul/li/span[text()='Pending']
#
#*******ibudget Main********
#
${iBudget Top Navigation Button}    //div[@class= 'navbar-header']//a[text()= 'iBudget']
${ibudget New Shell Link}    //a[text()= 'Create New Shell']
${ibudget New budget Link}    //a[contains(normalize-space(.), 'Create New Budget')]
${ibudget toggle navigation}    //button[@class= 'navbar-toggle collapsed']
${ibudget project description input}    //table[@id= 'GridView_DXFREditorcol4']//input
${ibudget Main Contracts New Link}    //td[@id= 'ContractsGridView_col0']//span[text()= 'New']
${ibudget Main Contract Form dropdown}    (//td[contains(normalize-space(.), 'Contract Form')])[6]/following-sibling::td//img[@class= 'dxEditors_edtDropDown_Aqua']
${ibudget Main Contract Version dropdown}    (//td[contains(normalize-space(.), 'Contract Version')])[6]/following-sibling::td//img[@class= 'dxEditors_edtDropDown_Aqua']
${ibudget Main Hyperlink input}    //input[@id= 'ContractsGridView_DXEditor3_I']
${ibudget Main Contract Update Link}    //span[text()= 'Update']
${ibudget Main Contract Edit Link}    //a[@id= 'ContractsGridView_DXCBtn1']/span[text()= 'Edit']
${ibudget Main Contract Delete Link}    //a[@id= 'ContractsGridView_DXCBtn2']/span[text()= 'Delete']
${ibudget Main Project Code Input}    //input[@name= 'ProjectCode']
${ibudget Main Save button}    //div[@id= 'Save']
${ibudget Add sub-Budget Link}    //span[text()= 'Add a Budget to This Main']
${ibudget sub Name Input}    //table[@id= 'GridView_DXFREditorcol2']//input
${copy budget Name input}    //input[@name= 'NewBudgetName']
${copy budget Description Filter input}    //input[@id= 'gvCloneBudgets_DXFREditorcol3_I']
#
#*******sub-budget form*******
#
${sub-budget PD Input}    //input[@id= 'Name_I']
${sub-budget Client input}    //input[@id= 'Client_I']
${sub-budget BU dropdown}    //td[@id= 'BusinessUnit_CC']//img
${sub-budget EMD dropdown}    //td[@id= 'gridLookupEMD_CC']//img
${sub-budget EMD Name Filter-list}    //tr[@id= 'gridLookupEMD_DDD_gv_DXFilterRow']//input
${sub-budget EM dropdown}    //td[@id= 'gridLookupEM_CC']//img
${sub-budget EM Name Filter-list}    //tr[@id= 'gridLookupEM_DDD_gv_DXFilterRow']//input
${sub-budget OP Unit dropdown}    //td[@id= 'OperationUnit_CC']//img
${sub-budget Segment dropdown}    //td[@id= 'SolutionSegment_CC']//img
${sub-budget Service Offering dropdown}    //td[@id= 'GridLookupPrimaryService_CC']//img
${sub-budget Service filter-list}    //table[@id= 'GridLookupPrimaryService_DDD_gv_DXMainTable']
${sub-budget Service Offering filter input}    //input[@id='GridLookupPrimaryService_DDD_gv_DXFREditorcol2_I']
${sub-budget Rate Card dropdown}    //td[@id= 'ContractFeeType_CC']//img
${sub-budget create button}    //div[@id= 'Save_CD']
${sub-budget Project Code Input}    //input[@name= 'ProjectCode']
#
#*******sub-budget Basic Project Info page*******
#
${sub-budget Basic Page Info Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Basic Project Info']
${sub-budget Unit Value Estimate Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Unit Value Estimate']
${sub-budget Labor Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Labor']
${sub-budget Expenses Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Expenses']
${sub-budget Unit/Value Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Unit Value Estimate']
${sub-budget Other Fees Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Other Fees']
${sub-budget Consolidated budget Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Consolidated Budget']
${sub-budget Save Button}    //img[@id= 'SaveImg']
${sub-budget Currency Calculator Link}    //span[contains(normalize-space(.), 'Currency Calculator')]
${sub-budget Create/Link with Main Link}    //div[@id= 'HyperLink_createMain_CD']
${sub-budget Contract Rate New Button}    //div[contains(normalize-space(.), 'Contract Rate Card Exception Rates')]//table[@id= 'GVContractRateExcRate_DXMainTable']//img[@title= 'New']
${sub-budget Contract Rate Name dropdown}    //img[@id= 'gridLookup_B-1Img']
${sub-budget Contract Rate Name Input}    //tr[@id= 'gridLookup_DDD_gv_DXFilterRow']//input
${sub-budget Contract Rate Input}    //input[@id= 'GVContractRateExcRate_DXEditor3_I']
${sub-budget Contract Rate Save Changes Link}    //div[contains(normalize-space(.), 'Contract Rate Card Exception Rates')]//table[@id= 'GVContractRateExcRate']//span[text()= 'Save changes']
${sub-budget Contract Rate Cancel Changes Link}    //div[contains(normalize-space(.), 'Contract Rate Card Exception Rates')]//table[@id= 'GVContractRateExcRate']//span[text()= 'Cancel changes']
${sub-budget Contract Rate Edit Link}    (//div[contains(normalize-space(.), 'Contract Rate Card Exception Rates')]//table[@id= 'GVContractRateExcRate']//span[text()= 'Edit'])[2]
${sub-budget Contract Rate Delete Link}    (//div[contains(normalize-space(.), 'Contract Rate Card Exception Rates')]//table[@id= 'GVContractRateExcRate']//span[text()= 'Delete'])[2]
${sub-budget MF/IBU Contract Rate New Button}    //div[contains(normalize-space(.), 'MF / IBU Contract Rate Card Exception Rates')]//table[@id= 'gvResourceContractRate_DXMainTable']//img[@title= 'New']
${sub-budget MF/IBU Contract Rate Name Input}    //input[@id= 'gvResourceContractRate_DXEditor1_I']
${sub-budget MF/IBU Contract Rate Job Function Input}    //input[@id= 'gvResourceContractRate_DXEditor2_I']
${sub-budget MF/IBU Contract Rate Input}    //input[@id= 'gvResourceContractRate_DXEditor3_I']
${sub-budget MF/IBU Contract Rate Save Changes Link}    //div[contains(normalize-space(.), 'MF / IBU Contract Rate Card Exception Rates')]//table[@id= 'gvResourceContractRate']//span[text()= 'Save changes']
${sub-budget MF/IBU Contract Rate Cancel Changes Link}    //div[contains(normalize-space(.), 'MF / IBU Contract Rate Card Exception Rates')]//table[@id= 'gvResourceContractRate']//span[text()= 'Cancel changes']
${sub-budget MF/IBU Contract Rate Edit Link}    //div[contains(normalize-space(.), 'MF / IBU Contract Rate Card Exception Rates')]//table[@id= 'gvResourceContractRate']//span[text()= 'Edit']
${sub-budget MF/IBU Contract Rate Delete Link}    //div[contains(normalize-space(.), 'MF / IBU Contract Rate Card Exception Rates')]//table[@id= 'gvResourceContractRate']//span[text()= 'Delete']
${sub-budget Main Link}    //a[@title= 'Go to Main']
${sub-budget Proj Dept dropdown}    //td[@id= 'DeptId_CC']//img
${sub-budget Proj Dept input}    //input[@id= 'DeptId_I']
${sub-budget Contract Currency dropdown}    //td[@id= 'gridLookupContractCurrency_CC']//img
${sub-budget Contract Currency input}    //input[@id= 'gridLookupContractCurrency_I']
#
#*******iBudget Link Page********
#
${iBudget-Link Existing Main Tab}    (//ul[@id= 'TabControl_TC']//a[contains(normalize-space(.), 'Existing Main')])[2]
${iBudget-Link Create Main Tab}    //ul[@id= 'TabControl_TC']//a[contains(normalize-space(.), 'Create Main')]
${iBudget-Link Name Input Field}    //table[@id= 'GridView_DXFREditorcol2']//input
${iBudget-Link Search Input Field}    //table[@id= 'GridView_DXSE']//input
${iBudget-Link Search Button}    //span[text()= 'Search']
${iBudget-Link Clear Button}    //span[text()= 'Clear']
#
#*******sub-budget Unit Value Estimate/ Other fees page*******
#
${Unit-Based CR New Button}    //td[@id= 'gvUnitRateCard_col0']//img[@title= 'New']
${Unit-Based CR Header}    //h4[text()= 'Unit-Based Contract Rate Card']
${Unit-Based CR Save Link Button}    //table[@id= 'gvUnitRateCard']//span[text()= 'Save changes']
${Unit-Based CR Cancel Link Button}    //table[@id= 'gvUnitRateCard']//span[text()= 'Cancel changes']
${Unit Value Estimate Header}    //h4[text()= 'Unit Value Estimate']
${Unit Value Estimate Save Changes Link}    //table[@id= 'gvUnitBasedWizard']//span[text()= 'Save changes']
${Unit Value Estimate Volume Discount Input}    //input[@id= 'UnitBasedEacBilling_I']
${Unit Value Estimate Adjustments Input}    //input[@id= 'UnitPendingWriteOffs_I']
${Unit Value Estimate Save Button}    //input[@name= 'Save']
${Other Fees New Button}    //table[@id= 'otherFeesView_DXMainTable']//img[@title= 'New']
${Other Fees Type Input Box}    //input[@id= 'otherFeesView_DXEditor2_I']
${Other Fees EAC Cost Input Box}    //input[@id= 'otherFeesView_DXEditor4_I']
${Other Fees EAC Billings Input Box}    //input[@id= 'otherFeesView_DXEditor5_I']
${Other Fees Save button}    //table[@id= 'otherFeesView_DXMainTable']//span[text()= 'Save']
${Other Fees Cancel button}    //table[@id= 'otherFeesView_DXMainTable']//span[text()= 'Cancel']
#
#*******sub-budget Labor page*******
#
${sub-budget Labor Expand/Collapse Link}    //div[@id= 'divCollapseGrid']
${sub-budget Save labor Button}    //input[@id= 'saveLaborButton']
${Employee Labor New Button}    //td[@id= 'GridView_col0']//img[@title= 'New']
${Employee Labor Header}    //h6/b[text()= 'Employee Labor']
${Employee labor Save changes Link}    //table[@id= 'GridView']//span[text()= 'Save changes']
${Employee labor Cancel changes Link}    //table[@id= 'GridView']//span[text()= 'Cancel changes']
${Employee Labor Footer}    //td[@id= 'GridView_tcfooter0']//span[text()= 'Employee Labor Sub-Totals']
${RHC Expand Link}    //a[@id= 'anchorRHC']
${RHC New Button}    //td[@id= 'GridView1_col0']//img[@title= 'New']
${RHC Header}     //h6/b[text()= ' RH Contractor Labor']
${RHC Footer}     //td[@id= 'GridView1_tcfooter0']//span[text()= 'RH Contractor Labor Sub-Totals']
${RHC Save changes Link}    //table[@id= 'GridView1']//span[text()= 'Save changes']
${RHC Cancel changes Link}    //table[@id= 'GridView1']//span[text()= 'Cancel changes']
${IHC Expand Link}    //a[@id= 'anchorIHC']
${IHC New Button}    //td[@id= 'gvIndenpendentContrLabor_col0']//img[@title= 'New']
${IHC Header}     //h6/b[text()= ' Independent Contractor Labor']
${IHC Footer}     //td[@id= 'gvIndenpendentContrLabor_tcfooter0']//span[text()= 'Independent Contractor Labor Sub-Totals']
${IHC Save changes Link}    //table[@id= 'gvIndenpendentContrLabor']//span[text()= 'Save changes']
${IHC Cancel changes Link}    //table[@id= 'gvIndenpendentContrLabor']//span[text()= 'Cancel changes']
${MF Expand Link}    //a[@id= 'anchorMF']
${MF New Button}    //td[@id= 'gvMemberFirmLabor_col0']//img[@title= 'New']
${MF Header}      //h6/b[text()= ' Member Firm Labor']
${MF Footer}      //td[@id= 'gvMemberFirmLabor_tcfooter0']//span[text()= 'Member Firm Labor Sub-Totals']
${MF Save changes Link}    //table[@id= 'gvMemberFirmLabor']//span[text()= 'Save changes']
${MF Cancel changes Link}    //table[@id= 'gvMemberFirmLabor']//span[text()= 'Cancel changes']
${IBU New Button}    //td[@id= 'gvInternationalBU_col0']//img[@title= 'New']
${IBU Header}     //h6/b[text()= ' International BU']
${IBU Footer}     //td[@id= 'gvInternationalBU_tcfooter0']//span[text()= 'International BU Professional Services']
${IBU Save changes Link}    //table[@id= 'gvInternationalBU']//span[text()= 'Save changes']
${IBU Cancel changes Link}    //table[@id= 'gvInternationalBU']//span[text()= 'Cancel changes']
${Volume Discount Input}    //input[@id= 'LaborVolumeDiscount.EacBillings_I']
${Adjustments Input}    //input[@id= 'LaborPendingWriteOffsAdjustments.EacBillings_I']
${pop-up minimize btn}    //div[@id= 'openClose']
${pop-up condition path}    //div[contains(@id, 'gaugeContainer')]
#
#*******sub-budget Expenses page*******
#
${sub-budget Save Expense Button}    //inpu[@id= 'saveExpenseButton']
${Employee Expense Header}    //b[text()= 'Employee Expense']
${sub-budget Employee Expense New Button}    //td[@id= 'EmpExpGridView_col0']//img[@title= 'New']
${Employee Expense Resource Name}    //input[@id= 'gridLookupResourceName_I']
${Employee Expense Save changes Link}    //table[@id= 'EmpExpGridView_DXStatus']//span[text()= 'Save changes']
${Employee Expense Cancel changes Link}    //table[@id= 'EmpExpGridView_DXStatus']//span[text()= 'Cancel changes']
${Employee Expense Footer}    //td[@id= 'EmpExpGridView_tcfooter0']//span[text()= 'Employee Expense']
${RHC Expense Header}    //b[text()= 'RH Contractor Expense']
${sub-budget RHC Expense New Button}    //td[@id= 'RhExpGridView_col0']//img[@title= 'New']
${RHC Expense Resource Name}    //input[@id= 'gridLookupResourceNameRHC_I']
${RHC Expense Footer}    //td[@id= 'RhExpGridView_tcfooter0']//span[text()= 'RH Contractor Expense']
${RHC Expense Save changes Link}    //table[@id= 'RhExpGridView_DXStatus']//span[text()= 'Save changes']
${RHC Expense Cancel changes Link}    //table[@id= 'RhExpGridView_DXStatus']//span[text()= 'Cancel changes']
${IHC Expense Header}    //b[text()= 'Independent Contractor Expense']
${sub-budget IHC Expense New Button}    //td[@id= 'IndExpGridView_col0']//img[@title= 'New']
${IHC Expense Resource Name}    //input[@id= 'gridLookupResourceNameIHC_I']
${IHC Expense Footer}    //td[@id= 'IndExpGridView_tcfooter0']//span[text()= 'Independent Contractor Expense']
${IHC Expense Save changes Link}    //table[@id= 'IndExpGridView_DXStatus']//span[text()= 'Save changes']
${IHC Expense Cancel changes Link}    //table[@id= 'IndExpGridView_DXStatus']//span[text()= 'Cancel changes']
${MF Expense Header}    //b[text()= 'Member Firm Expense']
${sub-budget MF Expense New Button}    //td[@id= 'MemExpGridView_col0']//img[@title= 'New']
${MF Expense Footer}    //td[@id= 'MemExpGridView_tcfooter0']//span[text()= 'Member Firm Expense']
${MF Expense Save changes Link}    //table[@id= 'MemExpGridView_DXStatus']//span[text()= 'Save changes']
${MF Expense Cancel changes Link}    //table[@id= 'MemExpGridView_DXStatus']//span[text()= 'Cancel changes']
${IBU Expense Header}    //b[text()= 'International BU Expense']
${sub-budget IBU Expense New Button}    //td[@id= 'IntGridView_col0']//img[@title= 'New']
${IBU Expense Footer}    //td[@id= 'IntGridView_tcfooter0']//span[text()= 'International BU Expense Totals']
${IBU Expense Save changes Link}    //table[@id= 'IntGridView']//span[text()= 'Save changes']
${IBU Expense Cancel changes Link}    //table[@id= 'IntGridView']//span[text()= 'Cancel changes']
#
#*******Consolidated budget page*******
#
${Consolidated Budget Header}    //h4[text()= 'Consolidated Budget']
#
#*******Re-estimation Basic Project Information********
#
${Re-estimate Last Basic Header}    //h4[text()= 'Last Approved Basic Budget Information']
${Re-estimate Revised Header}    //h4[text()= 'Revised Basic Budget Information']
${Re-estimated PD input}    (//table[@class= 'basicprojectinfotable'])[3]//td[text()= 'Project Description ']/following-sibling::td//input[@type= 'text']
${Re-estimated EMD input}    (//table[@class= 'basicprojectinfotable'])[3]//input[@id= 'gridLookupEMD_I']
${Re-estimated EMD input dropdown}    (//table[@class= 'basicprojectinfotable'])[3]//td[@id= 'gridLookupEMD_B-1']
${Re-estimated EM input}    (//table[@class= 'basicprojectinfotable'])[3]//input[@id= 'gridLookupEM_I']
${Re-estimated EM input dropdown}    (//table[@class= 'basicprojectinfotable'])[3]//img[@id= 'gridLookupEM_B-1Img']
${Re-estimated Department input}    (//table[@class= 'basicprojectinfotable'])[3]//input[@id= 'DeptId_I']
${Re-estimated Department input dropdown}    (//table[@class= 'basicprojectinfotable'])[3]//img[@id= 'DeptId_B-1Img']
${Re-estimated Service input dropdown}    (//table[@class= 'basicprojectinfotable'])[3]//td[@id= 'GridLookupPrimaryService_B-1']
${Re-estimated Service input}    (//tr[@id= 'GridLookupPrimaryService_DDD_gv_DXFilterRow']//input)[3]
#
#******Re-estimation Basic Info Page******
#
${Re-estimate Contract Rate Exception New Button}    //table[@id= "GVContractRateExcRateNew"]//img[@title= 'New']
${Re-estimate Contract Rate Exception Save Button}    //table[@id= "GVContractRateExcRateNew"]//span[text()= 'Save changes']
${Re-estimation Contract Rate Exception Rate Input}    //input[@id= 'GVContractRateExcRateNew_DXEditor3_I']
${Re-estimate MF/IBU Contract Rate Exception New Button}    //table[@id= "gvResourceContractRate"]//img[@title= 'New']
${Re-estimate MF/IBU Contract Rate Exception Save Button}    //table[@id= "gvResourceContractRate"]//span[text()= 'Save changes']
${Re-estimation Collapse ETC/EAC}    //button[@id= 'btnCollapse']
${sub-budget Unit Value Re-estimate Tab}    //ul[@id= 'TabControl_TC']//span[text()= 'Unit Value Re-estimate']
${Unit Value Re-estimate Header}    //h4[text()= 'Unit Value Re-estimate']

*** Keywords ***
Set ERA Approval Locators
    Set Log Level    NONE
    Set Suite Variable    ${EMD SELECT NAME}    //td[text()='${APPROVERS["EMD"]}']
    Set Suite Variable    ${EM SELECT NAME}    //td[text()='${APPROVERS["EM"]}']
    Set Suite Variable    ${GLMD SELECT NAME}    //td[text()='${APPROVERS["GLMD"]}']
    Set Suite Variable    ${RMD SELECT NAME}    //td[text()='${APPROVERS["RMD"]}']
    Set Suite Variable    ${QRMMD SELECT NAME}    //td[text()='${APPROVERS["QRMMD"]}']
    Set Suite Variable    ${QCMD SELECT NAME}    //td[text()='${APPROVERS["QCMD"]}']
    Set Suite Variable    ${EMD APPROVER Name}    //legend[text()='Engagement Managing Director (EMD)']/following-sibling::div/ul/li/span[text()='${APPROVERS["EMD"]}']
    Set Suite Variable    ${QCMD APPROVER Name}    //legend[text()='Quality Control / Second Managing Director (QC MD)']/following-sibling::div/ul/li/span[text()='${APPROVERS["QCMD"]}']
    Set Suite Variable    ${eQA APPROVER Name}    //legend[text()='Engagement Quality Assessment Lead (eQA Lead)']/following-sibling::div/ul/li/span[text()='${APPROVERS["QCMD"]}']
    Set Suite Variable    ${RMD APPROVER Name}    //legend[text()='Regional / Country Market Leader (RMD / CML)']/following-sibling::div/ul/li/span[text()='${APPROVERS["RMD"]}']
    Set Suite Variable    ${QRMMD APPROVER Name}    //legend[text()='Quality Risk Management Managing Director (QRM MD)']/following-sibling::div/ul/li/span[text()='${APPROVERS["QRMMD"]}']
    Set Log Level    INFO

Set Shell Name Locators
    [Arguments]    ${data_dict}
    Log Dictionary    ${data_dict}
    Set Log Level    NONE
    Set Suite Variable    ${OPPMD SELECT NAME}    //td[text()='${data_dict["OppMD"]}']
    Set Suite Variable    ${OPPOWNER SELECT NAME}    //td[text()='${data_dict["OppOwner"]}']
    Set Suite Variable    ${EMD SELECT NAME}    //td[text()='${data_dict["EMD"]}']
    Set Suite Variable    ${EM SELECT NAME}    //td[text()='${data_dict["EM"]}']
    Set Log Level    INFO

Set Assistant Vairiables
    [Arguments]    ${data_dict}
    Set Log Level    NONE
    Set Suite Variable    ${Assist My OPP}    //li[a[contains(normalize-space(.), 'ERA')]]//a[text()='SO 1215']
    Set Suite Variable    ${Assist Linked ERA}    //li[a[contains(normalize-space(.), 'ERA')]]//a[text()='SO 1215']
    Set Suite Variable    ${Assist Main Budget}    //li[a[contains(normalize-space(.), 'Budgets')]]//a[text()='SO 1215']
    Set Suite Variable    ${Assist Sub Budget}    //li[a[contains(normalize-space(.), 'Budgets')]]//a[text()='TEST']
