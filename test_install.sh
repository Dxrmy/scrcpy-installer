#!/bin/bash
set -e

# Test suite for install.sh
# Mocks brew, sudo, and apt-get to verify expected commands are called

FAILS=0

trap "rm -f execution.log temp_functions.sh" EXIT

# Mock functions
brew() {
    echo "brew $@" >> execution.log
}

sudo() {
    echo "sudo $@" >> execution.log
}

apt-get() {
    echo "apt-get $@" >> execution.log
}

export -f brew
export -f sudo
export -f apt-get

# Safe way to source the script without running its interactive part
# We extract just the functions to a temporary file
awk '/^[a-zA-Z_]+\(\) \{/ {in_func=1} in_func {print} /^\}/ {in_func=0; print ""}' install.sh > temp_functions.sh
source ./temp_functions.sh

test_install_scrcpy_darwin() {
    echo "Running test_install_scrcpy_darwin..."
    rm -f execution.log
    touch execution.log
    export OSTYPE="darwin20.0"

    install_scrcpy > /dev/null

    if grep -q "brew install scrcpy" execution.log; then
        echo "  [PASS] brew was called to install scrcpy"
    else
        echo "  [FAIL] brew was not called"
        FAILS=$((FAILS+1))
    fi
}

test_install_scrcpy_linux() {
    echo "Running test_install_scrcpy_linux..."
    rm -f execution.log
    touch execution.log
    export OSTYPE="linux-gnu"

    install_scrcpy > /dev/null

    if grep -q "sudo apt-get update" execution.log && grep -q "sudo apt-get install -y scrcpy" execution.log; then
        echo "  [PASS] apt-get was called to install scrcpy"
    else
        echo "  [FAIL] apt-get was not called"
        FAILS=$((FAILS+1))
    fi
}

# Run tests
test_install_scrcpy_darwin
test_install_scrcpy_linux

# Report results
if [ $FAILS -eq 0 ]; then
    echo "All tests passed!"
else
    echo "$FAILS tests failed."
fi
if [ $FAILS -eq 0 ]; then exit 0; else exit 1; fi
