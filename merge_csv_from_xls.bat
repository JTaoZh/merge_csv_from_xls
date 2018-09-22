@echo off

if "%1" == "help" (
    call :help
    exit /b
) else if "%1" == "" (
    call :help
    exit /b
) else if "%2" == "" (
    call :help
    exit /b
) else if "%3" neq "" (
    call :help
    exit /b
)

echo 1. copy xls/xlsx to csv
cscript //nologo xls2csv.vbs -d %1

echo.
echo 2. merge csv files
csv_merge.exe -d "%1\tmp" -o %2

echo.
echo 3. clean tmp
rmdir /s /q "%1\tmp"

exit /b 

:help
echo usage: merge_csv_from_xls.bat [xlsx_folder] [output.csv]
echo example: merge_csv_from_xls.bat test test\output.csv 
exit /b
GOTO:EOF