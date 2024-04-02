#Connect to exchange on prem
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://RCCEX01.orange-county-sheriff.net/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session -DisableNameChecking


get-transportconfig | ft maxsendsize, maxreceivesize 
get-receiveconnector | ft name, maxmessagesize 
get-sendconnector | ft name, maxmessagesize 
