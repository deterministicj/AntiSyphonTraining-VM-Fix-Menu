$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Bypass -File "c:\DisableUpdates.ps1"'

$trigger = New-ScheduledTaskTrigger -AtLogon

Invoke-webRequest -Uri https://github.com/deterministicj/AntiSyphonTraining-VM-disable-updates/blob/main/scripts/DisableUpdates.ps1?raw=true -OutFile C:\DisableUpdates.ps1
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Disable Updates" -RunLevel Highest
Start-ScheduledTask -TaskName "Disable Updates"