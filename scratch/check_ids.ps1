$filePath = "index.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

$matches = [regex]::Matches($content, 'document\.getElementById\((.*?)\)')
$missingIds = @()

foreach ($m in $matches) {
    $rawId = $m.Groups[1].Value.Trim("'", '"')
    if (-not $rawId.Contains("+") -and -not $rawId.Contains("$")) {
        if (-not $content.Contains('id="' + $rawId + '"') -and -not $content.Contains("id='$rawId'")) {
            $missingIds += $rawId
        }
    }
}

Write-Host "Missing DOM Element IDs:"
$missingIds | Select-Object -Unique | ForEach-Object { Write-Host "  - $_" }
