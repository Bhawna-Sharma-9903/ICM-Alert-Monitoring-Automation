# Load Selenium DLLs
Add-Type -Path "C:\Selenium\WebDriver\lib\netstandard2.0\WebDriver.dll"
Add-Type -Path "C:\Selenium\Support\lib\netstandard2.0\WebDriver.Support.dll"

# Prepare sound player for unsaved alert
Add-Type -AssemblyName presentationCore

function Play-UnsavedNotesSound {
    $player = New-Object System.Media.SoundPlayer "C:\Users\v-bhawnas\Documents\ICM_Notification_Script\Unsaved.wav"
    $player.PlaySync()
}

while ($true) {
    try {
        # EdgeDriver setup (reused from ICM Monitor)
        $edgeDriverPath = "C:\Selenium\edgedriver_win64"
        $service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService($edgeDriverPath)
        $options = New-Object OpenQA.Selenium.Edge.EdgeOptions
        $options.AddArgument("--start-maximized")

        $driver = New-Object OpenQA.Selenium.Edge.EdgeDriver($service, $options)

        Write-Host "Driver launched for Unsaved Notes Monitoring"

        $icmUrl = "https://dev.azure.com/RNAvNext/AvNext/_workitems/edit/391442"
        $driver.Navigate().GoToUrl($icmUrl)

        Read-Host "Login to ICM and open any incident. Then press Enter to monitor for unsaved notes..."

        while ($true) {
            Start-Sleep -Seconds 30  # Poll every 30 seconds

            if ($null -eq $driver) {
                Write-Host "Driver is null. Restarting..."
                break
            }

            try {
                # Check save button status by aria-disabled
                $saveButton = $driver.FindElementById("__bolt-save")
                $ariaDisabled = $saveButton.GetAttribute("aria-disabled")

                if ($ariaDisabled -eq "false") {
                    Write-Host "🚨 You have UNSAVED changes in ICM!"
                    Play-UnsavedNotesSound
                }
                else {
                    Write-Host "✅ Notes are saved."
                }
            }
            catch {
                Write-Host "⚠️ Could not find Save button: $($_.Exception.Message)"
            }
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
