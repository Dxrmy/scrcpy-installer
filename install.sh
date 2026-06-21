#!/bin/bash
set -e

echo -e "\e[35m  ╱|、       meow.\e[0m"
echo -e "\e[35m(˚ˎ 。7     /\e[0m"
echo -e "\e[35m |、˜〵          \e[0m"
echo -e "\e[35m じしˍ,)ノ\e[0m"
echo ""
echo -e "\e[36m Universal SCRCPY Manager\e[0m"
echo ""

install_scrcpy() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "\e[33m [*] Installing scrcpy via Homebrew...\e[0m"
        brew install scrcpy
    else
        echo -e "\e[33m [*] Installing scrcpy via APT...\e[0m"
        sudo apt-get update && sudo apt-get install -y scrcpy
    fi
    echo -e "\e[32m [v] Successfully installed SCRCPY!\e[0m"
}

uninstall_scrcpy() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "\e[33m [*] Uninstalling scrcpy via Homebrew...\e[0m"
        brew uninstall scrcpy
    else
        echo -e "\e[33m [*] Uninstalling scrcpy via APT...\e[0m"
        sudo apt-get remove -y scrcpy
    fi
    echo -e "\e[32m [v] Successfully uninstalled SCRCPY!\e[0m"
}

echo -e "\e[37m 1. Install SCRCPY\e[0m"
echo -e "\e[37m 2. Uninstall SCRCPY\e[0m"
echo ""
read -p " Select an option (1/2): " choice

echo ""
if [ "$choice" == "1" ]; then
    install_scrcpy
elif [ "$choice" == "2" ]; then
    uninstall_scrcpy
else
    echo -e "\e[31m [x] Invalid option selected.\e[0m"
fi
