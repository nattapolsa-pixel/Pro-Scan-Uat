$filePath = "index.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# Check brace balance in script block
$scriptStart = $content.IndexOf("<script>")
$scriptEnd = $content.LastIndexOf("</script>")

if ($scriptStart -ge 0 -and $scriptEnd -gt $scriptStart) {
    $js = $content.Substring($scriptStart + 8, $scriptEnd - $scriptStart - 8)
    
    $openBraces = ($js.ToCharArray() | Where-Object { $_ -eq '{' }).Count
    $closeBraces = ($js.ToCharArray() | Where-Object { $_ -eq '}' }).Count
    
    $openParens = ($js.ToCharArray() | Where-Object { $_ -eq '(' }).Count
    $closeParens = ($js.ToCharArray() | Where-Object { $_ -eq ')' }).Count
    
    $openBrackets = ($js.ToCharArray() | Where-Object { $_ -eq '[' }).Count
    $closeBrackets = ($js.ToCharArray() | Where-Object { $_ -eq ']' }).Count
    
    Write-Host "JS Analysis:"
    Write-Host "  { : $openBraces | } : $closeBraces"
    Write-Host "  ( : $openParens | ) : $closeParens"
    Write-Host "  [ : $openBrackets | ] : $closeBrackets"

    if ($openBraces -ne $closeBraces) {
        Write-Host "🚨 BRACE MISMATCH DETECTED!"
    }
    if ($openParens -ne $closeParens) {
        Write-Host "🚨 PARENTHESIS MISMATCH DETECTED!"
    }
    if ($openBrackets -ne $closeBrackets) {
        Write-Host "🚨 BRACKET MISMATCH DETECTED!"
    }
}
