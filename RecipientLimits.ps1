Get-Mailbox -Identity andres.burgos@ocsofl.com | Select-Object MaxRecipientEnvelopeLimit
Get-Mailbox -Identity andres.burgos@ocsofl.com | fl

Get-Mailbox -Identity Shashi.Persaud@ocsofl.com | Select-Object  RecipientLimits



Get-Mailbox -Identity andres.burgos@ocsofl.com | Select-Object MaxRecipientEnvelopeLimit

get-TransportConfig -MaxRecipientEnvelopeLimit


#o find the default recipient limits values for the different mailbox plans, use the following command:

Set-MailboxPlan ExchangeOnline -RecipientLimits 50

Get-MailboxPlan | ft DisplayName, RecipientLimits


#if you want to change the recipient limit for a single mailbox
Set-Mailbox user@domain.com -RecipientLimits 999


#If you want to perform the change against a group of users
Get-User -RecipientTypeDetails UserMailbox -Filter {Department -eq "Marketing"} | Set-Mailbox -RecipientLimits 100

#if you want to change it for all user mailboxes in the organization:
Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited | Set-Mailbox -RecipientLimits 10

