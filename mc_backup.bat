@echo off

set /p "stopped=Ist Server heruntergefahren? (YES eingeben, wenn ja): "

IF NOT "%stopped%" == "YES" (
  echo Dann bitte Server erst herunterfahren!
  exit /b 1
)

call config.bat

set EXCLUDE_DIRS=dynmap/web
REM ignore all .bak files and all ZIP files in root folder
set EXCLUDE_REGEX="ftp:\/\/([0-9]{1,3}\.){3}[0-9]{1,3}\/([^\/]*\.zip|.*\.bak)$"

set LOCAL_DIR=backups\%date%

IF exist %LOCAL_DIR% (
  rmdir /s /q %LOCAL_DIR%
)

echo "Download to directory: %LOCAL_DIR%"

mkdir %LOCAL_DIR%

wget -X %EXCLUDE_DIRS% --regex-type pcre --reject-regex %EXCLUDE_REGEX% --no-verbose --no-parent --recursive --no-directories --user=%USERNAME% --password=%PASSWORD% -x -P %LOCAL_DIR% %SERVER%

tar.exe -acf %LOCAL_DIR%.zip -C %LOCAL_DIR% *

rmdir /s /q %LOCAL_DIR%