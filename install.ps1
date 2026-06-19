[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

function Show-CatHeader {
    Clear-Host
    Write-Host ""
    Write-Host "  ╱|、       meow." -ForegroundColor Magenta
    Write-Host "(˚ˎ 。7     /" -ForegroundColor Magenta
    Write-Host " |、˜〵          " -ForegroundColor Magenta
    Write-Host " じしˍ,)ノ" -ForegroundColor Magenta
    Write-Host ""
    Write-Host " Universal SCRCPY Manager" -ForegroundColor Cyan
    Write-Host ""
}

function Invoke-FastDownload {
    param([string]$Url, [string]$OutFile)
    
    try {
        $request = [System.Net.WebRequest]::Create($Url)
        $response = $request.GetResponse()
        $totalLength = $response.ContentLength
        $responseStream = $response.GetResponseStream()
        $targetStream = [System.IO.File]::Create($OutFile)
        $buffer = New-Object byte[] 65536
        $count = 0
        $downloaded = 0
        
        do {
            $count = $responseStream.Read($buffer, 0, $buffer.Length)
            if ($count -gt 0) {
                $targetStream.Write($buffer, 0, $count)
                $downloaded += $count
                if ($totalLength -gt 0) {
                    $percent = [math]::Round(($downloaded / $totalLength) * 100)
                    Write-Progress -Activity "Downloading SCRCPY" -Status "$percent% Complete" -PercentComplete $percent -Id 1
                }
            }
        } while ($count -gt 0)
    } finally {
        if ($targetStream) { $targetStream.Dispose() }
        if ($responseStream) { $responseStream.Dispose() }
        if ($response) { $response.Close() }
    }
    Write-Progress -Activity "Downloading SCRCPY" -Completed -Id 1
}

function Install-Scrcpy {
    $installDir = Join-Path $HOME ".scrcpy"
    
    if ($IsMacOS) {
        Write-Host " [*] Installing scrcpy via Homebrew..." -ForegroundColor Yellow
        bash -c "brew install scrcpy"
        Write-Host " [v] Successfully installed SCRCPY!" -ForegroundColor Green
        return
    } elseif ($IsLinux) {
        Write-Host " [*] Installing scrcpy via APT..." -ForegroundColor Yellow
        bash -c "sudo apt-get update && sudo apt-get install -y scrcpy"
        Write-Host " [v] Successfully installed SCRCPY!" -ForegroundColor Green
        return
    } else {
        $url = "https://github.com/Genymobile/scrcpy/releases/download/v2.4/scrcpy-win64-v2.4.zip"
        $binDir = Join-Path $installDir "scrcpy-win64-v2.4"
    }
    
    $zipPath = Join-Path $HOME "scrcpy.zip"

    Write-Host " [*] Preparing installation directory..." -ForegroundColor Yellow
    if (Test-Path $installDir) { Remove-Item -Path $installDir -Recurse -Force }
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null

    Write-Host " [*] Downloading SCRCPY from GitHub..." -ForegroundColor Yellow
    Invoke-FastDownload -Url $url -OutFile $zipPath

    Write-Host " [*] Extracting files..." -ForegroundColor Yellow
    try { Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue } catch {}
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $installDir)

    Write-Host " [*] Cleaning up..." -ForegroundColor Yellow
    Remove-Item -Path $zipPath -Force

    Write-Host " [*] Adding to system PATH..." -ForegroundColor Yellow
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath -notmatch [regex]::Escape($binDir)) {
        [Environment]::SetEnvironmentVariable("PATH", "$userPath;$binDir", "User")
    }

    Write-Host " [v] Successfully installed SCRCPY!" -ForegroundColor Green
    Write-Host "     Please restart your terminal to use 'scrcpy'." -ForegroundColor Gray
}

function Uninstall-Scrcpy {
    if ($IsMacOS) {
        Write-Host " [*] Uninstalling scrcpy via Homebrew..." -ForegroundColor Yellow
        bash -c "brew uninstall scrcpy"
        return
    } elseif ($IsLinux) {
        Write-Host " [*] Uninstalling scrcpy via APT..." -ForegroundColor Yellow
        bash -c "sudo apt-get remove -y scrcpy"
        return
    }

    $installDir = Join-Path $HOME ".scrcpy"
    $binDir = Join-Path $installDir "scrcpy-win64-v2.4"

    Write-Host " [*] Removing SCRCPY files..." -ForegroundColor Yellow
    if (Test-Path $installDir) { Remove-Item -Path $installDir -Recurse -Force }

    Write-Host " [*] Removing from system PATH..." -ForegroundColor Yellow
    $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($userPath) {
        $newPath = ($userPath -split ';' | Where-Object { $_ -ne $binDir -and $_ -ne "" }) -join ';'
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
    }

    Write-Host " [v] Successfully uninstalled SCRCPY!" -ForegroundColor Green
}

Show-CatHeader

Write-Host " 1. Install SCRCPY" -ForegroundColor White
Write-Host " 2. Uninstall SCRCPY" -ForegroundColor White
Write-Host ""
$choice = Read-Host " Select an option (1/2)"

Write-Host ""
if ($choice -eq '1') {
    Install-Scrcpy
} elseif ($choice -eq '2') {
    Uninstall-Scrcpy
} else {
    Write-Host " [x] Invalid option selected." -ForegroundColor Red
}
