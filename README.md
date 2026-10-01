# Windows 10 UMAY

> **Tüm diziyi keşfedin:** Windows 10 ve Windows 11 profillerini, donanım hedeflerini ve yayın durumlarını birlikte görmek için [Windows 10/11 HAKANLAR Dizesi ana reposunu ziyaret edin](https://github.com/ozelturktarkan/Windows-10-11-HAKANLAR-Dizesi).

**Türkçe Windows 10 Home 1607 · 32 bit · Sanal bilgisayarlar ve yazılım denemeleri için**

UMAY, hazır bir Windows imajında nelerin değiştirildiğini görebilmek ve kendi imajını aynı tarifle hazırlayabilmek isteyenler için doğdu. Bu depoda kullandığımız NTLite XML'i, eklediğimiz betikler, üretim adımları, ISO özetleri ve test sonuçları bulunuyor. Amacımız güveni bir söze dayandırmak yerine yaptığımız değişiklikleri incelemeye açmak.

> **Bize güvenmek zorunda değilsiniz.** Uygun [NTLite lisansını](https://ntlite.com/pricing/) edinip kendi Windows 10 Home 1607 Türkçe x86 kaynağınız üzerinde bu depodaki XML'i **yardımcı betikler ve medya ekiyle birlikte** uygulayarak kendi UMAY imajınızı hazırlayabilirsiniz. [Yeniden üretim kılavuzu](docs/YENIDEN-URETIM.md) bütün adımları açıklar.

Yalnız XML bütün UMAY profilini üretmez. Hedef aynı yapılandırmayı üretmektir; zaman damgaları, WIM sıkıştırması ve araç sürümleri nedeniyle **bayt bayt aynı ISO/hash garantisi verilmez**. Üretim tarifinin ikinci bir temiz NTLite çalıştırmasıyla uçtan uca karşılaştırması henüz yapılmadı.

## Bu sürüm

| Özellik | Değer |
|---|---|
| Ad | Windows 10 UMAY |
| Yapılandırma | r5 — 30 Eylül 2026 |
| Taban | Windows 10 Home 1607, yapı 14393.0 |
| Dil ve mimari | Türkçe, x86 / 32 bit |
| Kurulum indeksi | Yalnız Home; indeks 1 |
| ISO dosyası | `Windows 10 UMAY.iso` |
| ISO boyutu | 2.615.805.952 bayt, yaklaşık 2,44 GiB |
| Doğrulanan ortam | VirtualBox 7.2.20, BIOS, 1 vCPU, 1.024 MiB RAM |

**ISO indir:** [Windows 10 UMAY.iso — yaklaşık 2,44 GiB](https://archive.org/download/windows-10-umay/Windows%2010%20UMAY.iso) · [Internet Archive arşiv sayfası](https://archive.org/details/windows-10-umay)

**Yükleme doğrulandı — 30 Eylül 2026:** Arşivin dosya kaydındaki 2.615.805.952 bayt boyutu, MD5 ve SHA-1 değerleri aşağıdaki yerel yayın kayıtlarıyla eşleşti; doğrudan indirme bağlantısı HTTP 200 ve beklenen boyutu döndürdü. ISO bu kontrolde tamamen yeniden indirilmedi; SHA-256 yeniden hesaplanmadı. [Doğrulama kaydı](reports/ARCHIVE-DOGRULAMA.json). Bu Git deposu yalnız küçük kaynak ve belge dosyalarını içerir. Aşağıdaki başlangıç kaynağı bağlantısı UMAY'ın indirme bağlantısı değildir.

ISO, makineye özel kullanıcı hesabı, parola, ürün anahtarı veya Guest Additions içermez. Disk seçimi ve kullanıcı oluşturma kuran kişiye bırakılır. BIOS ve x86 EFI önyükleme girdileri bulunur; çalışma testi BIOS üzerinde yapılmıştır. “Genel kurulum imajı” ifadesi bütün donanım ve hipervizörlerde başarı garantisi değildir.

## Güvenlik ve kullanım amacı

UMAY **deneysel VM/test sürümüdür; günlük kullanım için güvenli veya uzun vadede kararlı olduğu iddia edilmez**. Windows 10 Home 1607'nin resmi desteği bitmiştir; bu taban güncel güvenlik düzeyine getirilmiş değildir. [Microsoft yaşam döngüsü](https://learn.microsoft.com/en-us/lifecycle/products/windows-10-home-and-pro)

Defender kaldırma uygulamasının ardından MsMpEng dosyasının yokluğu doğrulandı; güvenlik duvarı korunur. Bunlar bir güvenlik sertifikası veya bağımsız zararlı yazılım denetimi yerine geçmez. Düşük RAM kullanımı da tek başına güvenlik, uygulama uyumluluğu veya kararlılık kanıtı değildir.

## Neler değişti?

- Paint, WordPad, OneDrive, Store, Xbox arayüz paketleri, çeşitli yerleşik/tanıtım uygulamaları ve yazdırma bileşenleri kaldırma listesine alındı. Uygulanan **35 girdilik liste**: [NTLite-UMAY.xml](NTLite-UMAY.xml).
- `SearchUI.exe` geri alınabilir biçimde yeniden adlandırıldı. Başlat/görev çubuğunda yazarak arama kapalı; **WSearch korunuyor**. Cortana paketinin bütünüyle silindiği iddia edilmiyor.
- Game DVR kayıt ayarları kapalı, Xbox arayüz paketleri kaldırıldı. **Yerel Game DVR dosyalarının tamamı kaldırılmadı.**
- DiagTrack, SSDPSRV ve OneSyncSvc kapalı. CDP hizmetleri korunuyor.
- Başlat'taki indirme/öneri yer tutucuları temizlendi; Edge kutucuğu bırakıldı. Görev çubuğu arama simgesi gizli.
- WMI, performans sayaçları, olay günlükleri, MSI, .NET Framework 4, PowerShell, DISM/CBS/WinSxS ve Windows Update altyapısı korunuyor.
- Otomatik güncellemeler için `NoAutoUpdate=1` yazılıyor. Windows Update hizmeti kökten kapatılmıyor; **Home sürümünün çevrimiçi güncelleme davranışı kapsamlı test edilmedi**.
- Pagefile ve bellek sıkıştırması korunuyor. HPET, işlemci sayısı veya yüzde 100 işlemci alt sınırı gibi hızlandırma ayarları ISO'ya eklenmiyor. Sürücü, font ve klavye dosyaları topluca budanmıyor.

[Ayrıntılı değişiklikler ve bileşen menüsü](docs/DEGISIKLIKLER.md)

## Görsel profil

Yeni kullanıcıların ilk oturumunda şu dört seçenek açılır:

1. Ekran yazı tipi kenarlarını düzeltme — ClearType.
2. Masaüstündeki simge yazılarının altında gölge.
3. Seçilen menü öğesinin kısa süre görünür kalıp silinmesi.
4. Pencerelerin altında gölge.

Diğer Performans Seçenekleri efektleri ve genel saydamlık kapalıdır. Üçüncü seçenek normal seçim vurgusundan farklı bir efekttir. Ayarlar ilk oturumda bir kez uygulanır; kullanıcı daha sonra değiştirebilir.

## ISO hash özetleri

Aşağıdaki değerler **son UMAY ISO dosyasının tamamı okunarak** hesaplandı. Kaynak Windows ISO'sunun özetleriyle karıştırmayın.

| Algoritma | `Windows 10 UMAY.iso` |
|---|---|
| MD5 | `b3a13385ce44a4b35cf4066520248c17` |
| SHA-1 | `7f58f37d1b1df89775940649c00ed273ed28fe71` |
| SHA-256 | `d42362e43ee347e84e5e44930abdaa2db0e3b0f1238f892b986bf28615432440` |

MD5 ve SHA-1 eski araçlarla karşılaştırma için verilir; doğrulamada SHA-256'yı esas alın. Bir hash eşleşmesi dosyaların eşleştiğini denetlemeye yarar; dosyanın zararsızlığını veya Microsoft tarafından üretildiğini kanıtlamaz.

PowerShell ile indirdiğiniz dosyayı denetleyebilirsiniz:

```powershell
Get-FileHash -LiteralPath '.\Windows 10 UMAY.iso' -Algorithm SHA256
Get-FileHash -LiteralPath '.\Windows 10 UMAY.iso' -Algorithm SHA1
Get-FileHash -LiteralPath '.\Windows 10 UMAY.iso' -Algorithm MD5
```

Makine tarafından okunabilir kayıtlar: [checksums/](checksums/). Depodaki küçük dosyaların ayrı özeti: [SOURCE-SHA256SUMS.txt](SOURCE-SHA256SUMS.txt).

## Başlangıç kaynağı

Proje sahibi, başlangıç ISO'sunu [Archive.org Windows 10 1607 arşivinden](https://archive.org/download/win10-1607) indirdiğini belirtmiştir. Kullanılan dil/mimari için arşivdeki dosya adı `Win10_1607_Turkish_x32.iso` şeklindedir. Home+Pro medyasından yalnız **Home** seçilmiştir.

Archive.org bağlantısı bir üçüncü taraf indirme kaynağıdır; burada “Microsoft tarafından doğrulanmış özgün ISO” iddiası yapılmaz. Arşivin yayımladığı özetler, yerel WIM kayıtları ve doğrulama sınırları [kaynak belgesinde](docs/KAYNAK.md) ayrı gösterilir. Kendi güvendiğiniz ve kullanmaya yetkili olduğunuz Windows kaynağını tercih edin.

## Ne test edildi?

- Son r5 ISO'suyla boş sanal diske otomatik temiz kurulum tamamlandı.
- İlk yönetici hesabı ve sonradan oluşturulan standart hesapta ilk oturum ayarları, görsel efektler, sade Başlat, bileşen menüsünün hedef kontrolü ve korunan hizmetler doğrulandı.
- ISO içindeki WIM'in SHA-256'sı üretim WIM'iyle eşleşti; medya eki dosyaları bayt düzeyinde doğrulandı.
- Önceki aynı UMAY tabanında 15 dakikalık boşta ölçüm ve sınırlı 3 dakikalık işlemci/bellek/disk yük testi yapıldı. **275 MB gibi tek ekran görüntüsü değerleri RAM garantisi olarak kullanılmıyor.**

Test otomasyonu yalnız özel test medyasında hesap, bölümleme ve Guest Additions ekledi. Bunlar yayımlanan ISO'da yoktur. Elle yürütülen üretim OOBE ekranlarının tam tekrarı, EFI kurulumu, 512/768 MiB RAM, tüm hipervizörler ve uzun dönem uygulama uyumluluğu doğrulanmış değildir.

[Test raporu](reports/TEST-SONUCU.json) · [Performans ölçümlerinin özeti](reports/PERFORMANS.md) · [ISO içerik doğrulaması](reports/ISO-sonucu.json)

## Kendi imajınızı hazırlayın

[Yeniden üretim kılavuzunu](docs/YENIDEN-URETIM.md) izleyin. Gerekli parçalar:

| Dosya/klasör | Görevi |
|---|---|
| [NTLite-UMAY.xml](NTLite-UMAY.xml) | NTLite kaldırma ve uyumluluk ön ayarı |
| [Medya-Eki/](Medya-Eki/) | Kurulum yanıtı, makine/kullanıcı ayarları ve bileşen menüsü |
| [tools/Finalize-Wim.py](tools/Finalize-Wim.py) | Çalışma WIM'inde SearchUI'yi yeniden adlandırma |
| [tools/Build-ISO.py](tools/Build-ISO.py) | Hazırlanmış kaynak ve medya ekinden ISO üretimi |
| [docs/KAYNAK.json](docs/KAYNAK.json) | Araç sürümleri ve kaynak özetleri |

Windows kurulum dosyaları, ürün anahtarı, etkinleştirme aracı veya NTLite lisansı bu depoda paylaşılmaz. UMAY, Microsoft'un resmi bir Windows sürümü değildir. NTLite premium özelliklerini kullanmak için kullanımınıza uygun lisans gerekir; lisans türü ve kapsamı için [NTLite'ın kendi açıklamasını](https://ntlite.com/pricing/) okuyun.
