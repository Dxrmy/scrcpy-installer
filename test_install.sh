#!/bin/bash
set -e

# Mock the functions
brew() {
    echo "MOCK_BREW $@"
}
sudo() {
    echo "MOCK_SUDO $@"
}

# Mock read to bypass interactive prompt during source
read() {
    choice="3"
}

export -f brew
export -f sudo
export -f read

source install.sh > /dev/null

fails=0

# Test install_scrcpy darwin
OSTYPE="darwin19"
output=$(install_scrcpy)
if [[ "$output" == *"MOCK_BREW install scrcpy"* ]]; then
    echo "Pass: install_scrcpy darwin"
else
    echo "Fail: install_scrcpy darwin"
    echo "Output: $output"
    fails=1
fi

# Test install_scrcpy linux
OSTYPE="linux-gnu"
output=$(install_scrcpy)
if [[ "$output" == *"MOCK_SUDO apt-get update"* && "$output" == *"MOCK_SUDO apt-get install -y scrcpy"* ]]; then
    echo "Pass: install_scrcpy linux"
else
    echo "Fail: install_scrcpy linux"
    echo "Output: $output"
    fails=1
fi

# Test uninstall_scrcpy darwin
OSTYPE="darwin19"
output=$(uninstall_scrcpy)
if [[ "$output" == *"MOCK_BREW uninstall scrcpy"* ]]; then
    echo "Pass: uninstall_scrcpy darwin"
else
    echo "Fail: uninstall_scrcpy darwin"
    echo "Output: $output"
    fails=1
fi

# Test uninstall_scrcpy linux
OSTYPE="linux-gnu"
output=$(uninstall_scrcpy)
if [[ "$output" == *"MOCK_SUDO apt-get remove -y scrcpy"* ]]; then
    echo "Pass: uninstall_scrcpy linux"
else
    echo "Fail: uninstall_scrcpy linux"
    echo "Output: $output"
    fails=1
fi

if [ $fails -ne 0 ]; then
    exit 1
fi
