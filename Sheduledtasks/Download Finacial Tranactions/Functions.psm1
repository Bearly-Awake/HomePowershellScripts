
function Get-SbankenAuthHeader {
    param (
        [string]$clientId,
        [string]$clientSecret
    )
    Add-Type -AssemblyName System.Web
    $headers = @{}
    $encodedClientId = [System.Web.HttpUtility]::UrlEncode($clientId) 
    $encodedSecret = [System.Web.HttpUtility]::UrlEncode($clientSecret) 

    $credentials = "$($encodedClientId):$($encodedSecret)"

    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($credentials)
    $EncodedText = [Convert]::ToBase64String($Bytes)

    $headers.Add("Authorization", "Basic " + $EncodedText)
    $headers.Add("Content-Type", "application/x-www-form-urlencoded; charset=utf-8")
    $headers.Add("Accept", "application/json")
    $postParams = @{grant_type = 'client_credentials' }
    $authResponse = Invoke-RestMethod -Uri "https://auth.sbanken.no/IdentityServer/connect/token" -Method POST -Headers $headers -Body $postParams
    $authHeaders = @{}
    $authHeaders.Add("Accept", "application/json")
    $authHeaders.Add("Authorization", "Bearer " + $authResponse.access_token)
    $authHeaders
}


function Get-SbankenAccounts {
    param (
        $authHeaders
    )
    $accountUri = "https://publicapi.sbanken.no/apibeta/api/v1/Accounts"
    $response = Invoke-RestMethod -Uri $accountUri -Method GET -Headers $authHeaders
    $response
}

function Get-SbankenTransactions {
    param(
        [Parameter(
            Position = 0,    
            Mandatory = $true
        )]
        [string]$accountID,
        [Parameter(
            Position = 1,    
            Mandatory = $true
        )]
        [hashtable]$authHeaders,
        [datetime]$startDate,
        [datetime]$endDate,
        [int]$index,
        [ValidateRange(0, 1000)]
        [int]$length
    )
    #add relevnat filters
    $dateformat = "yyyy-MM-dd"
    $filters = @()
    if ($startdate) {
        $filters += "startDate=$(get-date $startDate -Format $dateformat)"
    }
    if ($endDate) {
        $filters += "endDate=$(get-date $startDate -Format $endDate)"
    }
    if ($index) {
        $filters += "index=$($index)"
    }    
    if ($length) {
        $filters += "length=$($length)"
    }
    #Put together URL
    if ($filters) {
        $accountUri = "https://publicapi.sbanken.no/apibeta/api/v2/Transactions/" + $accountID + "?" + ($filters -join "&")
    }
    else {
        $accountUri = "https://publicapi.sbanken.no/apibeta/api/v2/Transactions/" + $accountID
    }
    $response = Invoke-RestMethod -Uri $accountUri -Method GET -Headers $authHeaders
    $response
}

Export-ModuleMember -Function *