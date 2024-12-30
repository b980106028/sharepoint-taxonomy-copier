# SharePoint Taxonomy Copier

A PowerShell script to copy taxonomy field values from one item to multiple items in a SharePoint list.

[Türkçe README için tıklayın / Click for Turkish README](README_TR.md)

## Installation

1. Clone this repository:
```powershell
git clone [repo-url]
```

2. Copy `.env.example` to `.env` and configure your environment variables:
```powershell
Copy-Item .env.example .env
```

3. Install PnP.PowerShell module (the script will install it automatically, but if you want to install manually):
```powershell
Install-Module -Name PnP.PowerShell -Force
```

## Usage

1. Configure the variables in `.env` file for your environment:
   - SITE_URL: Your SharePoint site URL
   - LIST_NAME: Your list name
   - SOURCE_ITEM_ID: ID of the item you want to copy taxonomy value from
   - TAXONOMY_FIELD_NAME: Name of the taxonomy field
   - TERM_GUID: Term GUID

2. Run the script:
```powershell
.\CopyListItemTaxonomyColumn.ps1
```

## Features

- Uses web login for SharePoint Online connection
- Fills empty taxonomy fields in the specified list
- Includes 1-second delay between updates to prevent throttling
- Includes error handling and logging
- Environment variables for sensitive data

## Security

- Sensitive information is stored in `.env` file
- `.env` file is excluded from version control via `.gitignore`
- Example variables are shown in `.env.example` file

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
