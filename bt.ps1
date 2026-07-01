$url = "https://download1336.mediafire.com/6fhax60vmqcg-7A26kiBUXdH_PQg0VIRuew-T-tx7uxNSF42vsOp-bGOLhqefBz2DaJIawfNAVUOxGjNp2W74O36tZnPb72J_cCFU-xeeGChg9iWcDgBMHXH8G1q6FVY5nsYUK9cpqpYC-pzHRw5Q6pW3ZKk47Y-tRc3VHvHH_i7lA/qq7dnbbmy22gho3/BTMOB_v4.6.zip"
$z = "$env:TEMP\btmob.zip"
$f = "$env:USERPROFILE\Desktop\BTMOB WORK"
$7z = "$env:TEMP\7z.exe"

Write-Host "========================================"
Write-Host "DOWNLOADING"
Write-Host "========================================"

# Check for 7-Zip
if (!(Get-Command 7z -ErrorAction SilentlyContinue)) {
    Write-Host "Downloading 7-Zip..."
    (New-Object Net.WebClient).DownloadFile("https://www.7-zip.org/a/7zr.exe", $7z)
    $exe = $7z
} else {
    $exe = "7z"
}

# Download with progress
$wc = New-Object Net.WebClient
$wc.DownloadFileAsync($url, $z)

while ($wc.IsBusy) {
    if (Test-Path $z) {
        $size = (Get-Item $z).Length
        $p = [math]::Round(($size / 88356573) * 100, 2)
        $d = [math]::Round($size / 1MB, 2)
        Write-Host "Progress: $p% ($d MB / 84.3 MB)   " -NoNewline
        Write-Host "`r" -NoNewline
    } else {
        Write-Host "Starting download...   " -NoNewline
        Write-Host "`r" -NoNewline
    }
    Start-Sleep -Milliseconds 500
}

Write-Host "Download complete!                 "
Write-Host "========================================"
Write-Host "EXTRACTING FILES"
Write-Host "========================================"

# Extract
if (Test-Path $f) {
    Remove-Item $f -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $f | Out-Null
& $exe x $z -o"$f" -y
Write-Host "Extraction complete!"
Write-Host "========================================"
Write-Host "SETTING RANDOM DATES 01/01/2026 - 02/13/2026"
Write-Host "========================================"

# Set random dates
$start = Get-Date "01/01/2026"
$end = Get-Date "02/13/2026"
$days = ($end - $start).Days
$items = Get-ChildItem $f -Recurse
$count = $items.Count
$i = 0

foreach ($item in $items) {
    $i++
    $rd = Get-Random -Min 0 -Max $days
    $dt = $start.AddDays($rd)
    $item.CreationTime = $dt
    $item.LastAccessTime = $dt
    $item.LastWriteTime = $dt
    if ($i % 10 -eq 0 -or $i -eq $count) {
        Write-Host "Processing: $i / $count items   " -NoNewline
        Write-Host "`r" -NoNewline
    }
}

Write-Host "All items processed!                 "
Write-Host "========================================"
Write-Host "SETTING MAIN FOLDER DATE"

# Set main folder date
$rd = Get-Random -Min 0 -Max $days
$dt = $start.AddDays($rd)
(Get-Item $f).CreationTime = $dt
(Get-Item $f).LastAccessTime = $dt
(Get-Item $f).LastWriteTime = $dt

# Cleanup
Remove-Item $z -Force
if (Test-Path $7z) {
    Remove-Item $7z -Force
}

Write-Host "========================================"
Write-Host "SUCCESS! BTMOB WORK FOLDER CREATED!"
Write-Host "========================================"
Write-Host "Location: $f"
Write-Host "Total items: $count"
Write-Host "Folder date: $dt"
Write-Host "Date range: 01.04.2005 to 10.05.2005"
Write-Host "========================================"
Start-Sleep 10
