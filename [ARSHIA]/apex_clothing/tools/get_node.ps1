<#
  ============================================================
   Apex Clothing Studio - portable Node.js fetcher
  ------------------------------------------------------------
   Downloads the official Node.js ZIP from nodejs.org and
   unpacks it to %LOCALAPPDATA%\ApexScriptz\node.

   NOTHING is installed system-wide: no setup, no admin rights,
   no PATH changes, no registry. It is a folder you can delete
   at any time. It lives outside the resource so updating
   apex_clothing never makes you download it again.

   Called by ensure_node.bat - you do not need to run this
   yourself.
  ============================================================
#>

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'   # Invoke-WebRequest is far faster without the progress bar

$Target   = Join-Path $env:LOCALAPPDATA 'ApexScriptz\node'
$Fallback = 'v20.18.1'                     # used only if nodejs.org's version index is unreachable

# Windows 8/older Win10 default to TLS 1.0, which nodejs.org rejects.
try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

# ---- which build do we need -------------------------------------------------
$arch = 'x64'
switch ($env:PROCESSOR_ARCHITECTURE) {
    'AMD64' { $arch = 'x64' }
    'ARM64' { $arch = 'arm64' }
    'x86'   { if ($env:PROCESSOR_ARCHITEW6432 -eq 'AMD64') { $arch = 'x64' } else { $arch = 'x86' } }
}

# ---- latest LTS (falls back to a pinned version) ----------------------------
$version = $null
try {
    $index = Invoke-RestMethod -Uri 'https://nodejs.org/dist/index.json' -UseBasicParsing -TimeoutSec 20
    $lts = $index | Where-Object { $_.lts -and $_.files -contains "win-$arch-zip" } | Select-Object -First 1
    if ($lts) { $version = $lts.version }
} catch {
    Write-Host "  (could not read the version index - using $Fallback)"
}
if (-not $version) { $version = $Fallback }

$zipName = "node-$version-win-$arch.zip"
$url     = "https://nodejs.org/dist/$version/$zipName"
$tmp     = Join-Path $env:TEMP ('apex_node_' + [IO.Path]::GetRandomFileName())

Write-Host ''
Write-Host "  Downloading $zipName"
Write-Host "  from $url"
Write-Host '  (about 30 MB - this can take a minute)'
Write-Host ''

try {
    New-Item -ItemType Directory -Path $tmp -Force | Out-Null
    $zip = Join-Path $tmp $zipName
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing

    Write-Host '  Unpacking...'
    Expand-Archive -LiteralPath $zip -DestinationPath $tmp -Force

    $inner = Get-ChildItem -LiteralPath $tmp -Directory |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'node.exe') } |
        Select-Object -First 1
    if (-not $inner) { throw 'the downloaded archive did not contain node.exe' }

    if (Test-Path -LiteralPath $Target) { Remove-Item -LiteralPath $Target -Recurse -Force }
    New-Item -ItemType Directory -Path (Split-Path -Parent $Target) -Force | Out-Null
    Move-Item -LiteralPath $inner.FullName -Destination $Target

    $exe = Join-Path $Target 'node.exe'
    $ver = & $exe -v
    if ($LASTEXITCODE -ne 0) { throw 'node.exe did not run' }

    Write-Host ''
    Write-Host "  Node.js $ver is ready  ->  $Target"
    exit 0
}
catch {
    Write-Host ''
    Write-Host "  Download failed: $($_.Exception.Message)"
    exit 1
}
finally {
    if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue }
}
