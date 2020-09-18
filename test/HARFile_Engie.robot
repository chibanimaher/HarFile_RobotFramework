*** Settings ***
Documentation  Selenium Grid + BMP
Library  Collections
Library  OperatingSystem
Library  RequestsLibrary
Library  SeleniumLibrary
Library  BrowserMobProxyLibrary

*** Variables ***
${PAGE_URL}    https://particuliers.engie.fr?env_work=acc
${HUB}         http://10.75.138.250:3274/wd/hub
${port}    
${BMP_HOST}  10.75.138.250
${BMP_PORT}  4444
${SELENIUM}  http://10.75.138.250:4444/wd/hub
${SHOT_NUM}  0
@{TIMINGS}
${PATH}           ${CURDIR}/test/Har_Result.txt
*** Keywords ***
#
# Setup, Teardown and Failure keywords
#

Suite Setup
  Register Keyword To Run On Failure  Suite Failure
  Set Selenium Implicit Wait  0.2 seconds
  Set Selenium Timeout  30 seconds
  &{caps}=  Set Capabilities
  Create Webdriver  Remote  command_executor=${SELENIUM}  desired_capabilities=${caps}
  New Har  Home

Suite Teardown
  Get Har  file.har
  Delete All Cookies
  Close All Browsers
  Close Proxy

Suite Failure
  Log Location
  Log Title
  Log Source
  Screenshot
  
#
# Helper keywords
#  
Get Requests
    ${url}=   Get Location
    Create Session    engie         ${url}
    ${resp}=          Get Request    engie               /
    Status Should Be  200            ${resp}
    Should Be Equal     ${resp.status_code} =    200    
    Log To Console    ${resp.status_code}   
    Log To Console    ${resp.content}      
    Log To Console    ************fin request****************    
Screenshot
  ${SHOT_NUM}  Evaluate  ${SHOT_NUM} + 1
  Set Global Variable  ${SHOT_NUM}
  Capture Page Screenshot  ${OUTPUT DIR}${/}Screenshots${/}${SUITE NAME}-${SHOT_NUM}-${TEST NAME}.png

Set Capabilities
  [Documentation]  Set the options for the selenium Driver
  ${port}=  Create Proxy
  &{proxy}=  Create Dictionary
  ...  proxyType  MANUAL
  ...  sslProxy  ${BMP_HOST}:${port}
  ...  httpProxy  ${BMP_HOST}:${port}
  &{caps}=  Create Dictionary  browserName=chrome  platform=ANY  proxy=${proxy}
  Log  Selenium capabilities: ${caps}
  [return]  ${caps}

Create Proxy
  [Documentation]  Get a BMP port for our test
  Create Session  bmp  http://${BMP_HOST}:${BMP_PORT}
  ${resp}=  Get Request  bmp  /proxy
  Should Be Equal As Strings  ${resp.status_code}  200
  Log  BMP Sessions: ${resp.text} [${resp.status_code}]
  &{headers}=  Create Dictionary  Content-Type=application/x-www-form-urlencoded
  &{data}=  Create Dictionary  trustAllServers=True
  ${resp}=  Post Request  bmp  /proxy  data=${data}  headers=${headers}
  Should Be Equal As Strings  ${resp.status_code}  200
  Log  ${resp.text} [${resp.status_code}]
  ${port}=  Get From Dictionary  ${resp.json()}  port
  Log  New BMP port: ${port} [${resp.status_code}]
  Set Global Variable  ${port}
  [return]  ${port}

New Har
  [Documentation]  Name and initialize a Har
  [arguments]  ${pagename}
  &{data}=  Create Dictionary  initialPageRef=${pagename}
  ${resp}=  Put Request  bmp  /proxy/${port}/har  params=${data}
  Should Be Equal As Strings  ${resp.status_code}  204
  Log  New Har (${pagename}) [${resp.status_code}]
Start Browser
    [Arguments]    ${BROWSER}
    Set Selenium Implicit Wait  10
    # Connect to BrowserMob-Proxy
   
    Connect To Remote Server    host=${BMP_HOST}  port=4444

    # Create dedicated proxy on BrowserMob Proxy
    ${BrowserMob_Proxy}=    Create Proxy

    ${options}=	Create Dictionary	browserName=${BROWSER}	platform=ANY  acceptSslCerts=${TRUE}  acceptInsecureCerts=${TRUE}

    # Configure Webdriver to use BrowserMob Proxy
    add_to_webdriver_capabilities  ${options}

    Create Webdriver    Remote   command_executor=${HUB}    desired_capabilities=${options}
New Har Page
  [Documentation]  Name and add a new har page
  [arguments]  ${pagename}
  Get Performance Timings
  &{data}=  Create Dictionary  pageRef=${pagename}
  ${resp}=  Put Request  bmp  /proxy/${port}/har/pageRef  params=${data}
  Should Be Equal As Strings  ${resp.status_code}  200
  Log  New Har Page (${pagename}) [${resp.status_code}]

Get Har
  [Documentation]  Serialize the current har
  [arguments]  ${harname}
  Get Performance Timings
  ${resp}=  Get Request  bmp  /proxy/${port}/har
  Should Be Equal As Strings  ${resp.status_code}  200
  ${length}  Get Length  ${resp.text}
  Log  Json length: ${length} [${resp.status_code}]
  &{dic}=  Evaluate  ${resp.text}
  Set To Dictionary  ${dic["log"]}  _webtimings=${TIMINGS}
  ${json}  evaluate  json.dumps(${dic})  json
  Create File  ${OUTPUT DIR}${/}${harname}  ${json}

Get Performance Timings
  [Documentation]  Ask javascript for the performance timings
  &{json}=  Execute Javascript  return window.performance.timing || window.webkitPerformance.timing || window.mozPerformance.timing || window.msPerformance.timing || {};
  Append To List  ${TIMINGS}  ${json}

Close Proxy
  ${resp}=  Delete Request  bmp  /proxy/${port}
  Should Be Equal As Strings  ${resp.status_code}  200
  Log  Delete proxy at ${port} [${resp.status_code}]
*** Test Cases ***
Home Engie
    New Har    engie
    &{options} =	Create Dictionary	browserName=chrome	platform=ANY
    Log  Selenium capabilities: ${options}
    Create Webdriver    Remote   command_executor=${HUB}    desired_capabilities=${options}
    Go to     ${PAGE_URL}
    Maximize Browser Window
    Capture Page Screenshot
    Click Element    xpath=//*[@id='engie_fournisseur_d_electricite_et_de_gaz_naturel_headerhp_souscrire_a_une_offre_d_energie']    
    Sleep    2  
    log     ******tarfic registred*************
    BrowserMobProxyLibrary.Get Har
    Get Requests
    Close All Browsers
  
    
