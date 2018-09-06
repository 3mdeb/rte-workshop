*** Settings ***
Library     SSHLibrary
Library     Telnet

Resource    robotframework/variables.robot
Resource    robotframework/keywords.robot

Suite Setup       SSH Connection and Log In    ${rte_ip}
Suite Teardown    Log Out And Close Connections

*** Test Cases ***
RTE: 1.1 SSH connection
    ${ssh_info}=    SSHLibrary.Get Connection
    Should Be Equal As Strings    ${ssh_info.host}    ${rte_ip}

RTE: 2.1 Relay - power on Device Under Test
    DUT Power Cycle
    Sleep    5 seconds

RTE: 3.1 Serial connection
    Serial Connection and Setup    ${rte_ip}

RTE: 4.1 PWR pin - power off and on Device Under Test
    Log To Console    \n\n\tPower Off - platform shutdown
    DUT Power Off
    Sleep    3 seconds
    Log To Console    \n\tPower On - get platform sign of life
    DUT Power On
    Telnet.Read Until    Press F10 key now for boot menu
    ${sign_of_life}=    Get Sign of Life
    Log To Console    \nOutput:\n\n${sign_of_life}\n
    Should Match Regexp   ${sign_of_life}    PC Engines apu[1-5]

RTE: 4.2 RST pin - reset Device Under Test
    Telnet.Read Until    Press F10 key now for boot menu
    Log To Console    \n\n\tReset - platform reboot
    DUT Reset
    Log To Console    \n\tReset - get platform sign of life
    ${sign_of_life}=    Get Sign of Life
    Log To Console    \nOutput:\n\n${sign_of_life}\n
    Should Match Regexp   ${sign_of_life}    PC Engines apu[1-5]
