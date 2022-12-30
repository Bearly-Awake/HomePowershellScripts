$excluesionFiles = @(
    "buildscript.ps1",
    "NewModule.ps1"
)
$src = "C:\Users\Karol\Repos\HomePowershellScripts\*"
$dst = "C:\Users\Karol\Documents\WindowsPowerShell"

Copy-Item -Path $src -Destination $dst -Exclude $excluesionFiles -Force -Recurse