*** Settings ***
Library    DateTime
Documentation               This is just a BrowserMob Proxy Library tutorial
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
    [Documentation]         Start firefox browser
    Set Selenium Implicit Wait  10
    ## Init BrowserMob Proxy
    Start Local Server      C:/Users/chiheb/Desktop/browsermob-proxy-2.1.4/bin/browsermob-proxy.bat

    ## specify port proxy on BrowserMob Proxy
    &{port}    Create Dictionary    port=8085
   # Create dedicated proxy on BrowserMob Proxy
    ${BrowserMob_Proxy}=    Create Proxy    ${port}
    # Configure Webdriver to use BrowserMob Proxy
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --proxy\=${BrowserMob_Proxy}
    Call Method    ${options}    add_argument    --allow-running-insecure-content
    Call Method    ${options}    add_argument    --disable-web-security
    Create WebDriver    Chrome    chrome_options=${options}

Close Browsers
    Close All Browsers
    Stop Local Server

*** Test Cases ***
Home_Engie
    [Documentation]         Check the page title
    New Har                 google
    Go to                   ${PAGE_URL}
    Maximize Browser Window
    Capture Page Screenshot
    Click Element    xpath=//*[@id='engie_fournisseur_d_electricite_et_de_gaz_naturel_headerhp_souscrire_a_une_offre_d_energie']    
    Sleep    2 
    ${date}=    Get Current Date	 
    ${har}=                 Get Har As Json
    create file             ${EXECDIR}${/}Home_Engie.har   ${har}
    log to console          Browsermob Proxy HAR file saved as ${EXECDIR}${/}Home_Engie.har