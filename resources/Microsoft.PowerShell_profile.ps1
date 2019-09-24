[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

[System.Environment]::SetEnvironmentVariable("GIT_SSH", "C:\Program Files\OpenSSH\ssh.exe")
[System.Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null)
[System.Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null)

Import-Module Get-ChildItemColor
Import-Module posh-git
Import-Module oh-my-posh
Import-Module PsReadLine
Import-Module windows-screenfetch
Set-Theme Darkblood


# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
Set-Alias curl curl.exe -Option AllScope
Set-Alias which where.exe -Option AllScope
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Chord Shift+Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Chord Ctrl+Shift+K -Function DeleteLine
Set-PSReadlineOption -BellStyle None
Screenfetch

# Helper function to change directory to my development workspace
# Change d:\Workspace\Code\~SourceCode to your usual workspace and everytime you type
# in cws from PowerShell it will take you directly there.
function cws { Set-Location d:\Workspace\Code\SourceCode }

# Helper function to set location to the User Profile directory
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

#Autocomplete when use single quote and double qoute

Set-PSReadLineKeyHandler -Chord "'", '"' `
  -BriefDescription SmartInsertQuote `
  -LongDescription "Insert paired quotes if not already on a quote" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($line[$cursor] -eq $key.KeyChar) {
    # Just move the cursor
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  }
  else {
    # Insert matching quotes, move cursor to be in between the quotes
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
  }
}

# Helper function to show Unicode character
function U {
  param
  (
    [int] $Code
  )

  if ((0 -le $Code) -and ($Code -le 0xFFFF)) {
    return [char] $Code
  }

  if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF)) {
    return [char]::ConvertFromUtf32($Code)
  }

  throw "Invalid character code $Code"
}


function GetAllHistory([string]$search = "") {
  if ($search -eq "") {
    Get-Content (Get-PSReadLineOption).HistorySavePath
  }
  else {
    Get-Content (Get-PSReadLineOption).HistorySavePath | Select-String $search | ForEach-Object { $_.Line }
  }
}

# Start SshAgent if not already
# Need this if you are using github as your remote git repository
if (! (Get-Process | Where-Object { $_.Name -eq 'ssh-agent' })) {
  ssh-agent -s
  if ((Get-Process | Where-Object { $_.Name -eq 'ssh-agent' })) {
    "ssh-agent started!"
  }
}

function GitLog {
  git log --graph --pretty=format:"%C(red)%h%Creset -%C(auto)%d%Creset %s %C(green)(%cr) %C(blue)[%an]%Creset" --abbrev-commit
}

function Set-Title([string] $title) {
  $Host.UI.RawUI.WindowTitle = $title
}
