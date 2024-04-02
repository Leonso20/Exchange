
Connect-ExchangeOnline -UserPrincipalName <Username>
connect-msolservice -credential $Office365Creds
# Managing Protocals 

#Connect Exchange online
Connect-ExchangeOnline -Credential $Credential -ShowBanner:$False

#Disconnect Exchange Online
Disconnect-ExchangeOnline -Confirm:$False

Connect-PSSession
Get-pssession
Remove-PSSession -Id 1, 2


#get current protocal settings
Get-casmailbox -Identity aburgos

#regionSet a mailbox's settings
$casmailbox = @{
'identity' = 'aburgos'
'ActiveSyncenabled' = $false
'PopEnabled' = $false
'Imapenabled' = $false
}
Set-CASMailbox @Casmailbox

#Verify
Get-CASMailbox @casmailbox identity 

#endregion

#get all mailboxes with IMAP and POP enbaled
Get-EXOCASMailbox -Filter {IMAPEnabled -eq $True -or POPEnabled -eq $True} | select name,PrimarySmtpAddress

#Set all mailboxes with IMAP and POP desabled
Set-CasMailbox -Identity  EFutato@seminolecountyfl.gov -PopEnabled  $false -ImapEnabled  $false

#Set individually IMAP and POP desabled
Get-mailbox | Set-CASMailbox -PopEnabled $false -ImapEnabled $false

#Look for resoults 
Get-casmailbox | Group-object PopEnabled
Get-casmailbox | Group-object ImapEnabled 

#Disable OWA for all resources mailboxes
Get-mailbox -ResultSize Unlimited  | where-object ISresource |set-casmailbox -owaenabled $false

#Verify
Get-Mailbox -ResultSize Unlimited | Where-Object IsResources | Get-CasMailbox | Group-Object OWAEnabled
Get-Mailbox -ResultSize Unlimited | Where-Object IsResources | Get-CasMailbox | Group-Object OWADesabled


#Managing permissions 
Get-pssession
Remove-PSSession -Id 4, 2


# get-current permissions
Get-MailboxPermission -Identity "aburgos"

#Get current permissions without inherited 
Get-MailboxPermission -Identity "aburgos" | where-object isinherited -eq $false


#endregion

#region Add full access 
#add full access 
$Mailboxpermission = @{
    'identity' = "aburgos02"  #user thta will recieve the permissions 
    'User' = 'ITTest3'        #User thta wila low permission 
    'AccessRights' = 'Fullaccess','DeleteItem'
    'AutoMapping' = $true
}
Add-MailboxPermission @MailboxPermission

Get-mailboxpermission -Identity "ro011335" | Where-Object isinherited -eq $false

#Possible permissions: FullAccess, SendAs, ExternalAccount, DeleteItem, ReadPermission, ChangePermission, ChangeOwner

#endregion

#region remove 

#Remove Full Access
Remove-MailboxPermission -Identity "aburgos02" -user ITTest3 -AccessRights FullAccess -Confirm: $false
Get-MailboxPermission -Identity "aburgos02" | Where-Object isinherited -eq $false

#endregion

#region settng up quotas
Get-Pssession

#region mail
$MAilbox = 'ITtest3'

#Get Current quotas
Get-Mailbox -Identity $MAilbox | Format-List Issue*Quota,Prohubit*Quota,UseDatabaseQuotadefautls

#endregion


#region Configuring-Send-As-permissions
#Get the mailbox 
Get-mailbox -Identity security.test  | fl PrimarySmtpAddress, RemoteRecipientType, RetentionPolicy,RecipientType,mailboxplan

#Get the current send-as permission for a user
Get-mailbox -Identity aburgos | Select-Object -Property grantsendOnBehalfto

#Grant send-as for the mailbox
Set-mailbox -Identity aburgos -GrantSendOnBehalfTo 'aburgos02'

#remove GrantSendOnBehalfTo
Set-Mailbox "aburgos" -GrantSendOnBehalfTo @{remove="aburgos02"}
Remove-MailboxPermission -Identity aburgos -User aburgos02 -AccessRights FullAccess -InheritanceType All

#verify the send-as permissions 
Get-mailbox -Identity aburgos | Select-Object -Property grantsendOnBehalfTo 

Get-mailbox -Identity security.test | Select-Object -Property  

#If you want multiple users
Get-mailbox -Identity aburgos | Select-Object -Property grantsendOnBehalfTo 'user1','user2' 

#endregion
 


 #region distribution groups
 Get-DistributionGroup 
 
 Get-distributiongroup -Identity  'A2-ESUE_WaterOps' |Select-Object -Property GrantSendOnBehalfTo

(Get-DistributionGroup -Identity  A2-ESUE_WaterOps).GrantSendOnBehalfTo |Select-Object -Property name


(Get-Mailbox -Identity security.test).DisplayName, (Get-Mailbox -Identity security.test).PrimarySmtpAddress, (Get-Mailbox -Identity security.test).RecipientTypeDetails


