function Rename-WithPattern {
    param (
        $path,
        [String]$FileExtention,
        [switch]$LiteralPath
    )

    # Args depending on Path provided
    if ($LiteralPath) {
        $arguments = @{
            LiteralPath = "$path"
        }
    }    
    if (!$LiteralPath) {
        $arguments = @{
            path = "$path\*"
        }
    }
    $fileFilter = { $_.Name -match "$FileExtention$" }
    $regexPattern = "(?<=S\d\dE\d\d).*(?=$FileExtention)" # Everything after E00S00 and before .ext
    # $regexPattern = .*(?=S\d\dE\d\d) # Everything before E00S00
    # Confirm changes
    $changes = Get-ChildItem @arguments |
    Where-Object $fileFilter | 
    ForEach-Object {
        [PSCustomObject]@{
            OldName = $_.Name
            NewName = $($_.Name -replace "(?<=S\d\dE\d\d).*(?=$FileExtention)")
        }
    }
    $changes | Format-Table
    Write-Warning "This is only a test warning." -WarningAction Inquire
    Get-ChildItem @arguments |
    Where-Object $fileFilter | 
    ForEach-Object {
        if ($LiteralPath) {
            rename-item -LiteralPath $_.FullName -NewName $($_.Name -replace $regexPattern)
        }
        else {
            rename-item $_.FullName -NewName $($_.Name -replace $regexPattern)
        }
    }
}
Export-ModuleMember -Function "Rename-WithPattern"