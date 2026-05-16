# Detect OS
$OnLinux = $PSVersionTable.Platform -eq "Unix"
$OnWindows = $PSVersionTable.OS -like "*Windows*" -or ($PSVersionTable.Platform -eq $null)

Write-Host "Detected platform: $(if ($OnLinux) { 'Linux' } else { 'Windows' })" -ForegroundColor Yellow

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

    # if .status says "online", stop here and keep the window open
    if (Test-Path $ReadmePath) {
        $currentStatus = (Get-Content -Path $ReadmePath -Raw).Trim().ToLower()
        if ($currentStatus -eq "online") {
            Write-Host "Server already online on other host." -ForegroundColor Red
            Read-Host "Press ENTER to exit"
            exit
        }
    }
} catch {
    Write-Host "Error. GitHub not synced." -ForegroundColor Red
}

# update github status
function Update-GitHubStatus($status) {
    $Fecha = Get-Date -Format "dd/MM/yyyy HH:mm"
    
    if ($status -eq "Online") {
        $msg = "online"
        $gitTarget = ".status" 
    } else {
        $status = "Offline" 
        $msg = "offline"
        $gitTarget = "."
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
    
    if ($OnLinux) {
        Write-Host "Starting server on Linux..." -ForegroundColor Cyan
        Set-Location -Path "$RepoRoot/server"
        
        # Find the server jar file
        $jarFile = Get-ChildItem -Path . -Filter "*.jar" | Select-Object -First 1
        if (-not $jarFile) {
            Write-Host "ERROR: No .jar file found in $RepoRoot/server" -ForegroundColor Red
            exit
        }
        
        Write-Host "Running: java -Xmx2G -Xms2G -jar $($jarFile.Name)" -ForegroundColor Cyan
        $process = Start-Process -FilePath "java" -ArgumentList "-Xmx2G", "-Xms2G", "-jar", $jarFile.Name -Wait -PassThru -NoNewWindow
    }
    elseif ($OnWindows) {
        # Windows
        # run playit
        Start-Process -FilePath "$RepoRoot/misc/playit.exe"

        Write-Host "Server online. Close typing 'stop'." -ForegroundColor Cyan
        Set-Location -Path "$RepoRoot/server"
        $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c start.bat" -Wait -PassThru
    }
}
finally {
    # close playit.exe (Windows only)
    if ($OnWindows) {
        Stop-Process -Name "playit" -ErrorAction SilentlyContinue
    }

    # backup to github
    Write-Host "Backing up to GitHub..." -ForegroundColor Magenta
    Update-GitHubStatus "Offline"
    Write-Host "Backup completed." -ForegroundColor Green
    Start-Sleep -Seconds 2
}
