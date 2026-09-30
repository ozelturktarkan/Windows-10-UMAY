param([switch]$RepairInstalledVm)
$ErrorActionPreference='Stop'
Set-StrictMode -Version 2

$expected=Join-Path $env:SystemRoot 'Setup\UMAY'

if ([IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\') -ine $expected.TrimEnd('\')) { throw 'UMAY: yalniz hedef Windows kurulumu icin.' }

$os=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'

if ([Environment]::Is64BitOperatingSystem -or $os.CurrentBuildNumber -ne '14393' -or $os.EditionID -ne 'Core') { throw 'UMAY: beklenmeyen Windows.' }

function Set-Value($Key,$Name,$Value,$Kind='DWord') {

  if (-not (Test-Path -LiteralPath $Key)) { New-Item -Path $Key -Force | Out-Null }

  New-ItemProperty -LiteralPath $Key -Name $Name -Value $Value -PropertyType $Kind -Force | Out-Null

}

Start-Transcript -Path (Join-Path $PSScriptRoot 'Machine.log') -Append | Out-Null

$loaded=$false

try {
  if ($RepairInstalledVm) {
    $principal=New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw 'UMAY: onarim icin yonetici olarak calistirin.' }
    if ((Get-CimInstance Win32_ComputerSystem).Model -notmatch 'VirtualBox') { throw 'UMAY: bu onarim yalniz VirtualBox test makinesi icin.' }
    $launcher=Join-Path $env:SystemDrive 'UMAY\UMAY-Bilesenleri.bat'
    if ((Get-FileHash -LiteralPath $launcher -Algorithm SHA256).Hash -ine '4F386D6F1ACDF902FC8E4729965B075AA1A1243A5C49CA239497B898103AD050') { throw 'UMAY: beklenen test kurulumu bulunamadi.' }
  } elseif ([Security.Principal.WindowsIdentity]::GetCurrent().User.Value -ne 'S-1-5-18' -or (Get-ItemProperty 'HKLM:\SYSTEM\Setup').SystemSetupInProgress -ne 1) {
    throw 'UMAY: Windows Setup SYSTEM baglami gerekli.'
  }
  Set-Value 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' 'NoAutoUpdate' 1

  Set-Value 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' 'AllowCortana' 0

  Set-Value 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' 'AllowGameDVR' 0

  # UMAY service profile r3: preserve WSearch, CDP and servicing.
  foreach ($service in @('DiagTrack','SSDPSRV','OneSyncSvc')) {
    $serviceKey='HKLM:\SYSTEM\CurrentControlSet\Services\'+$service
    if (-not (Test-Path -LiteralPath $serviceKey)) { throw ('UMAY r3: service missing: '+$service) }
    Set-Value $serviceKey 'Start' 4
  }
  Set-Value 'HKLM:\SOFTWARE\UMAY' 'ServiceRevision' 'r3' 'String'

  $default=[Environment]::ExpandEnvironmentVariables((Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList').Default)

  & "$env:SystemRoot\System32\reg.exe" load 'HKU\UMAY_Default' (Join-Path $default 'NTUSER.DAT')

  if ($LASTEXITCODE -ne 0) { throw 'Default hive acilamadi.' }; $loaded=$true

  $root='Registry::HKEY_USERS\UMAY_Default'

  Set-Value ($root+'\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects') 'VisualFXSetting' 3
  foreach($v in @(@('TaskbarAnimations',0),@('ListviewShadow',1),@('ListviewAlphaSelect',0),@('IconsOnly',1))) { Set-Value ($root+'\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced') $v[0] $v[1] }
  Set-Value ($root+'\Software\Microsoft\Windows\DWM') 'AlwaysHibernateThumbnails' 0
  Set-Value ($root+'\Software\Microsoft\Windows\DWM') 'EnableAeroPeek' 0
  Set-Value ($root+'\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize') 'EnableTransparency' 0
  $run='"'+$env:SystemRoot+'\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File "'+$expected+'\Initialize-User.ps1"'

  Set-Value ($root+'\Software\Microsoft\Windows\CurrentVersion\RunOnce') '!UMAYFirstLogon' $run 'String'
  [GC]::Collect();[GC]::WaitForPendingFinalizers()
  & "$env:SystemRoot\System32\reg.exe" unload 'HKU\UMAY_Default'
  if ($LASTEXITCODE -ne 0) { throw 'Default hive kaydedilip bosaltilamadi.' }
  $loaded=$false
  $public=[Environment]::ExpandEnvironmentVariables('%PUBLIC%\Desktop')

  New-Item -ItemType Directory -Path $public -Force | Out-Null

  Copy-Item -LiteralPath (Join-Path $env:SystemDrive 'UMAY\UMAY-Bilesenleri.bat') -Destination $public -Force
  Set-Value 'HKLM:\SOFTWARE\UMAY' 'Profile' 'UMAY-1607-x86-v0.1' 'String'
  Set-Value 'HKLM:\SOFTWARE\UMAY' 'MachineRevision' 'r2' 'String'
  Set-Value 'HKLM:\SOFTWARE\UMAY' 'ReleaseRevision' 'r5' 'String'
  if ($RepairInstalledVm) {
    & "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'Initialize-User.ps1')
    if ($LASTEXITCODE -ne 0) { throw 'UMAY: mevcut kullanici ayarlari tamamlanamadi.' }
  }
  Write-Output 'UMAY makine ayarlari tamamlandi.'
} finally {

  if ($loaded) { [GC]::Collect();[GC]::WaitForPendingFinalizers(); & "$env:SystemRoot\System32\reg.exe" unload 'HKU\UMAY_Default'; if ($LASTEXITCODE -ne 0) { Write-Warning 'Default hive bosaltma hatasi.' } }

  Stop-Transcript | Out-Null

}

