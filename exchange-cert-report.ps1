<#
.SYNOPSIS
ExchangeCertificateReport.ps1 - Exchange Server SSL Certificate Report Script

.DESCRIPTION
Generates a report of the SSL certificates installed on Exchange Server.

.OUTPUTS
Outputs to an HTML file.

.EXAMPLE
.\ExchangeCertificateReport.ps1
Reports SSL certificates for Exchange Server and outputs to an HTML file.

.NOTES
Written by: OpenAI ChatGPT
#>

$myDir = $PSScriptRoot
$reportFile = "C:\Users\n4mation\Desktop\ExchangeCertificateReport.html"



$htmlReport = @()

$exchangeServers = @(Get-ExchangeServer)

foreach ($server in $exchangeServers) {
    $htmlSegment = @()
    
    $serverDetails = "Server: $($server.Name) ($($server.ExchangeVersion.ToString()))"
    Write-Host $serverDetails
    
    $certificates = @(Get-ExchangeCertificate -Server $server.Name)

    $certTable = @()

    foreach ($cert in $certificates) {
        $services = $cert.Services
        $thumbprint = $cert.Thumbprint
        $subject = $cert.Subject
        $issuer = $cert.Issuer
        $expiryDate = $cert.NotAfter.ToShortDateString()
        $isSelfSigned = $cert.IsSelfSigned -as [string]
        $status = $cert.Status

        $certObj = New-Object -TypeName PSObject
        $certObj | Add-Member -MemberType NoteProperty -Name "Thumbprint" -Value $thumbprint
        $certObj | Add-Member -MemberType NoteProperty -Name "Subject" -Value $subject
        $certObj | Add-Member -MemberType NoteProperty -Name "Issuer" -Value $issuer
        $certObj | Add-Member -MemberType NoteProperty -Name "Expires" -Value $expiryDate
        $certObj | Add-Member -MemberType NoteProperty -Name "Self Signed" -Value $isSelfSigned
        $certObj | Add-Member -MemberType NoteProperty -Name "Status" -Value $status
        $certObj | Add-Member -MemberType NoteProperty -Name "Services" -Value $services

        $certTable += $certObj
    }

    $htmlSegment += "<h2>$serverDetails</h2>"
    $htmlSegment += $certTable | ConvertTo-Html -Property "Thumbprint", "Subject", "Issuer", "Expires", "Self Signed", "Status", "Services" -Fragment

    $htmlReport += $htmlSegment
}

$htmlReportContent = $htmlReport | Out-String

# HTML report template
$htmlTemplate = @"
<!DOCTYPE html>
<html>
<head>
<style>
body {
    font-family: Arial, sans-serif;
    font-size: 12pt;
}
h1 {
    font-size: 16pt;
    font-weight: bold;
    margin-bottom: 10px;
}
h2 {
    font-size: 14pt;
    font-weight: bold;
    margin-bottom: 5px;
}
table {
    border-collapse: collapse;
    width: 100%;
}
th, td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}
</style>
</head>
<body>
<h1>Exchange Server SSL Certificate Report</h1>
$htmlReportContent
</body>
</html>
"@

$htmlTemplate | Out-File -FilePath $reportFile -Encoding UTF8

Write-Host "SSL certificate report generated successfully. Report file: $reportFile"
