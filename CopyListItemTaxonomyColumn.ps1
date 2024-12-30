# SharePoint Online Management Shell modülünü yükleme
if (!(Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Write-Host "PnP.PowerShell modülü yükleniyor..." -ForegroundColor Yellow
    Install-Module -Name PnP.PowerShell -Force
}

# .env dosyasından değişkenleri okuma
$envContent = Get-Content -Path ".\.env"
$envVariables = @{}
foreach ($line in $envContent) {
    if ($line -match '(.+)="(.+)"') {
        $key = $matches[1]
        $value = $matches[2]
        $envVariables[$key] = $value
    }
}

# Değişkenleri .env dosyasından al
$siteUrl = $envVariables["SITE_URL"]
$listName = $envVariables["LIST_NAME"]
$sourceItemId = $envVariables["SOURCE_ITEM_ID"]
$taxonomyFieldName = $envVariables["TAXONOMY_FIELD_NAME"]

try {
    # SharePoint Online'a web login ile bağlanma
    Write-Host "SharePoint'e bağlanılıyor..." -ForegroundColor Yellow
    Connect-PnPOnline -Url $siteUrl -UseWebLogin
    Write-Host "SharePoint'e başarıyla bağlanıldı!" -ForegroundColor Green

    # Kaynak öğeden Lokasyon değerini alma
    Write-Host "Kaynak öğe alınıyor (ID: $sourceItemId)..." -ForegroundColor Yellow
    $sourceItem = Get-PnPListItem -List $listName -Id $sourceItemId
    if ($null -eq $sourceItem) {
        throw "Kaynak öğe (ID: $sourceItemId) bulunamadı!"
    }

    # Taxonomy değerini string formatında hazırla
    $termValue = "$($envVariables["TERM_GUID"]);#$($envVariables["TERM_PATH"])|$($sourceItem[$taxonomyFieldName].TermGuid)"
    Write-Host "Kullanılacak term değeri: $termValue" -ForegroundColor Cyan

    # Tüm liste öğelerini al
    Write-Host "Liste öğeleri alınıyor..." -ForegroundColor Yellow
    $allItems = Get-PnPListItem -List $listName
    Write-Host "Toplam $($allItems.Count) öğe bulundu." -ForegroundColor Gray
    $counter = 0

    foreach ($item in $allItems) {
        try {
            if ($null -eq $item[$taxonomyFieldName] -or $item[$taxonomyFieldName] -eq "") {
                Write-Host "ID: $($item.Id) güncelleniyor..." -ForegroundColor Yellow
                
                Set-PnPListItem -List $listName -Identity $item.Id -Values @{
                    $taxonomyFieldName = $termValue
                }
                
                $counter++
                Write-Host "ID: $($item.Id) güncellendi." -ForegroundColor Green
                Start-Sleep -Seconds 1  # Her güncelleme arasına 1 saniye bekleme ekle
            }
        }
        catch {
            Write-Host "ID: $($item.Id) güncellenirken hata oluştu: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Hata detayı: $($_)" -ForegroundColor Red
        }
    }

    Write-Host "`nİşlem başarıyla tamamlandı!" -ForegroundColor Green
    Write-Host "Toplam $counter adet öğe güncellendi." -ForegroundColor Green
}
catch {
    Write-Host "Bir hata oluştu: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Hata detayı: $($_)" -ForegroundColor Red
}
finally {
    # Bağlantıyı kapat
    Disconnect-PnPOnline
    Write-Host "SharePoint bağlantısı kapatıldı." -ForegroundColor Gray
}