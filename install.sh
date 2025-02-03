#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Detect OS
ios=$(uname)

echo "Detected OS: $ios"

if [[ "$ios" == "Linux" ]]; then
    echo "Installing dependencies for Linux..."
    sudo apt-get update && sudo apt-get install -y python3 python3-pip git

elif [[ "$ios" == "Darwin" ]]; then
    echo "Installing dependencies for macOS..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install python git
else
    echo "Unsupported operating system: $ios"
    exit 1
fi

echo "Setting up project directory..."
mkdir -p "directory-name/content"
cd "directory-name"

touch buildConfig.json custom.css
cd content

touch localization.json
cd ..

echo "Initializing Git repository..."
git init
git submodule add https://github.com/larstel/minimalistFramework.git

cd minimalistFramework

echo "Installing Python dependencies..."
pip3 install -r requirements.txt

echo "Setup complete!"
