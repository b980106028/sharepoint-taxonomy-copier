# SharePoint List Item Taxonomy Copier

Bu PowerShell scripti, SharePoint listesindeki bir öğenin taksonomi alanını diğer öğelere kopyalamak için kullanılır.

## Kurulum

1. Bu repoyu klonlayın:
```powershell
git clone [repo-url]
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
   - TERM_GUID: Term GUID'i
   - TERM_PATH: Taksonomi yolu

2. Scripti çalıştırın:
```powershell
.\CopyListItemTaxonomyColumn.ps1
```

## Özellikler

- SharePoint Online bağlantısı için web login kullanır
- Belirtilen listedeki boş taksonomi alanlarını doldurur
- Her güncelleme arasında 1 saniye bekler
- Hata yönetimi ve loglama içerir

## Güvenlik

- Hassas bilgiler `.env` dosyasında saklanır
- `.env` dosyası `.gitignore` ile versiyon kontrolünden hariç tutulur
- Örnek değişkenler `.env.example` dosyasında gösterilir
