
Install-Module -Name AzureAD

#=====================================================================


Enter-PSSession -ComputerName Com-ADConn.orange-county-sheriff.net



Start-ADSyncSyncCycle -PolicyType Delta


#-====================================================================

# Login to Azure AD PowerShell With Admin Account
Connect-AzureAD 

Disconnect-AzureAD


get-help AzureAD 


Get-ADSyncADConnectorAccount


