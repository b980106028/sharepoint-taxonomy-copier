# Install SharePoint Online Management Shell module
if (!(Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Write-Host "Installing PnP.PowerShell module..." -ForegroundColor Yellow
    Install-Module -Name PnP.PowerShell -Force
}

# Read variables from .env file
$envContent = Get-Content -Path ".\.env"
$envVariables = @{}
foreach ($line in $envContent) {
    if ($line -match '(.+)="(.+)"') {
        $key = $matches[1]
        $value = $matches[2]
        $envVariables[$key] = $value
    }
}

# Get variables from .env file
$siteUrl = $envVariables["SITE_URL"]
$listName = $envVariables["LIST_NAME"]
$sourceItemId = $envVariables["SOURCE_ITEM_ID"]
$taxonomyFieldName = $envVariables["TAXONOMY_FIELD_NAME"]

try {
    # Connect to SharePoint Online using web login
    Write-Host "Connecting to SharePoint..." -ForegroundColor Yellow
    Connect-PnPOnline -Url $siteUrl -UseWebLogin
    Write-Host "Successfully connected to SharePoint!" -ForegroundColor Green

    # Get taxonomy value from source item
    Write-Host "Getting source item (ID: $sourceItemId)..." -ForegroundColor Yellow
    $sourceItem = Get-PnPListItem -List $listName -Id $sourceItemId
    if ($null -eq $sourceItem) {
        throw "Source item (ID: $sourceItemId) not found!"
    }

    # Prepare taxonomy value string from source item
    Write-Host "Getting taxonomy value from source item..." -ForegroundColor Yellow
    $sourceTermPath = $sourceItem[$taxonomyFieldName].Label
    $termValue = "$($envVariables["TERM_GUID"]);#$sourceTermPath|$($sourceItem[$taxonomyFieldName].TermGuid)"
    Write-Host "Term value to be used: $termValue" -ForegroundColor Cyan

    # Get all list items
    Write-Host "Retrieving list items..." -ForegroundColor Yellow
    $allItems = Get-PnPListItem -List $listName
    Write-Host "Found $($allItems.Count) items in total." -ForegroundColor Gray
    Write-Host "Starting to process items..." -ForegroundColor Yellow
    $counter = 0

    foreach ($item in $allItems) {
        try {
            if ($null -eq $item[$taxonomyFieldName] -or $item[$taxonomyFieldName] -eq "") {
                Write-Host "Processing item ID: $($item.Id)..." -ForegroundColor Yellow
                
                Set-PnPListItem -List $listName -Identity $item.Id -Values @{
                    $taxonomyFieldName = $termValue
                }
                
                $counter++
                Write-Host "Item ID: $($item.Id) successfully updated." -ForegroundColor Green
                Start-Sleep -Seconds 1  # Throttling prevention delay
            }
            else {
                Write-Host "Skipping item ID: $($item.Id) - Already has a value." -ForegroundColor Gray
            }
        }
        catch {
            Write-Host "Error updating item ID: $($item.Id): $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "Error details: $($_)" -ForegroundColor Red
        }
    }

    Write-Host "`nOperation completed successfully!" -ForegroundColor Green
    Write-Host "Total items updated: $counter" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Error details: $($_)" -ForegroundColor Red
}
finally {
    # Close the connection
    Disconnect-PnPOnline
    Write-Host "SharePoint connection closed." -ForegroundColor Gray
}