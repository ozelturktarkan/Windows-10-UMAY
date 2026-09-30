param([switch]$CheckOnly)
$ErrorActionPreference='Stop'
$expected=Join-Path $env:SystemDrive 'UMAY'
if ([IO.Path]::GetFullPath($PSScriptRoot).TrimEnd('\') -ine $expected.TrimEnd('\')) { throw 'Yalniz UMAY sanal makinesindeki kurulumdan calistirin.' }
$os=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
if ([Environment]::Is64BitOperatingSystem -or $os.CurrentBuildNumber -ne '14393' -or $os.EditionID -ne 'Core') { throw 'UMAY 1607 x86 Home gerekli.' }
if ((Get-ItemProperty 'HKLM:\SOFTWARE\UMAY' -ErrorAction SilentlyContinue).Profile -ne 'UMAY-1607-x86-v0.1') { throw 'UMAY profil isareti bulunamadi.' }
if ($CheckOnly) { Write-Output 'UMAY hedef kontrolu gecti.';exit 0 }
$principal=New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw 'UMAY-Bilesenleri.bat dosyasini yonetici olarak calistirin.' }
$config=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'Paketler.json') -Raw | ConvertFrom-Json
function Find-Media {
  foreach ($d in [IO.DriveInfo]::GetDrives()) {
    if ($d.DriveType -ne [IO.DriveType]::CDRom -or -not $d.IsReady) { continue }
    $marker=Join-Path $d.RootDirectory.FullName 'UMAY-MEDIA.json'
    if (Test-Path -LiteralPath $marker) {
      $m=Get-Content -LiteralPath $marker -Raw | ConvertFrom-Json
      if ($m.profile -eq 'UMAY-1607-x86-v0.1') { return $d.RootDirectory.FullName }
    }
  }
  throw 'UMAY ISO dosyasini sanal DVD surucusune takin.'
}
function Install-Net35 {
  $media=Find-Media
  $sxs=Join-Path $media 'sources\sxs'
  $cab=Join-Path $sxs 'microsoft-windows-netfx3-ondemand-package.cab'
  if ((Get-FileHash -LiteralPath $cab -Algorithm SHA256).Hash -ine $config.net35_sha256) { throw 'NET 3.5 kaynak dosyasi uyusmuyor.' }
  & "$env:SystemRoot\System32\Dism.exe" /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess "/Source:$sxs" /NoRestart
  $code=$LASTEXITCODE
  if ($code -eq 3010) { Write-Host 'Basarili; yeniden baslatma gerekli.' }
  elseif ($code -eq 0) { Write-Host 'NET 3.5 etkinlestirildi.' }
  else { throw "DISM hata kodu: $code. Bilesen gunlugunu inceleyin." }
}
function Install-External {
  $media=Find-Media
  $folder=Join-Path $media 'UMAY-EkPaketler'
  $manifest=Join-Path $folder 'packages.json'
  $packages=@((Get-Content -LiteralPath $manifest -Raw | ConvertFrom-Json).packages)
  if ($packages.Count -eq 0) { Write-Host 'Bu surumde ek calisma ortami paketi bulunmuyor. Uygulamaniza uygun x86/1607 paketi ve hash kaydi ayrica hazirlanmalidir.'; return }
  for ($i=0;$i -lt $packages.Count;$i++) { Write-Host (([string]($i+1))+': '+$packages[$i].name) }
  $n=0;if (-not [int]::TryParse((Read-Host 'Paket numarasi; vazgecmek icin 0'),[ref]$n) -or $n -lt 1 -or $n -gt $packages.Count) { return }
  $pkg=$packages[$n-1]
  if ([IO.Path]::GetFileName($pkg.file) -ne $pkg.file -or $pkg.file -notmatch '\.exe$' -or $pkg.arch -ne 'x86' -or $pkg.windows_build -ne '14393') { throw 'Paket tanimi uygun degil.' }
  $file=Join-Path $folder $pkg.file
  if ((Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash -ine $pkg.sha256) { throw 'Paket hash uyusmazligi.' }
  $sig=Get-AuthenticodeSignature -LiteralPath $file
  if ($sig.Status -ne 'Valid' -or $sig.SignerCertificate.Subject -notmatch 'Microsoft Corporation') { throw 'Gecerli Microsoft imzasi bulunamadi.' }
  $p=Start-Process -FilePath $file -Wait -PassThru
  Write-Host ('Kurucu cikis kodu: '+$p.ExitCode)
}
function Install-Guest {
  foreach ($d in [IO.DriveInfo]::GetDrives()) {
    if ($d.DriveType -ne [IO.DriveType]::CDRom -or -not $d.IsReady) { continue }
    $file=Join-Path $d.RootDirectory.FullName 'VBoxWindowsAdditions-x86.exe'
    if (Test-Path -LiteralPath $file) {
      $sig=Get-AuthenticodeSignature -LiteralPath $file
      if ($sig.Status -ne 'Valid' -or $sig.SignerCertificate.Subject -notmatch 'Oracle') { throw 'Gecerli Oracle imzasi bulunamadi.' }
      $p=Start-Process -FilePath $file -Wait -PassThru;Write-Host ('Guest Additions kurucu cikis kodu: '+$p.ExitCode);return
    }
  }
  throw 'VirtualBox Aygitlar menusunden Guest Additions CD kalibini takin.'
}
$logs=Join-Path $env:ProgramData 'UMAY\Logs';New-Item -ItemType Directory -Path $logs -Force | Out-Null
Start-Transcript -Path (Join-Path $logs ('Bilesen-'+(Get-Date -Format 'yyyyMMdd-HHmmss')+'.log')) | Out-Null
try {
  while ($true) {
    Write-Host "`nUMAY Bilesen Merkezi`n1 - NET Framework 3.5`n2 - Medyadaki ek Microsoft calisma ortamlari`n3 - VirtualBox Guest Additions`n4 - NET 3.5 durumunu goster`n0 - Cikis"
    $choice=Read-Host 'Secim'
    if ($choice -eq '0') { break }
    try {
      switch ($choice) {
        '1' { Install-Net35 }
        '2' { Install-External }
        '3' { Install-Guest }
        '4' { & "$env:SystemRoot\System32\Dism.exe" /Online /Get-FeatureInfo /FeatureName:NetFx3 }
        default { Write-Host 'Gecersiz secim.' }
      }
    } catch { Write-Host $_.Exception.Message -ForegroundColor Red }
  }
} finally { Stop-Transcript | Out-Null }
