@echo off

call config.bat

if %WARN_SERVER_STOP% == 1 (
  set /p "stopped=Ist Server heruntergefahren? (YES eingeben, wenn ja): "

  IF NOT "%stopped%" == "YES" (
    echo Dann bitte Server erst herunterfahren!
    exit /b 1
  )
)

set EXCLUDE_DIRS=dynmap/web
REM ignore all .bak files and all ZIP files in root folder
set EXCLUDE_REGEX="ftp:\/\/([0-9]{1,3}\.){3}[0-9]{1,3}\/([^\/]*\.zip|.*\.bak)$"

set STORAGE_BASE=backups
if %USE_STORAGE_DIR% == 1 (
  set STORAGE_BASE=%STORAGE_DIR%
)

set LOCAL_DIR=%STORAGE_BASE%\%date%
if %USE_DATETIME_FILENAME% == 0 (
  set LOCAL_DIR=%STORAGE_BASE%\MinecraftBackup
)

IF exist %LOCAL_DIR% (
  rmdir /s /q %LOCAL_DIR%
)

echo "Download to directory: %LOCAL_DIR%"

mkdir %LOCAL_DIR%

wget -X %EXCLUDE_DIRS% --regex-type pcre --reject-regex %EXCLUDE_REGEX% --no-verbose --no-parent --recursive --no-directories --user=%USERNAME% --password=%PASSWORD% -x -P %LOCAL_DIR% %SERVER%

set TARGET_FILENAME=Minecraft_Backup



tar.exe -acf %LOCAL_DIR%.zip -C %LOCAL_DIR% *

rmdir /s /q %LOCAL_DIR%