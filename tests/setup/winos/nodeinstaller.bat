@REM This is the installer tool for Dufuna Code Reviews

cd "%userprofile%"

For /F "usebackq" %%v IN (`node -v`) DO set node_version=%%v

For /F "usebackq" %%v IN (`systeminfo ^| find "x86" /c`) DO set pc_bit_size=%%v

:: Node check & Installation
IF [%node_version%]==[] (
    IF %pc_bit_size% LSS 1 (
        curl -o node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x86.msi
    ) ELSE (
        curl -o node.msi https://nodejs.org/dist/v14.15.5/node-v14.15.5-x64.msi
    )
    msiexec.exe /i node.msi /qn /norestart
    del node.msi
    echo "Please restart command prompt as an administrator"
) else (
    echo "node is available"
)