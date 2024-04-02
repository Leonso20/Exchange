
Connect-IPPSSession -UserPrincipalName <Username>

#To hard-delete the items returned by the "Remove Phishing Message" content search, you would run this command:
New-ComplianceSearchAction -SearchName "fusususers" -Purge -PurgeType HardDelete



#the command soft-deletes the search results returned by a Content search named "Remove Phishing Message".
New-ComplianceSearchAction -SearchName "Remove Phishing Message" -Purge -PurgeType SoftDelete