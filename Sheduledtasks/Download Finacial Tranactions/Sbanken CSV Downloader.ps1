# -- SETUP --
$clientId = get-Secret -Name "Sbanken:clientid" -Vault credMan -AsPlainText
$secret = get-Secret -Name "Sbanken:secret" -Vault credMan -AsPlainText

If(!$clientId -or !$secret ){
    Write-Error "clientId or is missing" 
    exit 1
}


# -- END SETUP --
$csvPath = "$home\downloads\"

# -- Config --

#Number of months, from now, negative number
$monthsHistory = -10..1
$dateformat = "yyyy-MM-dd"

$accountsToImport = @(
    # @blocksort acs
    "Brukskonto",
    "Mat og morro"
)

# Optionally: 
Import-Module $PSScriptRoot\Functions.psm1 -Force
Add-Type -AssemblyName System.Web

$authHeaders = Get-SbankenAuthHeader -clientId $clientId -clientSecret $secret
$accounts = (get-SbankenAccounts -authHeaders $authHeaders).items | where { $_.name -in $accountsToImport } | select *


foreach ($account in $accounts){
    Foreach ($month in $monthsHistory) {
        # Calculate dates
        $date = (Get-Date).AddMonths($month)
        $dates = @{
            startDate = $date.AddMonths(-1)
            endDate   = $date
        }
        $Transactions = Get-SbankenTransactions $account.accountId -authHeaders $authHeaders @dates
        $Transactions.items | Select-Object @(
            @{
                name       = "accountingDate"
                expression = { get-date $_.accountingDate -Format $dateformat }
            },
            @{
                name       = "amount"
                expression = { $_.amount }
            },
            @{
                name       = "transactionType"
                expression = { $_.transactionType }
            },
            @{
                name       = "text"
                expression = { $_.text }
            }
        ) | Export-Csv -path $(join-path $csvPath "$($account.name)_$(get-date -Format $($dateformat+"_HH-mm" )).csv") -Append  -NoTypeInformation
    }
}


