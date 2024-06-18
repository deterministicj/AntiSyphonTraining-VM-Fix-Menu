
$banner = @"
    _    ____  _   _ ____    _____ _        __  __                  
   / \  |  _ \| | | |  _ \  |  ___(_)_  __ |  \/  | ___ _ __  _   _ 
  / _ \ | | | | |_| | | | | | |_  | \ \/ / | |\/| |/ _ \ '_ \| | | |
 / ___ \| |_| |  _  | |_| | |  _| | |>  <  | |  | |  __/ | | | |_| |
/_/   \_\____/|_| |_|____/  |_|   |_/_/\_\ |_|  |_|\___|_| |_|\__,_|                                                                                         
"@

$menu = @"
Options
---------------------------------------------------
1. Disable automatic updates
2. Fix Password Cracking lab - CL_DEVICE_NOT_AVAILABLE
---------------------------------------------------
"@

Write-Host $banner
Write-Host " `n"
Write-Host $menu -ForegroundColor Cyan
Write-Host "`n"

Function DisableUpdates {
    #Create Disable Updates task if it does not exist
    Write-Host "Checking if task already exists..."
    $taskExists = Get-ScheduledTask -TaskName "Disable Updates" -ErrorAction SilentlyContinue

    if (-not $taskExists) {
        Write-Host "Downloading required scripts"
        Invoke-webRequest -Uri https://github.com/deterministicj/AntiSyphonTraining-VM-disable-updates/blob/main/scripts/DisableUpdatesJob.ps1?raw=true -OutFile C:\DisableUpdatesJob.ps1
        C:\DisableUpdatesJob.ps1 >$null
        
        try { 
            Get-ScheduledTask -TaskName "Disable Updates" -ErrorAction Stop
            Write-Host "Task Created - Automatic updates have been disabled"
        }
        catch {
            Write-Host "Error:$_"
            Write-Host "There was an issue creating the task, please try again"
        }
    } else {
        Write-Host "Task already exists - Automatic updates have already been disabled"
    }
}

Function HashcatFix {
    #Download and install Intel OpenCL update
    Write-Host "Downloading Intel OpenCL Update..."
    Invoke-WebRequest -Uri http://registrationcenter-download.intel.com/akdlm/irc_nas/12512/opencl_runtime_16.1.2_x64_setup.msi -OutFile C:\Users\ADHD\Downloads\opencl_runtime_16.1.2_x64_setup.msi
    msiexec /i C:\Users\adhd\Downloads\opencl_runtime_16.1.2_x64_setup.msi /quiet

    try {
        $regPath = 'HKLM:\SOFTWARE\Intel\OpenCL'
        $regKey = 'cpu_version'
        $openCLVersion = Get-ItemPropertyValue -Path $regPath -Name $regKey -ErrorAction SilentlyContinue
        
        if ($openCLVersion -eq "6.4.0.37") {
            Write-Host "Update installed, please try running Hashcat again"
        } else {
            Write-Host "Update failed ($openCLVersion), please try installing again"
        }    

    } catch {
        Write-Host "There was an issue checking the installed version of Intel OpenCL, please try installing again"
        Write-Host "Error: $_"
    }
}

# Loop for input
do {
    $userInput = Read-Host -Prompt "Which option would you like to select? (1,2, or q to exit)"
    
    # Check for valid input
    if ($userInput -eq "1") {
        DisableUpdates
        break
    } elseif ($userInput -eq "2") {
        HashcatFix
        break
    } elseif ($userInput -eq "q") {
        # Exit loop if 'q' is entered
        break
    } else {
        # Handle invalid input
        Write-Host "Invalid option. Please select a valid option."
    }
} until ($false)