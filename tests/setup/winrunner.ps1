#!/bin/bash

# -x -> print command as it is being run
# -e -> terminate if a commands' exit code is non-zero

project_working_directory=$PWD/../..
test_folder=$project_working_directory/tests

cd ~/

set -e +x

chrome_driver_version=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE`

set +ex

path_to_driver=$home/../../../
node_version=$(node -v)
mocha_version=$(mocha --version)
pc_bit_size=$(systeminfo | findstr x64)

NONE='\033[00m'
BOLD='\x1b[1m'
UNDERLINE='\033[4m'
ITALIC='\x1b[3m'

# exit if non-zero status is returned
set -e +x

# Node check & Installation
if [[ $node_version == v* ]]
then
    echo "node is available"
else
    # download installer and install .exe file
    set +ex
    # check if pc_bit_size variable is empty, if it is not, then it is a 64 bit PC
    if [ -z "$pc_bit_size"]
    then
        curl -o ~/node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x86.msi
    else
        curl -o ~/node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x64.msi
    fi

    # install the exe file
    Start-Process -FilePath $home/node.msi -ArgumentList '/qb! /norestart' -Wait -PassThru
fi

set +ex

cd $test_folder

# Selenium web-driver check & Installation
selenium_wc=`npm ls --depth=0 | grep -c selenium-webdriver`

cd ~/

set -e +x

if [[ $selenium_wc > 0 ]]
then
    echo "selenium-webdriver is available"
else
    npm install --prefix $test_folder selenium-webdriver
fi

set +ex

chromedriver_wc=`ls $path_to_driver/Program Files (x86) | findstr chromedriver`

# is chromedriver available?
if [ -z "$chromedriver_wc"]
then
    curl -S -o ~/chromedriver_win32.zip https://chromedriver.storage.googleapis.com/$chrome_driver_version/chromedriver_win32.zip
    Expand-Archive -Path '~/chromedriver_win32.zip' -DestinationPath '$path_to_driver/Program Files (x86)'
    Remove-Item '~/chromedriver_win32.zip'
    $env:Path += ";$path_to_driver/Program Files (x86)/chromedriver_win32"
else
    echo "chromedriver is available"
fi

# Mocha check & Installation
if [[ $mocha_version =~ ^[0-9] ]]
then
    echo "mocha is available"
else
    npm install --global mocha
    npm install --global mochawesome
fi

# Run Tests

customReportDir=$project_working_directory/tests
customReportFilename=logfile

echo -e "${ITALIC}visit${NONE} ${BOLD}${UNDERLINE}$project_working_directory/tests/logfile.html${NONE} in your browser to see test reports"
mocha $project_working_directory/tests/example-test.js --reporter mochawesome --reporter-options reportDir=$customReportDir,reportFilename=$customReportFilename,quiet=true