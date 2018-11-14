@echo off
title Nanoquake
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