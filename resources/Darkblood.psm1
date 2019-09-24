#requires -Version 2 -Modules posh-git

function Write-Theme {
  param(
    [bool]
    $lastCommandFailed,
    [string]
    $with
  )

  $prompt = Write-Prompt -Object ([char]::ConvertFromUtf32(0x250C)) -ForegroundColor $sl.Colors.PromptSymbolColor


  $status = Get-VCSStatus
  if ($status) {
    $vcsInfo = Get-VcsInfo -status ($status)
    $info = $vcsInfo.VcInfo
    $prompt += Write-Segment -content $info -foregroundColor $sl.Colors.GitForegroundColor
  }

  $path += Get-FullPath -dir $pwd
  $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentBackwardSymbol -ForegroundColor $sl.Colors.PromptSymbolColor
  $prompt += Write-Prompt -Object $path -ForegroundColor ([ConsoleColor]::Magenta)
  $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentForwardSymbol -ForegroundColor $sl.Colors.PromptSymbolColor

  $prompt += ''

  # SECOND LINE
  $prompt += Set-Newline
  $prompt += Write-Prompt -Object ([char]::ConvertFromUtf32(0x2514)) -ForegroundColor $sl.Colors.PromptSymbolColor
  $user = [System.Environment]::UserName
  $prompt += Write-Segment -content $user -ForegroundColor ([ConsoleColor]::DarkCyan)

  #check for elevated prompt
  If (Test-Administrator) {
    $prompt += Write-Segment -content $sl.PromptSymbols.ElevatedSymbol -foregroundColor $sl.Colors.AdminIconForegroundColor
  }

  #check the last command state and indicate if failed
  If ($lastCommandFailed) {
    $prompt += Write-Segment -content $sl.PromptSymbols.FailedCommandSymbol -foregroundColor $sl.Colors.CommandFailedIconForegroundColor
  }


  if (Test-VirtualEnv) {
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) $($sl.PromptSymbols.SegmentBackwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName)" -ForegroundColor $sl.Colors.VirtualEnvForegroundColor
  }

  if ($with) {
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol) $($sl.PromptSymbols.SegmentBackwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
    $prompt += Write-Prompt -Object "$($with.ToUpper())" -ForegroundColor $sl.Colors.WithForegroundColor
  }

  $prompt += Write-Prompt -Object "$($sl.PromptSymbols.PromptIndicator)" -ForegroundColor ([ConsoleColor]::Blue)
  $prompt += ' '
  $prompt
}

function Write-Segment {

  param(
    $content,
    $foregroundColor
  )

  $prompt += Write-Prompt -Object $sl.PromptSymbols.SegmentBackwardSymbol -ForegroundColor $sl.Colors.PromptSymbolColor
  $prompt += Write-Prompt -Object $content -ForegroundColor $foregroundColor
  $prompt += Write-Prompt -Object "$($sl.PromptSymbols.SegmentForwardSymbol)" -ForegroundColor $sl.Colors.PromptSymbolColor
  return $prompt
}

$sl = $global:ThemeSettings #local settings
$sl.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0x1F335)
$sl.GitSymbols.BranchUntrackedSymbol = [char]::ConvertFromUtf32(0x1F341)
$sl.GitSymbols.BranchIdenticalStatusToSymbol = [char]::ConvertFromUtf32(0x1F340)
$sl.GitSymbols.BranchAheadStatusSymbol = [char]::ConvertFromUtf32(0x2B06)
$sl.GitSymbols.BranchBehindStatusSymbol = [char]::ConvertFromUtf32(0x2B07)
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(0x1F6A9)
$sl.PromptSymbols.SegmentForwardSymbol = ']'
$sl.PromptSymbols.SegmentBackwardSymbol = '['
$sl.PromptSymbols.PathSeparator = '\'
$sl.PromptSymbols.FailedCommandSymbol = [char]::ConvertFromUtf32(0x1F51E)
$sl.PromptSymbols.ElevatedSymbol = [char]::ConvertFromUtf32(0x1F984)
$sl.Colors.CommandFailedIconForegroundColor = [ConsoleColor]::Magenta
$sl.Colors.PromptForegroundColor = [ConsoleColor]::White
$sl.Colors.PromptSymbolColor = [ConsoleColor]::DarkYellow
$sl.Colors.PromptHighlightColor = [ConsoleColor]::DarkBlue
$sl.Colors.GitForegroundColor = [ConsoleColor]::DarkGreen
$sl.Colors.WithForegroundColor = [ConsoleColor]::DarkYellow
$sl.Colors.WithBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvBackgroundColor = [ConsoleColor]::Magenta
$sl.Colors.VirtualEnvForegroundColor = [ConsoleColor]::White
