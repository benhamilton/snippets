@echo off
cls
echo Usage: ListDropDown <dropdownlistid>
echo   This will list the contents of the Act! dropdown list you've specified by the ID number
Set DBServerInstance=%COMPUTERNAME%\ACT7
REM Edit the database name below to suit
Set DBName=ActDemo2013
sqlcmd -S "%DBServerInstance%" -d %DBName% -Q "Select PICKLIST_ITEM.NAME From PICKLIST_ITEM Where PICKLIST_ITEM.PICKLISTID = '%1'" -W -s ", "
