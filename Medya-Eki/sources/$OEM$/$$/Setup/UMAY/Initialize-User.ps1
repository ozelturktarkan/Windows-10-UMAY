$ErrorActionPreference='Stop'

if ($PSScriptRoot -ine (Join-Path $env:SystemRoot 'Setup\UMAY')) { throw 'UMAY hedef klasoru gerekli.' }

if ((Get-ItemProperty 'HKLM:\SOFTWARE\UMAY' -ErrorAction SilentlyContinue).Profile -ne 'UMAY-1607-x86-v0.1') { throw 'UMAY kurulu degil.' }

if (Test-Path 'HKCU:\Software\UMAY\Initialized') { exit 0 }

function Set-Value($Key,$Name,$Value,$Kind='DWord') { if (-not (Test-Path -LiteralPath $Key)) { New-Item -Path $Key -Force | Out-Null };New-ItemProperty -LiteralPath $Key -Name $Name -Value $Value -PropertyType $Kind -Force | Out-Null }

$base='HKCU:\Software\Microsoft\Windows\CurrentVersion'

Set-Value ($base+'\Themes\Personalize') 'EnableTransparency' 0

Set-Value ($base+'\Explorer\Advanced') 'TaskbarAnimations' 0

Set-Value ($base+'\Explorer\Advanced') 'HideFileExt' 0

Set-Value 'HKCU:\Control Panel\Desktop\WindowMetrics' 'MinAnimate' '0' 'String'

Set-Value ($base+'\Search') 'BingSearchEnabled' 0

Set-Value ($base+'\Search') 'CortanaConsent' 0
# UMAY service profile r3: SearchUI disabled, indexer retained.
Set-Value 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'SearchboxTaskbarMode' 0

Set-Value ($base+'\AdvertisingInfo') 'Enabled' 0

foreach ($name in @('SilentInstalledAppsEnabled','SoftLandingEnabled','SystemPaneSuggestionsEnabled','PreInstalledAppsEnabled','OemPreInstalledAppsEnabled')) { Set-Value ($base+'\ContentDeliveryManager') $name 0 }

Set-Value 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 0

Set-Value 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0

& (Join-Path $PSScriptRoot 'Set-VisualEffects.ps1')
New-Item 'HKCU:\Software\UMAY\Initialized' -Force | Out-Null

