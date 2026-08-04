$filePath = "index.html"
$lines = [System.IO.File]::ReadAllLines($filePath, [System.Text.Encoding]::UTF8)

$divOpen = 0
$divClose = 0

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    $divOpen += ([regex]::Matches($line, '<div[\s>]')).Count
    $divClose += ([regex]::Matches($line, '</div>')).Count
}

Write-Host "HTML Analysis:"
Write-Host "  <div count: $divOpen"
Write-Host "  </div> count: $divClose"

if ($divOpen -ne $divClose) {
    Write-Host "🚨 DIV TAG MISMATCH DETECTED: open $divOpen vs close $divClose"
} else {
    Write-Host "✅ HTML <div> tag balance is 100% PERFECT!"
}
