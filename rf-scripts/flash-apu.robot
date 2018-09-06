*** Settings ***
Library     SSHLibrary
Library     Telnet
Library     String
Library     OperatingSystem
Library     Collections

Resource    robotframework/variables.robot
Resource    robotframework/keywords.robot

Suite Setup       SSH Connection and Log In    ${rte_ip}
Suite Teardown    Log Out And Close Connections

*** Test Cases ***

RTE: Flash and validate APUx firmware
    Log To Console    \n\n\tFlashing procedure has started
    SPI Flash Firmware    ${fw_file}
    Log To Console    \n\tFlashing procedure has finished
    ${version}=    Get Firmware Version From File
    Serial Connection and Setup    ${rte_ip}
    DUT Power On
    ${result}=    Get Sign of Life
    Log To Console    \n\tSign of Life output:\n\n ${result} \n
    Should Contain    ${result}    ${version}
    Run Keyword If    '${version}'=='v0.0.0.0'
    ...    Fail    BIOS version is not correct!
