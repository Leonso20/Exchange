# Connect to Exchange Online (if not already connected)
Connect-ExchangeOnline -UserPrincipalName <username> 

# Get mailboxes and retrieve the homemdb attribute
$mailboxes = Get-Mailbox -ResultSize Unlimited
$mailboxReport = $mailboxes | Select-Object mail,UserPrincipalName, @{Name="HomeMDB";Expression={$_.Database}}

# Export to CSV
$mailboxReport | Export-Csv -Path "C:\Temp\File.csv" -NoTypeInformation

# Disconnect from Exchange Online (if connected) - Optional
Disconnect-ExchangeOnline -Confirm:$false
