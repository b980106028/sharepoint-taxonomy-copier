# SharePoint Taxonomy Copier

Bu PowerShell scripti, SharePoint listesindeki bir öğenin taksonomi alanını diğer öğelere kopyalamak için kullanılır.

[Click for English README](README.md)

## Kurulum

1. Bu repoyu klonlayın:
```powershell
git clone https://github.com/b980106028/sharepoint-taxonomy-copier.git
```

2. `.env.example` dosyasını `.env` olarak kopyalayın ve değişkenleri kendi ortamınıza göre düzenleyin:
```powershell
Copy-Item .env.example .env
```

3. PnP.PowerShell modülünü yükleyin (script otomatik olarak yükleyecektir, ama manuel yüklemek isterseniz):
```powershell
Install-Module -Name PnP.PowerShell -Force
```

## Kullanım

1. `.env` dosyasındaki değişkenleri kendi ortamınıza göre ayarlayın:
   - SITE_URL: SharePoint sitenizin URL'i
   - LIST_NAME: Liste adı
   - SOURCE_ITEM_ID: Taksonomi değerini kopyalamak istediğiniz öğenin ID'si
   - TAXONOMY_FIELD_NAME: Taksonomi alanının adı

2. Scripti çalıştırın:
```powershell
.\CopyListItemTaxonomyColumn.ps1
```

## Özellikler

- SharePoint Online bağlantısı için web login kullanır
- Taksonomi alanı değerlerini otomatik kopyalar:
  - Kaynak öğeden (SOURCE_ITEM_ID ile belirtilen) term yolu ve GUID dahil tüm taksonomi değerini alır
  - Bu değeri aynı listedeki boş taksonomi alanlarına kopyalar
  - Kaynak öğedeki term yapısını otomatik olarak korur
- Akıllı güncelleme süreci:
  - Sadece boş taksonomi alanı olan öğeleri günceller
  - Zaten değeri olan öğeleri atlar
  - Her güncelleme arasında 1 saniye bekler (throttling'i önlemek için)
- Kapsamlı hata yönetimi ve loglama:
  - Detaylı ilerleme bilgisi gösterir
  - Her öğe için başarı/hata mesajları verir
  - Toplam güncellenen öğe sayısını raporlar
- Hassas veriler için çevre değişkenleri kullanır

## Güvenlik

- Hassas bilgiler `.env` dosyasında saklanır
- `.env` dosyası `.gitignore` ile versiyon kontrolünden hariç tutulur
- Örnek değişkenler `.env.example` dosyasında gösterilir

## Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen Pull Request göndermekten çekinmeyin.

## Lisans

Bu proje MIT Lisansı ile lisanslanmıştır - detaylar için LICENSE dosyasına bakınız.
