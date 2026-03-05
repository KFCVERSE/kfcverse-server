# Install Java 21
$javaUrl = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.msi"
$javaInstaller = "$env:TEMP\jdk-21_windows-x64_bin.msi"
if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
    Invoke-WebRequest -Uri $javaUrl -OutFile $javaInstaller
    Start-Process msiexec.exe -ArgumentList "/i `"$javaInstaller`" /qn" -Wait
} else {
    Write-Host "Java already installed."
}

# Install Git
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not detected. Downloading and installing Git for Windows..."
    $gitUrl = "https://github.com/git-for-windows/git/releases/latest/download/Git-64-bit.exe"
    $gitInstaller = "$env:TEMP\git-installer.exe"
    Invoke-WebRequest -Uri $gitUrl -OutFile $gitInstaller
    Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT","/NORESTART" -Wait
} else {
    Write-Host "Git already installed."
}

# Ask user where to clone the server
$cloneDir = Read-Host "Enter folder to clone the server into"
if (-not [string]::IsNullOrEmpty($cloneDir)) {
    if (-not (Test-Path $cloneDir)) {
        New-Item -ItemType Directory -Path $cloneDir | Out-Null
    }
} else {
    Write-Host "No directory provided."
    exit 1
}

# attempt GitHub login via credential manager (opens browser popup)
if (Get-Command "git" -ErrorAction SilentlyContinue) {
    Write-Host "Initializing GitHub authentication (this may open a browser window)..."
    # use the credential manager to perform an OAuth login for github
    # if the user already has credentials stored this will be quick
    git credential-manager-core login --scopes repo
}

# Configure Git user identity only if not already set
if (-not (git config --global --get user.name)) {
    $ghName = Read-Host "Enter your GitHub user name (for git config)"
    if ($ghName) { git config --global user.name $ghName }
}
if (-not (git config --global --get user.email)) {
    $ghEmail = Read-Host "Enter your GitHub email address (for git config)"
    if ($ghEmail) { git config --global user.email $ghEmail }
}
Write-Host "If you need to authenticate with GitHub, run 'git credential-manager-core configure' or use SSH keys."

# Clone repository
Write-Host "Cloning repository into $cloneDir..."
Set-Location $cloneDir
git clone https://github.com/mespp/kfcverse-server

Write-Host "Done!"
