#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Ask for project name
echo "Enter project name: "
read PROJECT_NAME

# Prevent issues with spaces in directory names
PROJECT_NAME=$(echo "$PROJECT_NAME" | sed 's/[[:space:]]/_/g')

# Detect OS
ios=$(uname)

echo "Detected OS: $ios"

if [[ "$ios" == "Linux" ]]; then
    echo "Installing dependencies for Linux..."
    sudo apt-get update && sudo apt-get install -y python3 python3-pip git

elif [[ "$ios" == "Darwin" ]]; then
    echo "Installing dependencies for macOS..."
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found, installing it..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python git
else
    echo "Unsupported operating system: $ios"
    exit 1
fi

echo "Setting up project directory..."
mkdir -p "$PROJECT_NAME/additionalFilesForServer/static"
mkdir -p "$PROJECT_NAME/additionalFilesForServer/styles"
mkdir -p "$PROJECT_NAME/additionalFilesForServer/scripts"
mkdir -p "$PROJECT_NAME/contentTemplates"
mkdir -p "$PROJECT_NAME/contentTemplates/topic"
cd "$PROJECT_NAME"

echo "Setting GitHub repository URL..."
GH_REPO="https://raw.githubusercontent.com/larstel/minimalistFrameworkInstall/main"

echo "Downloading specific files from GitHub..."
curl -o additionalFilesForServer/static/icon.svg "$GH_REPO/static/icon.svg"
curl -o template.html "$GH_REPO/template.html"
curl -o buildConfig.json "$GH_REPO/buildConfig.json"
curl -o contentTemplates/topic/localization.json "$GH_REPO/localization.json"
curl -o contentTemplates/topic/00_index_localization.json "$GH_REPO/00_index_localization.json"
curl -o contentTemplates/topic/00_index.html "$GH_REPO/00_index.html"
curl -o additionalFilesForServer/styles/custom.css "$GH_REPO/custom.css"
curl -o additionalFilesForServer/scripts/main.js "$GH_REPO/main.js"

echo "Initializing Git repository..."
git init
git submodule add https://github.com/larstel/minimalistFramework.git

cd minimalistFramework

echo "Installing Python dependencies..."
pip3 install -r requirements.txt

echo "Setup complete!"
