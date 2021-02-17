#!/bin/bash

# exit if non-zero status is returned
set -ex

project_working_directory=$PWD

cd ~/

chrome_driver_version=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE`
path_to_driver=/usr/local/bin
node_version=$(node -v)
mocha_version=$(mocha --version)

# Node check & Installation

if [[ $node_version == v* ]]
then
    echo "node is available"
else
    sudo brew install node
fi

# Selenium web-driver check & Installation
selenium_wc=`npm ls --depth=0 | grep -c selenium-webdriver`
if [[ $selenium_wc > 0 ]]
then
    echo "selenium-webdriver is available"
else
    npm install -save selenium-webdriver
fi

# Chromedriver check & Installation
chromedriver_wc=`ls /usr/local/bin/ | grep -c chromedriver`
if [[ $chromedriver_wc > 0 ]]
then
    echo "chromedriver is available"
else
    curl -S -o ~/chromedriver_mac64.zip https://chromedriver.storage.googleapis.com/$chrome_driver_version/chromedriver_mac64.zip
    unzip ~/chromedriver_mac64.zip -d ~/
    rm ~/chromedriver_mac64.zip

    sudo mv -f ~/chromedriver $path_to_driver/chromedriver
    sudo chown root $path_to_driver/chromedriver
    sudo chmod +x /usr/local/bin/chromedriver
    export PATH=$PATH:$path_to_driver
fi

# Mocha check & Installation
if [[ $mocha_version =~ ^[0-9] ]]
then
    echo "mocha is available"
else
    sudo npm install --global mocha
fi

# Run Tests

mocha ~/Desktop/dufuna/CodeReviewTool/setup/example-test.js --reporter JSON | tee ~/Desktop/dufuna/CodeReviewTool/tests/logfile.txt
