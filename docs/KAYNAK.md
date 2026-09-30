# Kaynak ve doğrulama kayıtları

Proje sahibi başlangıç medyasını [Archive.org / win10-1607](https://archive.org/download/win10-1607) adresinden indirdiğini belirtmiştir. Türkçe 32 bit dosya adı `Win10_1607_Turkish_x32.iso` şeklindedir. [Arşiv metadata kaydı](https://archive.org/metadata/win10-1607) 30 Eylül 2026'da okunmuştur.

## Arşiv tarafından bildirilen kaynak ISO bilgileri

| Alan | Değer |
|---|---|
| Dosya | `Win10_1607_Turkish_x32.iso` |
| Bayt | 2.971.324.416 |
| MD5 | `e66d3a61ae5881d450208617b6641a29` |
| SHA-1 | `b7b35f4ea3876ac46723725f0dcdce93563a8457` |

Bu değerler arşiv sağlayıcısının kayıtlarıdır. Yayımlama sırasında başlangıç ISO dosyasının tamamı yerelde yeniden hash edilmedi; bağımsız bir Microsoft özgünlük referansıyla da doğrulanmadı. “Arşivdeki dosyayla eşleşiyor” ve “Microsoft özgünlüğü doğrulandı” aynı iddia değildir.

## Yerel üretimde kaydedilen WIM bilgileri

- İlk Home+Pro `install.wim` SHA-256: `4d9c883417bb1ceeb3102a0f716c38693133d285a04ac4c5be8d86eaffe546c8`.
- Home başlangıç indeksi: 2. Home seçilip tek indeks olarak dışa aktarıldı; üretimde indeks 1 kullanıldı.
- Debloat öncesi tek-Home dışa aktarım SHA-256: `9422345a554c2f36348efda09f8eac566287a6d23cc0b7f17bfcc621e10d922b`.
- Hazırlanmış UMAY `install.wim` SHA-256: `2ca48d23c7147965ef0bdbe3c5e04f2eb4c734373a5ee696c80f6435a32856a4`.

Bu WIM özetleri ISO dosyasının tamamına ait değildir. Son **UMAY ISO** özetleri [checksums](../checksums/) klasöründedir. Araç sürümleri, boot.wim ve .NET kaynağı özetleri [KAYNAK.json](KAYNAK.json) içindedir.

Kaynak lisansı ve özgünlüğünün doğrulanması kullanıcıya ait bağımsız bir adımdır. UMAY yayımlama kaydı, Archive.org barındırmasını Microsoft'un resmi dağıtım kanalı olarak sunmaz.
