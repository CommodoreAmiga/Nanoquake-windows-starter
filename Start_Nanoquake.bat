@echo off
title Nanoquake
echo Checking for new versions...
if exist "versionscheck\org_version.txt" goto :version-check
md versionscheck
powershell $progressPreference = 'silentlyContinue' ; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; "(Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/Nanoquake/yquake2/tags').Links.Href | Where-Object {$_ -like '*zip*'}" > versionscheck\org_version.txt
goto :version-ok
:version-check
powershell $progressPreference = 'silentlyContinue' ; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; "(Invoke-WebRequest -UseBasicParsing -Uri 'https://github.com/Nanoquake/yquake2/tags').Links.Href | Where-Object {$_ -like '*zip*'}" > versionscheck\check_version.txt
fc /b versionscheck\org_version.txt versionscheck\check_version.txt > nul
if errorlevel 1 (
    goto :different
) else (
    goto :version-ok
)
:different
cls
echo.
echo Please check out you have latest Nanoquake version from https://github.com/Nanoquake/yquake2/releases
echo.
rmdir /s /q versionscheck
pause
exit
:version-ok
cls
if exist "baseq2\pak0.pak" (
    if exist "baseq2\players\" (
        goto :ok
    ) else goto :download
) else goto :download
:download
Echo Demo files are not found.
echo.
@echo off
title Download demo
:choice
set /P c=Download and install demo files? (Y/N)
if /I "%c%" EQU "Y" goto :Yes
if /I "%c%" EQU "N" exit
goto :choice
:Yes
title Downloading demo...
md C:\temp-nanoquakedls
bitsadmin.exe /transfer "Downloading q2-314-demo-x86.exe" /priority FOREGROUND https://deponie.yamagi.org/quake2/idstuff/q2-314-demo-x86.exe C:\temp-nanoquakedls\q2-314-demo-x86.zip
cls
title Extracting demo...
powershell Expand-Archive -Path C:\temp-nanoquakedls\q2-314-demo-x86.zip
xcopy q2-314-demo-x86\Install\Data\baseq2\pak0.pak baseq2\
xcopy q2-314-demo-x86\Install\Data\baseq2\players\*.* baseq2\players\ /e
rmdir /s /q C:\temp-nanoquakedls
rmdir /s /q q2-314-demo-x86
cls
title Nanoquake
:ok
python start.py
