param([switch]$CheckOnly)
$ErrorActionPreference='Stop'
$os=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
if ([Environment]::Is64BitOperatingSystem -or $os.CurrentBuildNumber -ne '14393' -or $os.EditionID -ne 'Core') { throw 'UMAY 1607 x86 Home gerekli.' }
if ($PSScriptRoot -ine (Join-Path $env:SystemRoot 'Setup\UMAY')) { throw 'UMAY hedef klasoru gerekli.' }
if ((Get-ItemProperty 'HKLM:\SOFTWARE\UMAY' -ErrorAction SilentlyContinue).Profile -ne 'UMAY-1607-x86-v0.1') { throw 'UMAY profili gerekli.' }
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class UmayVisual {
 [DllImport("user32.dll", EntryPoint="SystemParametersInfoW", SetLastError=true)]
 static extern bool Set(uint action,uint param,IntPtr value,uint flags);
 [DllImport("user32.dll", EntryPoint="SystemParametersInfoW", SetLastError=true)]
 static extern bool Get(uint action,uint param,out int value,uint flags);
 [StructLayout(LayoutKind.Sequential)] public struct Animation {public uint size;public int enabled;}
 [DllImport("user32.dll", EntryPoint="SystemParametersInfoW", SetLastError=true)]
 static extern bool Anim(uint action,uint param,ref Animation value,uint flags);
 public static void Put(uint action,int value,bool inUiParam) {
  if(!Set(action,inUiParam?(uint)value:0,inUiParam?IntPtr.Zero:new IntPtr(value),3))
   throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error(),"SPI set "+action);
 }
 public static int Read(uint action) {int v;if(!Get(action,0,out v,0))throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error(),"SPI get "+action);return v;}
 public static void NoMinAnimation(){var a=new Animation{size=8,enabled=0};if(!Anim(0x49,8,ref a,3))throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());}
 public static int MinAnimation(){var a=new Animation{size=8};if(!Anim(0x48,8,ref a,0))throw new System.ComponentModel.Win32Exception(Marshal.GetLastWin32Error());return a.enabled;}
}
'@
# Official SystemParametersInfo constants; preserve unrelated input/accessibility settings.
$effects=@(
 @('TooltipAnimation',0x1017,0x1016,0),@('TooltipFade',0x1019,0x1018,0),
 @('ComboBoxAnimation',0x1005,0x1004,0),@('ClientAreaAnimation',0x1043,0x1042,0),
 @('CursorShadow',0x101B,0x101A,0),@('ListBoxSmoothScrolling',0x1007,0x1006,0),
 @('SelectionFade',0x1015,0x1014,1),@('MenuAnimation',0x1003,0x1002,0),
 @('MenuFade',0x1013,0x1012,0),@('DropShadow',0x1025,0x1024,1)
)
$reg=@(
 @('Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects','VisualFXSetting',3),
 @('Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','TaskbarAnimations',0),
 @('Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','ListviewShadow',1),
 @('Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','ListviewAlphaSelect',0),
 @('Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','IconsOnly',1),
 @('Software\Microsoft\Windows\DWM','AlwaysHibernateThumbnails',0),
 @('Software\Microsoft\Windows\DWM','EnableAeroPeek',0),
 @('Software\Microsoft\Windows\CurrentVersion\Themes\Personalize','EnableTransparency',0)
)
if(-not $CheckOnly){
 [UmayVisual]::Put(0x103F,1,$false)
 foreach($e in $effects){[UmayVisual]::Put($e[1],$e[3],$false)}
 [UmayVisual]::Put(0x4B,1,$true)
 [UmayVisual]::Put(0x200B,2,$false)
 [UmayVisual]::Put(0x25,0,$true)
 [UmayVisual]::NoMinAnimation()
 foreach($r in $reg){$k=[Microsoft.Win32.Registry]::CurrentUser.CreateSubKey($r[0]);try{$k.SetValue($r[1],[int]$r[2],[Microsoft.Win32.RegistryValueKind]::DWord)}finally{$k.Dispose()}}
}
$checks=[ordered]@{}
foreach($e in $effects){$checks[$e[0]]=([UmayVisual]::Read($e[2]) -eq $e[3])}
$checks.FontSmoothing=([UmayVisual]::Read(0x4A) -ne 0)
$checks.FontSmoothingType=([UmayVisual]::Read(0x200A) -eq 2)
$checks.DragFullWindows=([UmayVisual]::Read(0x26) -eq 0)
$checks.MinAnimation=([UmayVisual]::MinAnimation() -eq 0)
foreach($r in $reg){$k=[Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($r[0]);try{$checks[$r[1]]=($null -ne $k -and $k.GetValue($r[1],-1) -eq $r[2])}finally{if($k){$k.Dispose()}}}
$passed=(@($checks.Values|Where-Object{-not $_}).Count -eq 0)
$report=[ordered]@{Revision='r5';User=[Environment]::UserName;Passed=$passed;Checks=$checks}
$out=Join-Path $env:LOCALAPPDATA 'UMAY'
if(-not(Test-Path -LiteralPath $out)){New-Item -ItemType Directory -Path $out -Force|Out-Null}
$report|ConvertTo-Json -Depth 4|Set-Content -LiteralPath (Join-Path $out 'Visual-r5.json') -Encoding UTF8
if(-not $passed){throw 'UMAY gorsel ayarlar dogrulanamadi; LocalAppData\UMAY\Visual-r5.json dosyasina bakin.'}
if(-not $CheckOnly){$k=[Microsoft.Win32.Registry]::CurrentUser.CreateSubKey('Software\UMAY');try{$k.SetValue('VisualRevision','r5')}finally{$k.Dispose()}}
