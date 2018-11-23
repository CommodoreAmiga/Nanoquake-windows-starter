@echo off
:begin
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
powershell [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; "$Name = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/repos/Nanoquake/yquake2/releases/latest' | select -ExpandProperty Name" ; write-host "New version $Name is available" ; write-host "`n"; "$Body = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/repos/Nanoquake/yquake2/releases/latest' | select -ExpandProperty Body" ; write-host "$Body" ; "$ZipUrl = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/repos/Nanoquake/yquake2/releases/latest' | select -ExpandProperty assets | select -ExpandProperty browser_download_url" ; write-host "`n$ZipUrl`n`n"Do you want continue to download and install?" ; Remove-Item versionscheck -Force -Recurse ; pause ; cls ; write-host "Downloading..." ; Invoke-RestMethod -Method Get -Uri $ZipUrl -OutFile update-nq.zip
cls
Echo Extracting zip...
powershell Expand-Archive -Path update-nq.Zip
cls
Echo Copying files...
powershell Copy-Item -Force -Recurse .\update-nq\*\* .\
rmdir /s /q update-nq
del /q update-nq.zip
powershell [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; "$Name = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/repos/Nanoquake/yquake2/releases/latest' | select -ExpandProperty Name" ; "$Name | Out-File updates.txt -Append -NoClobber"
Echo Done.
pause
goto :begin
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
