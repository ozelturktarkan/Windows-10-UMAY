# Ölçülen performans ve sınırları

30 Eylül 2026, önceki UMAY profili, Windows 10 Home 1607 x86, VirtualBox, **1 vCPU / 1.024 MiB RAM**. Bu ölçümler final r5 görsel tercih değişikliğinden önce yapılmıştır. Son r5 ISO'sunun temiz kurulum ve iki hesap doğrulaması [ayrı rapordadır](TEST-SONUCU.json).

## Boşta 15 dakika

| Ölçüt | Sonuç |
|---|---:|
| Süre / örnek | 900,44 saniye / 887 |
| Ortalama CPU | %0,251 |
| En yüksek yaklaşık 1 saniyelik CPU örneği | %36,923 |
| %10 üzeri yükseliş kümeleri | 7 |
| %10 üzerinde toplam süre | 8,11 saniye, yaklaşık %0,9 |
| Ortalama kesme/ISR payı | %0,0503 |
| En yüksek kesme/ISR örneği | %6,154 |

Sürekli yüksek boşta yük görülmedi; kısa sıçramalar vardı. Bunlar saklanarak “CPU her zaman %1” denmez. Tanılama aracının da ölçüme yük eklediği unutulmamalıdır.

## Ayrı süreçli yük ve toparlanma

Geçerli denemede 180,91 saniyelik işlemci/bellek/disk doğrulama programı çıkış kodu 0 ve Errors=0 ile tamamlandı. Toplam gözlem penceresi 210,28 saniyeydi; bunun son yaklaşık 29 saniyesinde yük zaten bitmişti.

| Ölçüt | Yük gözlem penceresi | Sonraki toparlanma |
|---|---:|---:|
| Ortalama CPU | %85,97 | %2,22 |
| Ortalama ISR | %1,745 | %0,100 |
| En yüksek ISR | %25,76 | %1,54 |
| En uzun örnek aralığı | 1,113 sn | 1,165 sn |
| Bölüm sonunda kullanılabilir bellek | 723,69 MiB | 725,46 MiB |

Yükte yaklaşık bir saniyelik %25,76 ISR tepesi kaydedildi. Sürücü/fonksiyon ataması yapılmadığından belirli bir sürücü suçlanmaz. 1'den 2 vCPU'ya geçişin tek başına çekirdek kilitlenmesine yol açtığına dair bir sonuç çıkarılmadı. WMI, sayaçlar veya bellek sıkıştırması bu gerekçeyle kapatılmadı.

İlk denemelerden biri yük ile gözlemciyi aynı süreçte çalıştırdığı için uzun örnekleme aralıkları verdi; başka bir deneme rapor üretiminde bellek hatasıyla sonuçlandı. Bu koşular başarılı yük testi sayılmadı. Yukarıdaki yük tablosu, gözlemci/yük ayrımı ve rapor yazımı düzeltildikten sonraki tamamlanmış denemeye aittir.

275 MB gösteren masaüstü ekran görüntüsü tek bir anı temsil eder; sabit RAM gereksinimi değildir. 512/768 MiB, bellek tükenmesi, gerçek ağır programların birlikte kullanımı, grafik/ağ yükleri veya uzun dönem kararlılık bu testlerle doğrulanmış değildir. Önceki profilde AppX dağıtım hata kayıtları da görüldü; bütün olay günlüklerinin hatasız olduğu iddia edilmez.
