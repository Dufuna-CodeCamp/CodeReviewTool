@REM This is the installer tool for Dufuna Code Reviews

set project_working_directory="%~dp0..\.."
set test_folder="%project_working_directory:"=%\tests"
set home_directory="%userprofile%"

cd %home_directory%

For /F "usebackq" %%v IN (`curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE`) DO set /A chrome_driver_version=%%v

set path_to_driver="%home_directory:"=%\..\..\Program Files (x86)\"

For /F "usebackq" %%v IN ('node -v') DO set /A node_version=%%v
For /F "usebackq" %%v IN ('mocha --version') DO set /A mocha_version=%%v
For /F "usebackq" %%v IN (`systeminfo | find "x64" /c`) DO set pc_bit_size=%%v

set no_format='\033[00m'
set bold='\x1b[1m'
set underline='\033[4m'
set italic='\x1b[3m'

:: Node check & Installation
set _node_version_prefix=%node_version:~0,1%
IF %_node_version_prefix%==v (
    echo "node is available"
) ELSE (
    IF %pc_bit_size% LSS 1 (
        curl -o ~/node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x86.msi
    ) ELSE (
        curl -o ~/node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x64.msi
    )
    msiexec.exe /i node.msi /qf /norestart
)

cd %test_folder%

:: selenium web-driver check & installation
FOR /F "usebackq" %%i IN (`npm dir --depth=0 ^| find "selenium-webdriver" /c`) DO set /A selenium_wc=%%i

cd %home_directory%

IF %selenium_wc% GTR 0 (
    echo "selenium-webdriver is available"
) ELSE (
    npm install --prefix %test_folder% selenium-webdriver
)

FOR /F "usebackq" %%i IN (`dir %path_to_driver% ^| find "chromedriver" /c`) DO set /A chromedriver_wc=%%i

:: chromedriver check & installation
IF %chromedriver_wc% GTR 0 (
    echo "chromedriver is available"
) ELSE (
    curl -S -o chromedriver_win32.zip https://chromedriver.storage.googleapis.com/%chrome_driver_version%/chromedriver_win32.zip
    CALL :Unzip "%path_to_driver%" "chromedriver_win32.zip"
    DEL /Q chromedriver_win32.zip
)

:: mocha check & installation
IF %mocha_version% GTR 0 (
    echo "mocha is available"
) ELSE (
    npm install --global mocha
    npm install --global mochawesome
)

:: Running Tests
set customReportFilename="logfile"

:: write out to console the location of the report file

mocha "%test_folder:"=%\example-test.js" --reporter mochawesome --reporter-options reportDir=%test_folder%,reportFilename=%customReportFilename%,quiet=true

:Unzip <ExtractTo> <newzipfile>
set vbs="%temp%\_.vbs"
IF EXIST %vbs% del /f /q %vbs%
>%vbs%  echo Set fso = CreateObject("Scripting.FileSystemObject")
>>%vbs% echo IF NOT fso.FolderExists(%1) Then
>>%vbs% echo fso.CreateFolder(%1)
>>%vbs% echo END IF
>>%vbs% echo set objShell = CreateObject("Shell.Application")
>>%vbs% echo set FilesInZip=objShell.NameSpace(%2).items
>>%vbs% echo objShell.NameSpace(%1).CopyHere(FilesInZip)
>>%vbs% echo Set fso = Nothing
>>%vbs% echo Set objShell = Nothing
cscript //nologo %vbs%
IF EXIST %vbs% del /f /q %vbs%
EXIT /B 0