. "$PSScriptRoot\Costclass.ps1"   

function Add-Cost {
    param (
        [string]$ownerName,
        [string]$item,
        [int]$cost,
        [switch]$reset
    )
    if ($reset -or !$Global:CostSheet) {
        $Global:CostSheet = @()
    }
    $CostItem = [CostItem]::new()
    $CostItem.ownerName = $ownerName
    $CostItem.item = $item
    $CostItem.cost = $cost
    $Global:CostSheet += $CostItem
    #$Global:CostSheet
}

function Get-Accouting {
    # Array of peple in accouting
    [Array]$names = $Global:CostSheet | Select-Object  -Unique -ExpandProperty ownerName
    if ($names.count -lt 2 ) { 
        Write-Error "Command needs 2 or more people to run, plese add more entries with 'Add-Cost' command" 
        exit 1  
    }
    #high Level sums of relevant numbers
    $HighLevel = @{ 
        Sum       = ($Global:CostSheet | Measure-Object -Property cost -Sum).sum
        HalfOfSum = (($Global:CostSheet | Measure-Object -Property cost -Sum).sum / $names.Count )
    }
    # Sum up for individuals
    Foreach ($name in $names) {
        $NameSum = ($Global:CostSheet | Where-Object ownerName -eq $name | Measure-Object -Property cost -Sum).sum
        If (!$sums) { $sums = @() }
        $sums += [PSCustomObject]@{
            name                 = $name
            Spendt               = $NameSum
            "HalfOfTotal-Spendt" = $($NameSum - $HighLevel.HalfOfSum)
        }
        
    }
    # Fluffy text
    $dedters = ($sums | Where-Object { $_."HalfOfTotal-Spendt" -LT 0 }).name
    $loaners = ($sums | Where-Object { $_."HalfOfTotal-Spendt" -gt 0 }).name
    IF ($dedters) {
        WRITE-HOST "THE FOLLOWING DEDTHERS: $($dedters -join ", ")" -ForegroundColor Red -BackgroundColor Black
        WRITE-HOST "Owe money to the folowing lonaers: $($loaners -join ", ")"-ForegroundColor Green -BackgroundColor Black
    }
    else {
        WRITE-HOST "Wierd shit is happening, no dedters found..." -BackgroundColor Black -ForegroundColor Yellow
    }
    $sums  
}

Export-ModuleMember -Function *