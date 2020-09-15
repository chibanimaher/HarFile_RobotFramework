*** Settings ***
Library    SeleniumLibrary    
Library                     Collections
Library                     OperatingSystem
Library                     BrowserMobProxyLibrary
Suite Setup                 Start Browser
Suite Teardown              Close Browser
*** Variables ***
${URL_Engie}    https://particuliers.engie.fr?env_work=acc   
${BROWSER}    chrome 
*** Keywords ***
Start Browser
          [Documentation]         Start chrome browser
          Set Selenium Implicit Wait  10
          ## Init BrowserMob Proxy
          Start Local Server      C:/Users/chiheb/AppData/Local/Programs/Python/Python38-32/Lib/site-packages/browsermobproxy/browsermob-proxy-2.1.4/bin/browsermob-proxy.bat
      
          ## Create dedicated proxy on BrowserMob Proxy
          ${BrowserMob_Proxy}=    Create Proxy
      
          ## Configure Webdriver to use BrowserMob Proxy
          Create Webdriver        ${BROWSER}    proxy=${BrowserMob_Proxy}
      
          Close Browser
          Close All Browsers
          Stop Local Server
*** Test Cases ***
Check something
          [Documentation]         Check the page title
    Start Browser
    Open Browser    ${URL_Engie}    ${BROWSER}
    Set Browser Implicit Wait    5
    Maximize Browser Window
    Click Element    xpath=//*[@id='engie_fournisseur_d_electricite_et_de_gaz_naturel_headerhp_souscrire_a_une_offre_d_energie']    
    Sleep    2    
      
          ${har}=                 Get Har As JSON
          create file             ${EXECDIR}${/}file.har     ${har}
          log to console          Browsermob Proxy HAR file saved as ${EXECDIR}${/}file.har
          Sleep    20    
