# Load Selenium DLLs only ONCE
Add-Type -Path "C:\Selenium\WebDriver\lib\netstandard2.0\WebDriver.dll"
Add-Type -Path "C:\Selenium\Support\lib\netstandard2.0\WebDriver.Support.dll"

# Prepare sound player
Add-Type -AssemblyName presentationCore

function Play-RowIncreaseSound {
    $player = New-Object System.Media.SoundPlayer "C:\Users\v-bhawnas\Documents\ICM_Notification_Script\RowIncrease.wav"
    $player.PlaySync()
}

function Play-UnacknowledgedSound {
    $player = New-Object System.Media.SoundPlayer "C:\Users\v-bhawnas\Documents\ICM_Notification_Script\Unacknowledged.wav"
    $player.PlaySync()
}

while ($true) {
    try {
        # Create new Edge Driver service each time
        $edgeDriverPath = "C:\Selenium\edgedriver_win64"
        $service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService($edgeDriverPath)
        $options = New-Object OpenQA.Selenium.Edge.EdgeOptions
        $options.AddArgument("--start-maximized")

        # TEMPORARILY COMMENT PROFILE REUSE
        # $userProfilePath = "C:\Users\YOUR_USERNAME\AppData\Local\Microsoft\Edge\User Data"
        # $options.AddArgument("--user-data-dir=$userProfilePath")
        # $options.AddArgument("--profile-directory=Default")

        $driver = New-Object OpenQA.Selenium.Edge.EdgeDriver($service, $options)

        Write-Host "Driver type: $($driver.GetType().FullName)"

        $icmUrl = "https://portal.microsofticm.com/imp/v3/incidents/search/advanced?sl=lmby4ynv5ct"
        $driver.Navigate().GoToUrl($icmUrl)

        Read-Host "Please login to ICM, then press Enter to start monitoring"

        $previousRowCount = 0

        while ($true) {
            $driver.Navigate().Refresh()
            Start-Sleep -Seconds 5

            if ($null -eq $driver) {
                Write-Host "Driver is null, breaking..."
                break
            }

            # Correct way to call FindElements
            $rows = $driver.FindElements([OpenQA.Selenium.By]::TagName("tr"))
            $actualRowCount = $rows.Count - 1

            Write-Host "Current row count: $actualRowCount"

            if ($actualRowCount -gt $previousRowCount) {
                Write-Host "🚨 New rows added!"
                Play-RowIncreaseSound
                $previousRowCount = $actualRowCount
            }

            $unacknowledgedFound = $false
            foreach ($row in $rows) {
                if ($row.Text -match "Not Acknowledged") {
                    $unacknowledgedFound = $true
                    break
                }
            }

            if ($unacknowledgedFound) {
                Write-Host "⚠️ Unacknowledged Alert Detected!"
                Play-UnacknowledgedSound
            }

            Start-Sleep -Seconds 60
        }

    } catch {
        Write-Host "`n--- Error occurred: $($_.Exception.Message) ---"
        Write-Host "Restarting browser in 5 seconds..."
        Start-Sleep -Seconds 5
    } finally {
        if ($driver -ne $null) {
            $driver.Quit()
        }
    }
}
