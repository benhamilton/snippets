@echo off
cls
echo Usage: ListDropDownLists
echo   This will list DropDown lists in Act! and show their ID number
Set DBServerInstance=%COMPUTERNAME%\ACT7
REM Edit the database name below to suit
Set DBName=ActDemo2013
sqlcmd -S "%DBServerInstance%" -d %DBName% -Q "Select PICKLIST.NAME, PICKLIST.PICKLISTID From PICKLIST order by PICKLIST.NAME ASC" -W -s ", "
