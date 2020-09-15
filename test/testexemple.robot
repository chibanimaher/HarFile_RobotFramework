*** Settings ***
Library               Collections
Library               RequestsLibrary

*** Test Cases ***
Get Requests
    Create Session    engie         https://particuliers.engie.fr?env_work=acc
    ${resp}=          Get Request    engie               /
    Status Should Be  200            ${resp}
    ${resp}=          Get Request    github               /users/bulkan
    Request Should Be Successful     ${resp}
    Dictionary Should Contain Value  ${resp.json()}       Bulkan Evcimen