# UMAY r5 yeniden üretim kılavuzu

Bu tarif, kendi Windows kaynağınızdan aynı UMAY yapılandırmasını oluşturmak içindir. Yalnız NTLite XML'ini uygulamak yeterli değildir. Tam tarifin ikinci, sıfırdan NTLite üretimiyle aynı sonuç verdiği henüz uçtan uca karşılaştırılmadı; bayt bayt aynı ISO hash'i vaat edilmez.

## Kullanılan araçlar

- NTLite **2026.09.11904.0**, gerekli premium kaldırmalar için uygun lisans.
- Windows üzerinde **64 bit Python 3.12** ve **pycdlib 1.14.0**.
- NTLite dağıtımındaki **x64 `libwim-15.dll`**; dosya depoya eklenmez.
- Türkçe **Windows 10 1607 x86**, Home / Core, yapı **14393.0** kurulum kaynağı.

Araçları resmi kaynaklarından edinin. Farklı NTLite sürümleri bileşen adlarını, korumaları ve çıktıyı değiştirebilir. 64 bit Python ile x64 wimlib DLL'i eşleşmelidir; bu, oluşturulan Windows'un x86 olmasını değiştirmez.

## 1. Temiz çalışma kopyası ve Home indeksi

ISO'yu ayrı bir çalışma klasörüne çıkartın; orijinal kaynağı koruyun. Örnekte `V:\UMAY-CALISMA` kullanılıyor. Bu klasörde yalnız Windows kurulum dosyaları bulunmalı; kişisel dosya, hesap/parola, test diski veya başka ISO koymayın.

Kaynağı NTLite'a ekleyin. Bizim Home+Pro kaynağımızda Home başlangıçta **indeks 2** idi. Önce kendi medyanızın indekslerini doğrulayın; farklı kaynağa körlemesine indeks 2 uygulamayın. Yalnız **Windows 10 Home** kalacak şekilde dışa aktarın/diğer indeksi çalışma kopyasından çıkarın. Sonuç **tek görüntü, Home, indeks 1** olmalı.

Üretimde kullanılan dışa aktarım: `DISM Export-Image /SourceIndex:2 /Compress:max /CheckIntegrity`. Kaynak WIM yedeğini üretim klasörünün dışında tutun. Dışa aktarımın hash'i zaman damgası ve araç farklarından etkilenebilir.

## 2. NTLite ön ayarı

Çalışma kopyasındaki Home görüntüsünü yükleyin. Depo kökündeki `NTLite-UMAY.xml` dosyasını ön ayar olarak içe aktarın. Kaldırma listesi ve uyumluluk korumalarını gözden geçirip uygulayın; sonucu **WIM** biçiminde kaydedin ve görüntüyü boşaltın.

XML 35 kaldırma girdisi içerir. NTLite bir girdiyi atladığında bunu sessizce başarılı saymayın; günlük ve çıkan dosyaları inceleyin. Ücretli bileşen kaldırmaları için uygun NTLite lisansını kullanın. Windows güncellemeleri, ek programlar veya kişisel sürücüler eklemek aynı yayın yapılandırmasından farklı bir sonuç üretir.

## 3. SearchUI adımı

Bu komutları **depo kökünde**, kendi yollarınızı yazarak çalıştırın. ISO'nun kaynak klasörünü hedefleyin; çalışan Windows üzerinde uygulamayın.

```powershell
python tools/Finalize-Wim.py --wim "V:\UMAY-CALISMA\sources\install.wim" --dll "V:\NTLite\Tools\wimlib\x64\libwim-15.dll"
```

Betik Home/x86/14393/tek indeks denetimi yapar. `SearchUI.exe` dosyasını aynı klasörde `SearchUI.exe.UMAY-disabled` olarak yeniden adlandırır; Cortana paketini tamamen silmez. Bu adımı aynı WIM üzerinde yalnız bir kez uygulayın. `--check-only` yalnız görüntü kimliğini ve tek indeks koşulunu denetler; SearchUI adımının veya diğer kaldırmaların tamamlandığını doğrulamaz.

## 4. ISO üretimi

```powershell
python -m pip install pycdlib==1.14.0
python tools/Build-ISO.py --source "V:\UMAY-CALISMA" --overlay ".\Medya-Eki" --output "V:\UMAY-CIKTI\Windows 10 UMAY.iso" --report "V:\UMAY-CIKTI\ISO-sonucu.json"
```

Önce çıktı klasörünü oluşturun. Çıktıyı kaynak klasörünün dışında tutun. Var olan ISO'nun üzerine yazılmaz; önceki sonucu saklayıp farklı bir çıktı yolu kullanın.

Üretici, kaynak dosyaları ile `Medya-Eki` içeriğini ISO içinde birleştirir; kaynak klasörünü değiştirmez. Medya eki `$OEM$` üzerinden hedef Windows'a kopyalanır. `Apply-Machine.ps1` specialize aşamasında makine ayarlarını ve Default kullanıcıdaki RunOnce kaydını hazırlar; `Initialize-User.ps1` ve `Set-VisualEffects.ps1` her yeni hesabın ilk oturumunda çalışır.

`Build-ISO.py` dizin içeriğini ve medya eki dosyalarının bayt eşitliğini denetler; ISO/WIM SHA-256 kayıtlarını oluşturur. Bu denetimler işletim sisteminin tüm işlevlerinin çalıştığını kanıtlamaz.

## 5. Çıktıyı kendi testinizle doğrulayın

Önce boş bir sanal diskte deneyin. Kaydedilmiş test ortamımız BIOS, 1 vCPU ve 1.024 MiB RAM'dir. Disk ve ağ tercihlerinin VM ayarı olduğunu, ISO'nun bunları zorlamadığını unutmayın.

Kurulum, ilk masaüstü, yeni standart kullanıcı, dört görsel tercih, sade Başlat, gizli arama simgesi, güvenlik duvarı, bileşen menüsü ve kullanacağınız gerçek programları kontrol edin. .NET 3.5 gerekiyorsa UMAY ISO'sunu DVD sürücüsüne takıp masaüstü menüsünden ayrıca etkinleştirin. Sonradan dil/bileşen ekleme altyapısının korunması, her paketin başarıyla yükleneceği anlamına gelmez.

## Yeniden üretim ve güven sınırı

NTLite XML'i Windows kaynak kodu değildir. Bu depo yaptığımız yapılandırmayı görünür kılar; Windows tabanının veya kullanılan üçüncü taraf araçların bağımsız güvenlik denetimi yerine geçmez. Hash farkı tek başına zararlı ekleme kanıtı değildir; hash eşitliği de dosyanın güvenli olduğunu kanıtlamaz. Karşılaştırmada aynı tabanı, araç sürümlerini, bileşen listesini ve çalışma testlerini birlikte inceleyin.
