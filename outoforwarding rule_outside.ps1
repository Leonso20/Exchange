<#This script defines a function Check-UserAutoForwarding that takes a user's email address as input and checks their inbox rules for auto-forwarding to external recipients.
 Replace "user@example.com" with the email address you want to check. The script will output any auto-forwarding rules found and the external recipients they forward emails to.#>

# Install and import the ExchangeOnlineManagement module if you haven't already
# Install-Module -Name ExchangeOnlineManagement
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Function to check if a user has auto-forwarding rules to external recipients
function Check-UserAutoForwarding {
    param (
        [string]$UserEmail
    )

    # Get all inbox rules for the user
    $InboxRules = Get-InboxRule -Mailbox $UserEmail

    # Check each rule for auto-forwarding to external recipients
    foreach ($Rule in $InboxRules) {
        if ($Rule.ForwardTo -and $Rule.ForwardTo -ne $null) {
            foreach ($ForwardAddress in $Rule.ForwardTo) {
                # Check if the forward address is outside the organization
                if ($ForwardAddress -match "@") {
                    Write-Output "Auto-forwarding rule found: $($Rule.Name)."
                    Write-Output "Forwarding to: $ForwardAddress"
                }
            }
        }
    }

    Write-Output "Auto-forwarding check completed for $UserEmail."
}

# Example usage: Check auto-forwarding for a specific user
$userEmailToCheck = "Orlando.Reyes@ocsofl.com"
Check-UserAutoForwarding -UserEmail $userEmailToCheck

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false
