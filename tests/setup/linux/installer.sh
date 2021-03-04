#!/bin/bash

project_working_directory=$PWD/../..
test_folder=$project_working_directory/tests

cd ~/

set -e +x
chrome_driver_version=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE`
set +ex

path_to_driver=/usr/local/bin
node_version=$(node -v)
npm_version=$(npm -v)
mocha_version=$(mocha --version)
pc_bit_size=$(uname -m)
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
    sudo apt install nodejs
fi

# npm check & Installation
if [[ $npm_version =~ ^[0-9] ]]
then
    echo "npm is available"
else
    sudo apt install npm
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
    sudo npm install --prefix $test_folder selenium-webdriver
fi

set +ex

# Chromedriver check & Installation
chromedriver_wc=`ls /usr/local/bin/ | grep -c chromedriver`

set -e +x

if [[ $chromedriver_wc > 0 ]]
then
    echo "chromedriver is available"
else
    driver_file_name=''
    if [[ $pc_bit_size == x86_64 ]]
    then
        wget https://chromedriver.storage.googleapis.com/$chrome_driver_version/chromedriver_linux64.zip -P ~/
        driver_file_name="chromedriver_linux64.zip"
    else
        wget https://chromedriver.storage.googleapis.com/$chrome_driver_version/chromedriver_linux32.zip -P ~/
        driver_file_name="chromedriver_linux32.zip"
    fi
    unzip ~/$driver_file_name -d ~/
    rm ~/$driver_file_name

    sudo mv -f ~/chromedriver $path_to_driver/chromedriver
    sudo chown root $path_to_driver/chromedriver
    sudo chmod +x $path_to_driver/chromedriver
    export PATH=$PATH:$path_to_driver
fi

# Mocha check & Installation
if [[ $mocha_version =~ ^[0-9] ]]
then
    echo "mocha is available"
else
    sudo npm install --global mocha
    sudo npm install --global mochawesome
fi

# Run Tests

customReportDir=$project_working_directory/tests
customReportFilename=logfile

echo -e "${ITALIC}visit${NONE} ${BOLD}${UNDERLINE}$project_working_directory/tests/logfile.html${NONE} in your browser to see test reports"
mocha $project_working_directory/tests/example-test.js --reporter mochawesome --reporter-options reportDir=$customReportDir,reportFilename=$customReportFilename,quiet=true