# ============================================================
# auto-organize-downloads.ps1 - Sorts Downloads into subfolders
# Categories: Images, Documents, Executables, Archives, Other
# Run in PowerShell. No extra install required.
# ============================================================

$DownloadsPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
$folders = @{
    Images   = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp", ".svg", ".ico")
    Documents = @(".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".rtf", ".odt", ".csv")
    Exe      = @(".exe", ".msi", ".bat", ".ps1")
    Zip      = @(".zip", ".rar", ".7z", ".tar", ".gz")
}

foreach ($name in $folders.Keys) {
    $path = Join-Path $DownloadsPath $name
    if (-not (Test-Path $path)) { New-Item -ItemType Directory -Path $path -Force | Out-Null }
}

$moved = 0
Get-ChildItem -Path $DownloadsPath -File | ForEach-Object {
    $ext = $_.Extension.ToLower()
    $targetFolder = $null
    foreach ($cat in $folders.Keys) {
        if ($folders[$cat] -contains $ext) { $targetFolder = $cat; break }
    }
    if (-not $targetFolder) { $targetFolder = "Other" }
    $destDir = Join-Path $DownloadsPath $targetFolder
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
    $dest = Join-Path $destDir $_.Name
    if ($_.FullName -ne $dest) {
        Move-Item -Path $_.FullName -Destination $dest -Force -ErrorAction SilentlyContinue
        $moved++
    }
}

Write-Host "  [Done] Organized Downloads. Moved $moved file(s)." -ForegroundColor Green
