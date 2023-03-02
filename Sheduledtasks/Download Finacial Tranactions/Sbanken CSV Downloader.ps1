# -- SETUP --
$clientId = '2185dec4f01740ac99979819216d59ed'
$secret = 'mF4dU+MnjcxOEB7jSgzNgtCWAPRNjko5FeVtWWORM5Qc3Ll=8INmpiXayAAzS56b'
# -- END SETUP --

$accountsToImport = @(
    "Brukskonto",
    "Mat og morro"
)

# Optionally: 
Import-Module $PSScriptRoot\Functions.psm1 -Force
Add-Type -AssemblyName System.Web

$authHeaders = Get-SbankenAuthHeader -clientId $clientId -clientSecret $secret
$accounts = (get-SbankenAccounts -authHeaders $authHeaders).items | where { $_.name -in $accountsToImport } | select *

$accounts[0]


<#
$AllAccountsbalance = foreach ($item in $response.items) {
    $accountUri = "https://publicapi.sbanken.no/apibeta/api/v1/Accounts/" + $item.accountId
    $Balance = Invoke-RestMethod -Uri $accountUri -Method GET -Headers $authHeaders
    $balance
}   



echo "Get spesific account based on AccountId"
$authHeaders = @{}
$authHeaders.Add("Accept", "application/json")
$authHeaders.Add("Authorization", "Bearer " + $authResponse.access_token)
$accountUri = "https://publicapi.sbanken.no/apibeta/api/v1/Accounts/" + $response.items[0].accountId
$response = Invoke-RestMethod -Uri $accountUri -Method GET -Headers $authHeaders
$response

#>