$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument '-ExecutionPolicy Bypass -File "c:\DisableUpdates.ps1"'

$trigger = New-ScheduledTaskTrigger -AtLogon

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Disable Updates" -RunLevel Highest
Start-ScheduledTask -TaskName "Disable Updates"