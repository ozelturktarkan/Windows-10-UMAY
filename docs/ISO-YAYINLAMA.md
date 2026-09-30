# ISO indirme ve yükleme durumu

Bu depoda ISO yoktur. Proje sahibi `Windows 10 UMAY.iso` dosyasını [Windows 10 UMAY — Internet Archive](https://archive.org/details/windows-10-umay) adresine yüklemektedir. Dosyanın boyutu 2.615.805.952 bayttır. Yayımlanacak dosyayı [kayıtlı özetlerle](../checksums/ISO-hashes.json) karşılaştırın; dosya değişirse önce yeni özetleri hesaplayıp sürüm kaydını güncelleyin.

**Durum — 30 Eylül 2026:** [Arşiv metadata API'si](https://archive.org/metadata/windows-10-umay) henüz dosya listesi döndürmedi. Bağlantı yükleme hedefidir; tamamlanmış veya hash eşleşmesi doğrulanmış indirme olarak sunulmaz. Yerel ISO'nun özetleri hesaplanmış durumdadır; arşivdeki kopyanın doğrulaması ayrı bir adımdır.

Yükleme tamamlandığında dosya adını, bayt boyutunu ve arşivin hesapladığı MD5/SHA-1 değerlerini kayıtlı özetlerle karşılaştırın. Elle girilen açıklama/metadata hash alanları, arşivin dosyadan hesapladığı özetlerin yerine geçmez. İndirenler dosyanın tamamı üzerinden SHA-256 hesaplayarak README'deki değerle karşılaştırabilir. Kontrolün sonucunu README ve sürüm kaydına işleyin; başlangıç Windows arşivini UMAY indirmesiyle karıştırmayın.

[GitHub Releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases) tek dosya için **2 GiB altında** boyut ister. Bu ISO yaklaşık 2,44 GiB olduğu için tek dosya halinde Release eki olamaz. ISO'yu uygun başka bir barındırmada yayımlayıp GitHub'dan bağlantı verebilirsiniz. Bölünmüş arşiv kullanılırsa parçaların ve birleştirilmiş ISO'nun özetlerini ayrı kaydedin; mevcut ISO özeti yalnız birleştirilmiş ISO'ya aittir.

GitHub'ın Code → Download ZIP seçeneği bu depodaki küçük kaynakları indirir; Windows kurulum ISO'sunu içermez.
