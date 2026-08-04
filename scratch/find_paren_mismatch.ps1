$filePath = "index.html"
$lines = [System.IO.File]::ReadAllLines($filePath, [System.Text.Encoding]::UTF8)

$openCount = 0
$closeCount = 0

for ($i = 1343; $i -lt 4866; $i++) {
    $line = $lines[$i]
    # Remove strings and comments to avoid counting parens inside quotes/comments
    $cleanLine = $line -replace '".*?"', '' -replace "'.*?'", '' -replace '`.*?`', '' -replace '//.*$', ''
    
    $opens = ($cleanLine.ToCharArray() | Where-Object { $_ -eq '(' }).Count
    $closes = ($cleanLine.ToCharArray() | Where-Object { $_ -eq ')' }).Count
    
    $openCount += $opens
    $closeCount += $closes
    
    if ($openCount -ne $closeCount) {
        # Check diff
        $diff = $openCount - $closeCount
        # Write-Host "Line $($i+1): diff $diff | $line"
    }
}

Write-Host "Total Open (: $openCount"
Write-Host "Total Close ): $closeCount"
