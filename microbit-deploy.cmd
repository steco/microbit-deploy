@echo off

rem * Microbit Copy.cmd
rem *
rem * This script copies a microbit .hex file to an attached Micro:bit and to a network
rem * directory for backup.
rem *
rem * The intention is that this script is associated with the .hex extension, allowing
rem * a simple 'open' of the compiled file downloaded from microbit.org to automatically
rem * deploy it to the Micro:bit
 
set HexFile=%1

set BackupRootDirectory=c:\work\backup\

rem Find attached Micro:bit and copy hex file to it
set MicrobitDrive=
for /F "usebackq tokens=1,2 " %%i in (`wmic logicaldisk get deviceid^,VolumeName 2^>NUL`) do (

  if %%j equ MICROBIT (
    set MicrobitDrive=%%i
  )
)

if not defined MicrobitDrive (
  echo Cannot find MICROBIT.  Are you sure it is connected?
  echo Available drives are:
  wmic logicaldisk get deviceid,VolumeName
  
  pause
  
  exit /b
)

echo Copying %HexFile% to Micro:bit at %MicrobitDrive%
xcopy /f /q %HexFile% %MicrobitDrive%

rem Backup hex file to network drive

set Timestamp=

rem Get the current date in ISO format - unbelievable complexity
for /f "usebackq skip=1" %%t in (`wmic os get LocalDateTime`) do if not defined Timestamp set Timestamp=%%t
set DATE=%Timestamp:~0,8%

set BackupDirectory=%BackupRootDirectory%\%DATE%\
if not exist %BackupDirectory% mkdir %BackupDirectory%

for %%A in (%HexFile%) do set FileName=%%~nxA

if exist "%BackupDirectory%\%FileName%" (
  echo Renaming old backup "%BackupDirectory%\%FileName%"
  ren "%BackupDirectory%\%FileName%" "%FileName%.%Timestamp%"
)

echo Backing up to %BackupDirectory%
xcopy /f /q %HexFile% %BackupDirectory%

if not ERRORLEVEL 1 (
  echo Deployment to your Micro:bit is complete - enjoy your creation!
  
  pause
)
