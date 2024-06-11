Function DisableStoreUpdates {
    $regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore'
    $regKey = 'AutoDownload'
    #Write-Output "Test Start"
    try {
        # Test if key exists
        if (Test-Path $regPath) {
            $storeKey = Get-ItemPropertyValue -Path $regPath -Name $regKey -ErrorAction Stop
            #Write-Output "Test Exist"
            # Change value if not set properly
            if ($storeKey -ne 2) {
                Set-ItemProperty -Path $regPath -Name $regKey -Value 2
                #Write-Output "Test Not Set Prop"
            } else {
                #Write-Output "Test Set Prop"
            }
        } else {
            # Create key if it does not exist
            #Write-Output "Create Key"
            New-Item -Path $regPath -Force | Out-Null
            Set-ItemProperty -Path $regPath -Name $regKey -Value 2
        }
    } catch {
        Write-Output "Error: $_"
    }
}

Function DisableWindowsUpdates {
    try {
        Get-Service 'wuauserv' | Stop-Service -PassThru | Set-Service -StartupType Disabled
        #Write-Output "Test Disable Serv"
    } catch {
        Write-Output "Error: $_"
    }
}

DisableStoreUpdates
#Write-Output "Test Change"
DisableWindowsUpdates