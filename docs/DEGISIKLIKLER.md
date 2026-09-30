# r5 değişikliklerinin kapsamı

## Gerçek kaldırma ve kapatma ayrımı

NTLite'ın kabul ettiği 35 girdilik liste [XML dosyasında](../NTLite-UMAY.xml) bulunur. Liste bir kaldırma talebidir; bağımlılık koruması bazı parçaları tutabilir. Önceki WIM kontrollerinde `mspaint.exe`, WordPad'in `wordpad.exe` dosyası, `OneDriveSetup.exe` ve Defender'ın `MsMpEng.exe` dosyasının yokluğu ayrıca doğrulandı.

SearchUI dosyası yeniden adlandırılır; Cortana'nın tüm paketinin kaldırıldığı söylenmez. Game DVR ayarları kapatılır ve Xbox arayüz paketleri kaldırılır; `bcastdvr.exe` ve tüm yerel yakalama bileşenlerinin silindiği iddia edilmez.

DiagTrack, SSDPSRV ve OneSyncSvc kapalıdır. WSearch, CDPUserSvc ve CDPSvc korunur. Windows Update/BITS/TrustedInstaller korunur; `NoAutoUpdate` ilkesi yazılır. Bu durum “99 yıl garantili güncelleme engeli” olarak sunulmaz.

Defender dosyasının kaldırılması güvenlik duvarının kaldırılması anlamına gelmez. Güvenlik duvarı testte çalışır durumdaydı. Bu tabanın destek süresi bitmiştir ve güncel güvenlik garantisi verilmez.

## Korunan altyapı

.NET Framework 4, PowerShell, WMI, performans sayaçları, olay günlükleri, MSI, DISM/CBS/WinSxS, ağ/DHCP/DNS ve sonradan bileşen ekleme altyapısı tutulur. Pagefile ve bellek sıkıştırması kapatılmaz. Sürücüler, fontlar, klavyeler ve tüm dil dosyaları topluca kaldırılmaz. Böylece belirli bir donanımın sürücülerini imaja gömmek yerine kaynak Windows'un genel kurulum yapısı korunur.

## Bileşen Merkezi

Masaüstündeki `UMAY-Bilesenleri.bat` yönetici olarak açılır:

1. **.NET Framework 3.5:** UMAY DVD'sindeki `sources/sxs` kaynağını SHA-256 ile kontrol ederek DISM üzerinden etkinleştirir. .NET 3.5, Microsoft Windows bileşenidir.
2. **Ek Microsoft çalışma ortamları:** medyadaki tanımlı paketleri denetleyerek çalıştırır. Bu yayında paket listesi boştur; kendiliğinden internetten kurucu indirilmez.
3. **VirtualBox Guest Additions:** kullanıcının taktığı Oracle CD'sindeki imzalı x86 kurucuyu çalıştırır. ISO içinde Guest Additions bulunmaz.
4. **.NET 3.5 durumu:** DISM ile durum bilgisi gösterir.

Bu menü NTLite ile kaldırılan her Windows bileşenini sihirli biçimde geri getirmez. Kaldırılmış Paint/Store gibi parçalar için otomatik geri yükleme garantisi yoktur. Eski Windows sertifika veya kurucu uyumluluğu nedeniyle yeni paketleri reddedebilir; hash/imza kontrolü bu sebeple kaldırılmaz.

## Görsel ve kullanıcı ayarları

ClearType, masaüstü simge yazısı gölgesi, menü öğesi seçim fade efekti ve pencere gölgesi açıktır. Diğer Performans Seçenekleri efektleri ile saydamlık kapalıdır. Başlat yalnız Edge kutucuğuyla hazırlanır; kaldırılmış uygulama önerileri/indirme kutuları ve görev çubuğu arama simgesi gizlenir.

Her hesabın ilk oturumunda bir kez uygulanır. Kullanıcının sonradan yaptığı tercihler tekrar tekrar sıfırlanmaz. Görsel ayarlar başka bir makinenin bit maskesi kopyalanarak değil, [Microsoft SystemParametersInfo API'si](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-systemparametersinfow) ve ilgili kullanıcı kayıtlarıyla uygulanır.
