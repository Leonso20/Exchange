#Connect to Exchange Online using Modern Authentication:
$UserCredential = Get-Credential
Connect-ExchangeOnline -Credential $UserCredential
