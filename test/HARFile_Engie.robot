*** Settings ***
Library    DateTime
Documentation               Harfile&GAnalytics
...
Metadata                    VERSION     0.1
Library                     SeleniumLibrary
Library                     Collections
Library                     OperatingSystem
Library                     BrowserMobProxyLibrary
Library                     HttpCtrl.Client   
Library                     HttpCtrl.Server
Suite Setup                 Config_Proxy
Suite Teardown              Close Browsers
*** Variables ***
${PAGE_URL}                 https://particuliers.engie.fr?env_work=acc
${BROWSER}                  Firefox

*** Keywords ***
Config_Proxy
    [Documentation]         Start chrome browser
    Set Selenium Implicit Wait  10
    ## Init BrowserMob Proxy
    Start Local Server      C:/Users/chiheb/Desktop/browsermob-proxy-2.1.4/bin/browsermob-proxy.bat
    ## Create dedicated proxy on BrowserMob Proxy
    &{port}    Create Dictionary    port=8082
   # Create dedicated proxy on BrowserMob Proxy
    ${BrowserMob_Proxy}=    Create Proxy    ${port}

# Configure Webdriver to use BrowserMob Proxy
    ${options}=  Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --proxy-server\=localhost:8082
    Call Method    ${options}    add_argument     --ignore-certificate-errors
    ${options.add_argument}=  Set Variable  --allow-running-insecure-content
    ${options.add_argument}=  Set Variable  --disable-web-security
    ${options.add_argument}=  Set Variable  --ignore-certificate-errors
    Create WebDriver    Chrome    chrome_options=${options}
Close Browsers
    Close All Browsers
    Stop Local Server
*** Test Cases ***
Home Engie
     New Har    engie
    Go To    ${PAGE_URL}
    Maximize Browser Window
    Capture Page Screenshot
    Click Element    xpath=//*[@id='engie_fournisseur_d_electricite_et_de_gaz_naturel_headerhp_souscrire_a_une_offre_d_energie']    
    Sleep    2 
    ${har}=     Get Har As Json
    Create File     ${EXECDIR}${/}Home_Engie.har     ${har}
 
  
    
