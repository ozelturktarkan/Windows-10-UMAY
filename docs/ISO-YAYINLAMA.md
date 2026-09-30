# ISO yayını

`Windows 10 UMAY.iso` Internet Archive üzerinde yayımlandı. Bu Git deposunda ISO bulunmaz.

- [ISO'yu indir — yaklaşık 2,44 GiB](https://archive.org/download/windows-10-umay/Windows%2010%20UMAY.iso)
- [Arşiv sayfası](https://archive.org/details/windows-10-umay)
- [Kayıtlı ISO özetleri](../checksums/ISO-hashes.json)

## Yükleme doğrulaması — 30 Eylül 2026

[Arşiv metadata API'sinin](https://archive.org/metadata/windows-10-umay) `files[]` listesindeki ISO kaydı, yerel yayın kaydıyla karşılaştırıldı:

| Alan | Arşivdeki değer | Sonuç |
|---|---|---|
| Boyut | 2.615.805.952 bayt | Eşleşti |
| MD5 | `b3a13385ce44a4b35cf4066520248c17` | Eşleşti |
| SHA-1 | `7f58f37d1b1df89775940649c00ed273ed28fe71` | Eşleşti |

Doğrudan indirme adresine HTTP HEAD isteği 200 ve beklenen Content-Length değerini döndürdü. Bu kontrol açıklamaya elle girilen hash alanlarını değil, arşivin dosya listesindeki özetleri kullanır. [Makine tarafından okunabilir kontrol kaydı](../reports/ARCHIVE-DOGRULAMA.json).

ISO'nun tamamı bu kontrolde yeniden indirilmedi. Arşivin dosya kaydında SHA-256 bulunmadığından uzak kopyanın SHA-256'sı bağımsız olarak hesaplanmış sayılmaz. İndirenler aşağıdaki komutla kendi kopyalarını denetleyebilir:

```powershell
Get-FileHash -LiteralPath '.\Windows 10 UMAY.iso' -Algorithm SHA256
```

Beklenen SHA-256: `d42362e43ee347e84e5e44930abdaa2db0e3b0f1238f892b986bf28615432440`.

Bu belge güncellemesi r5 ISO'sunu, NTLite XML'ini veya üretim betiklerini değiştirmez. Başlangıç Windows arşivi ile UMAY indirmesi ayrı kaynaklardır; hash eşleşmesi bir güvenlik sertifikası değildir.
