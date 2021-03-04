set project_working_directory="%~dp0..\..\..\"
set test_folder="%project_working_directory:"=%\tests"
set customReportFilename=logfile

"%APPDATA:"=%\npm\mocha.cmd" "%test_folder:"=%\example-test.js" --reporter mochawesome --reporter-options reportDir=%test_folder%,reportFilename=%customReportFilename%,quiet=true
