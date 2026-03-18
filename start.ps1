# hide the window
$windowStyle = '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);'
$type = Add-Type -MemberDefinition $windowStyle -Name "Win32ShowWindow" -Namespace "Win32" -PassThru
$handle = (Get-Process -Id $PID).MainWindowHandle
if ($handle -ne [IntPtr]::Zero) {
    $type::ShowWindow($handle, 0)
}

# get into the folder
Set-Location -Path $PSScriptRoot
$RepoRoot = $PSScriptRoot
while ($RepoRoot -and -not (Test-Path (Join-Path $RepoRoot ".git"))) {
    $RepoRoot = Split-Path $RepoRoot -Parent
}
if (-not $RepoRoot) {
    Write-Host "ERROR: folder not found." -ForegroundColor Red
    exit
}
$ReadmePath = Join-Path -Path $RepoRoot -ChildPath ".status"

# sync github
Write-Host "Syncing server" -ForegroundColor Yellow
try {
    Push-Location $RepoRoot
    git pull origin main --rebase 
    Pop-Location
} catch {
    Write-Host "Error. GitHub not synced." -ForegroundColor Red
}

# update github status
function Update-GitHubStatus($status) {
    $Fecha = Get-Date -Format "dd/MM/yyyy HH:mm"
    
    if ($status -eq "Online") {
        $msg = "Online"
        $gitTarget = ".status" 
    } else {
        $status = "Offline" 
        $msg = "Offline"
        $gitTarget = ".status"
    }
    
    Set-Content -Path $ReadmePath -Value $msg -Encoding utf8
    
    try {
        Push-Location $RepoRoot
        git add $gitTarget
        git commit -m "Status: Server $status ($Fecha)" --allow-empty
        git push origin main
        Pop-Location
        Write-Host "GitHub updated ($status)" -ForegroundColor Green
    } catch {
        Write-Host "Error $status" -ForegroundColor Yellow
    }
}

# la chicha
try {
    Update-GitHubStatus "Online"
    # run playit
    Start-Process -FilePath "$RepoRoot/misc/playit.exe"

    Write-Host "Server online. Close typing 'stop' or just closing the window." -ForegroundColor Cyan
    Set-Location -Path "$RepoRoot/server"
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c start.bat" -Wait -PassThru
}
finally {
    # close playit.exe
    Stop-Process -Name "playit" -ErrorAction SilentlyContinue

    # backup to github
    Write-Host "Backing up to GitHub..." -ForegroundColor Magenta
    Update-GitHubStatus "Offline"
    Write-Host "Backup completed." -ForegroundColor Green
    Start-Sleep -Seconds 2
}
