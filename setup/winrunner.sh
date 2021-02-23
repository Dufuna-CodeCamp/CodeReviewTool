#!/bin/bash

# exit if non-zero status is returned
set -ex

project_working_directory=$PWD/..

cd ~/

chrome_driver_version=`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE`
path_to_driver=/usr/local/bin
node_version=$(node -v)
mocha_version=$(mocha --version)
pc_bit_size=$(systeminfo | findstr x64)

# Node check & Installation
if [[ $node_version == v* ]]
then
    echo "node is available"
else
    # download installer and install .exe file

    # check if pc_bit_size variable is empty, if it is not, then it is a 64 bit PC
    if [ -z "$pc_bit_size"]
    then
        curl -o ~/node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x86.msi
    else
        curl -o ~/node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x64.msi
    fi

    # install the exe file
    Start-Process -Wait -FilePath ~/node.exe -Argument "/silent" -PassThru
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
fi

# Run Tests
mocha ~/Desktop/dufuna-testing/example-test.js | tee ~/Desktop/dufuna-testing/file.txt





# install selenium-webdriver
#npm install -save selenium-webdriver

# download chromedriver for Windows
# wget https://chromedriver.storage.googleapis.com/$chrome_driver_version/chromedriver_win32.zip -P ~/

# download chromedriver for Mac - 32bits
# wget https://chromedriver.storage.googleapis.com/$chrome_driver_version/chromedriver_mac32.zip -P ~/

# download chromedriver for Mac - 64bits
#curl -S -o ~/chromedriver_mac64.zip https://chromedriver.storage.googleapis.com/$chrome_driver_version/chromedriver_mac64.zip
#unzip ~/chromedriver_mac64.zip -d ~/
#rm ~/chromedriver_mac64.zip

#sudo mv -f ~/chromedriver $path_to_driver/chromedriver
#sudo chown root $path_to_driver/chromedriver
#sudo chmod +x /usr/local/bin/chromedriver
#export PATH=$PATH:$path_to_driver

# Mocha and Chai Setup

#sudo npm install --global mocha
#npm install chai


# run tests
mocha ~/Desktop/dufuna-testing/example-test.js | tee ~/Desktop/dufuna-testing/file.txt



# npm check & Installation
# if [[ $npm_version =~ ^[0-9] ]]
# then
#     echo "npm is available"
# else
#     sudo apt install npm
# fi