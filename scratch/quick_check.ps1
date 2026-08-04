$filePath = "index.html"
$lines = [System.IO.File]::ReadAllLines($filePath, [System.Text.Encoding]::UTF8)

Write-Host "Total lines in index.html: $($lines.Length)"

# Find script tags
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i] -match "<script>") {
        Write-Host "Script tag open at line: $($i+1)"
    }
    if ($lines[$i] -match "</script>") {
        Write-Host "Script tag close at line: $($i+1)"
    }
}
