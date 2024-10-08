@echo on

call config.bat


set EXCLUDE_DIRS=dynmap/web
REM ignore all .bak files and all ZIP files in root folder
set EXCLUDE_REGEX="ftp:\/\/([0-9]{1,3}\.){3}[0-9]{1,3}\/([^\/]*\.zip|.*\.bak)$"

REM Set the local folder where files will be downloaded
set LOCAL_DIR=backups\%date%

IF exist %LOCAL_DIR% (
  echo Target directory "%LOCAL_DIR%" already exists. Will not be overwritten. Delete manually to create a new backup for today
  exit /b 1
)

echo "Download to directory: %LOCAL_DIR%"

mkdir %LOCAL_DIR%


echo wget -X %EXCLUDE_DIRS% --regex-type pcre --reject-regex %EXCLUDE_REGEX% --no-verbose --no-parent --recursive --no-directories --user=%USERNAME% --password=%PASSWORD% -x -P %LOCAL_DIR% %SERVER%
wget -X %EXCLUDE_DIRS% --regex-type pcre --reject-regex %EXCLUDE_REGEX% --no-verbose --no-parent --recursive --no-directories --user=%USERNAME% --password=%PASSWORD% -x -P %LOCAL_DIR% %SERVER%

REM tar.exe -a -c -f %LOCAL_DIR%.zip %LOCAL_DIR%

REM rmdir /s /q %LOCAL_DIR%