#!/bin/bash
# Prepare environment for act tests

# Install act
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Make mock scripts executable
chmod +x tests/mocks/*

# Install bats-core
if ! command -v bats &>/dev/null; then
    if command -v brew &>/dev/null; then
        brew install bats
    elif command -v npm &>/dev/null; then
        npm install -g bats
    elif command -v apt &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y bats
    else
        echo "bats-core is not installed. Please install it manually."
        echo "https://bats-core.readthedocs.io/en/stable/installation.html"
        exit 1
    fi
fi
