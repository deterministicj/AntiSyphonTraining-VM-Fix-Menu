#Main Menu w/ input
Write-Output "ADHD Lab Fix Menu"
Write-Output "`n---------------------------------------------------"
Write-Output "1. Disable automatic updates"
Write-Output "2. Fix Hashcat lab - CL_DEVICE_NOT_AVAILABLE error"
Write-Output "---------------------------------------------------`n"

Function DisableUpdates {
    #Create Disable Updates task if it does not exist
    Write-Output "Checking if task already exists..."
    $taskExists = Get-ScheduledTask -TaskName "Disable Updates" -ErrorAction SilentlyContinue

    if (-not $taskExists) {
        Write-Output "Downloading required scripts"
        Invoke-webRequest -Uri https://github.com/deterministicj/AntiSyphonTraining-VM-disable-updates/blob/main/scripts/DisableUpdatesJob.ps1?raw=true -OutFile C:\DisableUpdatesJob.ps1
        C:\DisableUpdatesJob.ps1 >$null
        Write-Output "Task Created - Automatic updates have been disabled"
    } else {
        Write-Output "Task already exists"
    }
}

Function HashcatFix {
    #Download and install Intel OpenCL update
    Write-Output "Downloading Intel OpenCL Update..."
    Invoke-WebRequest -Uri http://registrationcenter-download.intel.com/akdlm/irc_nas/12512/opencl_runtime_16.1.2_x64_setup.msi -OutFile C:\Users\ADHD\Downloads\opencl_runtime_16.1.2_x64_setup.msi
    msiexec /i C:\Users\adhd\Downloads\opencl_runtime_16.1.2_x64_setup.msi /quiet
    Write-Output "Update installed, please try running Hashcat again"
}

# Loop for input
do {
    $input = Read-Host -Prompt "Which option would you like to select? (1,2, or q to exit)"
    
    # Check for valid input
    if ($input -eq "1") {
        DisableUpdates
        break
    } elseif ($input -eq "2") {
        HashcatFix
        break
    } elseif ($input -eq "q") {
        # Exit loop if 'q' is entered
        break
    } else {
        # Handle invalid input
        Write-Output "Invalid option. Please select a valid option (1, 2, or q to exit)."
    }
} until ($false)