<#
  LABEL Title:      Microsoft.PowerShell_profile.ps1
  LABEL Author:     Matthew-Stacks
  LABEL Category:   PROFILE
  LABEL Tags:       powershell, profile, windows
#>

<#
  Modules
  -------
  PSFzf
  ZLocation
#>
Import-Module ZLocation
Import-Module PSFzf

<#
  Settings
  ---------
  Encoding:         utf-8
  HistCache:        10_000
#>
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
$MaximumHistoryCount = 10000

<#
  ENVs
  ----
#>
$env:DOCUMENTS = [Environment]::GetFolderPath("mydocuments")
$env:STARSHIP_CONFIG = "$HOME\.starship\config.toml"
$env:STARSHIP_CACHE = "$HOME\AppData\Local\Temp"

<#
  Argument Completions
  --------------------
  aws
  chocolatey (choco)
  fzf
  op (1password)
  winget
#>

# aws
Register-ArgumentCompleter -Native -CommandName aws -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        $env:COMP_LINE=$wordToComplete
        if ($env:COMP_LINE.Length -lt $cursorPosition){
            $env:COMP_LINE=$env:COMP_LINE + " "
        }
        $env:COMP_POINT=$cursorPosition
        aws_completer.exe | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
        Remove-Item Env:\COMP_LINE     
        Remove-Item Env:\COMP_POINT  
}

# chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# fzf
Set-PsFzfOption -TabExpansion -EnableAliasFuzzyZLocation

# op (1password)
op completion powershell | Out-String | Invoke-Expression

# winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
        [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
        $Local:word = $wordToComplete.Replace('"', '""')
        $Local:ast = $commandAst.ToString().Replace('"', '""')
        winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# Starship: Blastoff! (Must Be Last)
Invoke-Expression (&starship init powershell)
