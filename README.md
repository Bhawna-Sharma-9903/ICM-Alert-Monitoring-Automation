<img width="1919" height="977" alt="image" src="https://github.com/user-attachments/assets/0c45783c-6416-4232-b2d9-5a84efc02910" />🛠️ ICM Alert Monitoring Automation

Real-time ICM incident monitoring tool built with PowerShell, Selenium, and EdgeDriver.
Designed to reduce manual monitoring fatigue, minimize missed alerts, and improve operational response time.

✨ Features

🔄 Auto-refresh: Periodically refreshes ICM page to check for new incidents.
📊 Row tracking: Detects changes in incident count dynamically.
🔔 Sound notifications: Plays alerts for new rows or unacknowledged incidents.
🕑 Shift/day awareness: Filters alerts based on current day and shift timing.
💻 Lightweight & customizable: Easily adaptable for Teams/email integration.

📂 Project Structure
ICM-Monitor-Automation/
│

├── src/

│   └── ICM-Monitor.ps1        # Main PowerShell automation script
│

├── docs/

│   ├── README.md            # Project documentation

│   └── screenshots/           # Screenshots or demo GIFs

│
├── sounds/                    # Example alert sound files (placeholders)

│   ├── RowIncrease.wav
│   └── Unacknowledged.wav
│

├── .gitignore
└── LICENSE

⚙️ Setup Instructions
Prerequisites
PowerShell 7+
Selenium WebDriver DLLs (WebDriver.dll, WebDriver.Support.dll)
Microsoft Edge WebDriver (matching your Edge browser version)
.wav files for alerts (can be replaced with custom sounds)

Installation

Clone this repository:

git clone https://github.com/<your-username>/ICM-Monitor-Automation.git
cd ICM-Monitor-Automation/src


Place WebDriver.dll and WebDriver.Support.dll in:

C:\Selenium\WebDriver\lib\netstandard2.0\
C:\Selenium\Support\lib\netstandard2.0\
Install matching EdgeDriver from Edge WebDriver Downloads

▶️ Usage
Run the script:
 & "C:\Selenium\ICM_Notification_Script\ICM-Monitor.ps1"    # Whatever path you have your script

Steps:
Step 1. Script opens ICM login page.
Step 2. Log in manually.
<img width="1919" height="977" alt="image" src="https://github.com/user-attachments/assets/8668cd01-f2e6-4b8e-99fb-92567ca36001" />

Step 3. Press Enter to start monitoring.
<img width="1718" height="818" alt="image" src="https://github.com/user-attachments/assets/0cda8a23-45f1-4d01-9ca2-7b7d9df173c6" />

The script will refresh periodically, track incidents, and play sounds if:

New rows are detected.

An Unacknowledged alert is found.
<img width="1479" height="439" alt="image" src="https://github.com/user-attachments/assets/40505e1a-535e-42a6-93c9-61e619c104a9" />



