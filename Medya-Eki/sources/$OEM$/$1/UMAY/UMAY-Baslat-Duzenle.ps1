$ErrorActionPreference='Stop'
if ((Get-ItemProperty 'HKLM:\SOFTWARE\UMAY').Profile -ne 'UMAY-1607-x86-v0.1') { throw 'Not UMAY' }
if ([Environment]::OSVersion.Version.Build -ne 14393) { throw '1607 required' }
$backup=Join-Path $env:LOCALAPPDATA ('UMAY\Start-r4-backup-'+(Get-Date -Format yyyyMMdd-HHmmss))
New-Item -ItemType Directory -Path $backup -Force | Out-Null
Export-StartLayout -Path (Join-Path $backup 'Before.xml')
$layout=Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Shell\LayoutModification.xml'
if (Test-Path $layout) { Copy-Item -LiteralPath $layout -Destination $backup }
$xml=@'
<LayoutModificationTemplate Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride><StartLayoutCollection><defaultlayout:StartLayout GroupCellWidth="6">
    <start:Group Name="UMAY"><start:Tile Size="2x2" Column="0" Row="0" AppUserModelID="Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" /></start:Group>
  </defaultlayout:StartLayout></StartLayoutCollection></DefaultLayoutOverride>
</LayoutModificationTemplate>
'@
[IO.File]::WriteAllText($layout,$xml,(New-Object Text.UTF8Encoding($false)))
$search='HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
if (-not (Test-Path $search)) { New-Item $search -Force | Out-Null }
New-ItemProperty $search -Name SearchboxTaskbarMode -Value 0 -PropertyType DWord -Force | Out-Null
$tdl=Join-Path $env:windir 'System32\tdlrecover.exe'
if (-not (Test-Path $tdl)) { throw 'tdlrecover unavailable; only XML staged' }
$p=Start-Process -FilePath $tdl -ArgumentList '-resetlayout','-resetcache' -WindowStyle Hidden -PassThru -Wait
Write-Output ('Backup='+$backup)
Write-Output ('tdlrecover_exit='+$p.ExitCode)
Start-Sleep -Seconds 3
Export-StartLayout -Path 'C:\UMAY\Start-after-r4.xml'
[xml]$after=[IO.File]::ReadAllText('C:\UMAY\Start-after-r4.xml')
$tiles=@($after.SelectNodes('//*[local-name()="Tile"]'))
$placeholders=@($after.SelectNodes('//*[local-name()="SecondaryTile"]'))
$apps=@(Get-StartApps | Select-Object -ExpandProperty AppID)
$check=[ordered]@{ User=$env:USERNAME; TdlExit=$p.ExitCode; TileCount=$tiles.Count; PlaceholderCount=$placeholders.Count; EdgePreserved=($tiles.Count -eq 1 -and $tiles[0].AppUserModelID -eq 'Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge'); SearchIcon=(Get-ItemProperty $search).SearchboxTaskbarMode; ExplorerRunning=[bool](Get-Process explorer -ErrorAction SilentlyContinue); ShellRunning=[bool](Get-Process ShellExperienceHost -ErrorAction SilentlyContinue); AppIds=$apps; Backup=$backup; VisualTested=$false }
$check | ConvertTo-Json -Depth 3 | Set-Content 'C:\UMAY\Start-r4-result.json' -Encoding UTF8
if (Test-Path 'A:\UMAYR4.TAG') { Copy-Item -LiteralPath 'C:\UMAY\Start-r4-result.json' -Destination 'A:\START-R4.JSON' -Force }
if (-not $check.EdgePreserved -or $check.PlaceholderCount -ne 0 -or $check.SearchIcon -ne 0) { throw 'Start layout verification failed' }
Write-Output ($check | ConvertTo-Json -Depth 3)
