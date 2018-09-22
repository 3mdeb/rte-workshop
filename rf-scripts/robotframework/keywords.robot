*** Keywords ***

SSH Connection and Log In
    [Documentation]    Open SSH connection with ip passed as argument and log
    ...                in to system.
    [Arguments]    ${ip}
    SSHLibrary.Set Default Configuration    timeout=60 seconds
    SSHLibrary.Open Connection    ${ip}
    SSHLibrary.Login    ${username}    ${password}

Serial Connection and Setup
    [Documentation]    Setup and establish telnet connection. Pass host ip as an
    ...                argument.
    [Arguments]    ${ip}
    Telnet.Open Connection    ${ip}    port=${s2n_port}
    Telnet.Set Encoding    errors=ignore
    Telnet.Set Timeout    180
    Telnet.Set Prompt    \~#

Log Out And Close Connections
    [Documentation]    Close all telnet and ssh open connections.
    Telnet.Close All Connections
    SSHLibrary.Close All Connections

Switch Relay On
    [Documentation]    Switch relay to ON state by direct gpio value control.
    SSHLibrary.Start Command    echo 1 > /sys/class/gpio/gpio199/value

Switch Relay Off
    [Documentation]    Switch relay to OFF state by direct gpio value control.
    SSHLibrary.Start Command    echo 0 > /sys/class/gpio/gpio199/value

DUT Power Cycle
    [Documentation]    Full power cycle of DUT from any relay state.
    ${result}=    SSHLibrary.Execute Command    cat /sys/class/gpio/gpio199/value
    Run Keyword If    ${result}==1    Switch Relay Off
    Sleep    1 seconds
    Switch Relay On

DUT Power On
    [Documentation]    Send hardware power on singal to DUT.
    SSHLibrary.Start Command    echo 1 > /sys/class/gpio/gpio410/value
    Sleep    1 seconds
    SSHLibrary.Start Command    echo 0 > /sys/class/gpio/gpio410/value

DUT Power Off
    [Documentation]    Send hardware power off signal to DUT. Forces the APU
    ...                platform into ACPI S5 state.
    SSHLibrary.Start Command    echo 1 > /sys/class/gpio/gpio410/value
    Sleep    5 seconds
    SSHLibrary.Start Command    echo 0 > /sys/class/gpio/gpio410/value

DUT Reset
    [Documentation]    Send hardware reset signal to DUT.
    SSHLibrary.Start Command    echo 1 > /sys/class/gpio/gpio409/value
    Sleep    1 seconds
    SSHLibrary.Start Command    echo 0 > /sys/class/gpio/gpio409/value

Get Firmware Version From File
    ${coreboot_version1}=    SSHLibrary.Execute Command    strings /tmp/coreboot.rom|grep CONFIG_LOCALVERSION|cut -d"=" -f 2|tr -d '"'
    ${coreboot_version2}=    SSHLibrary.Execute Command    strings /tmp/coreboot.rom|grep -w COREBOOT_VERSION|cut -d" " -f 3|tr -d '"'
    ${version_length}=    Get Length    ${coreboot_version1}
    ${coreboot_version}=    Set Variable If    ${version_length} == 0    ${coreboot_version2}    ${coreboot_version1}
    [Return]    ${coreboot_version}

Get Sign of Life
    [Documentation]    Return any sign of life after flashing firmware.
    ${sign_of_life}=    Telnet.Read Until    DRAM
    [Return]    ${sign_of_life}

SPI Flash Firmware
    [Documentation]    Flash APU2/3/4/5 firmware connected to RTE via SPI.
    [Arguments]    ${file}
    DUT Power Cycle
    ${result}=    Run    sshpass -p ${password} scp -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${file} ${username}@${rte_ip}:${fw_path}
    Should Be Empty    ${result}
    DUT Power Off
    ${flash_result}=    SSHLibrary.Execute Command    flashrom -f -p linux_spi:dev=/dev/spidev1.0,spispeed=16000 -w ${fw_path}
    Return From Keyword If    "Warning: Chip content is identical to the requested image." in """${flash_result}"""
    Should Contain    ${flash_result}     VERIFIED
