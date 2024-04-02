# Connect to Microsoft 365
Connect-MicrosoftTeams
Connect-MsolService

# Get all users with assigned licenses
$assignedLicenses = Get-MsolUser -All | Where-Object { $_.IsLicensed -eq $true }

# Get all available licenses
$allLicenses = Get-MsolAccountSku

# Create an array to store license information
$licenseInfo = @()

# Collect assigned licenses information
foreach ($user in $assignedLicenses) {
    $license = $allLicenses | Where-Object { $_.AccountSkuId -eq $user.Licenses.AccountSkuId }
    $licenseInfo += [PSCustomObject]@{
        UserPrincipalName = $user.UserPrincipalName
        AssignedLicense = $license.SkuPartNumber
        Status = 'Assigned'
    }
}

# Collect available licenses information
foreach ($license in $allLicenses) {
    $assignedUserCount = ($assignedLicenses | Where-Object { $_.Licenses.AccountSkuId -eq $license.AccountSkuId }).Count
    $availableCount = $license.TotalLicenses - $assignedUserCount
    $licenseInfo += [PSCustomObject]@{
        UserPrincipalName = ''
        AssignedLicense = $license.SkuPartNumber
        Status = "Available ($availableCount)"
    }
}

# Export to CSV
$licenseInfo | Export-Csv -Path "C:\Temp\ExportedFile.csv" -NoTypeInformation
