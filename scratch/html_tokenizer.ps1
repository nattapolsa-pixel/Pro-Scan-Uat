$filePath = "index.html"
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# Extract only HTML section before <script>
$scriptIdx = $content.IndexOf("<script>")
$htmlContent = $content.Substring(0, $scriptIdx)

$stack = [System.Collections.Generic.Stack[string]]::new()

$regex = [regex]'</?div[\s>]'
$matches = $regex.Matches($htmlContent)

$errCount = 0

foreach ($m in $matches) {
    $tag = $m.Value
    if ($tag.StartsWith("</")) {
        if ($stack.Count -eq 0) {
            Write-Host "🚨 Extra closing </div> at index $($m.Index)"
            $errCount++
        } else {
            $stack.Pop()
        }
    } else {
        $stack.Push("div")
    }
}

Write-Host "Unclosed <div> count: $($stack.Count)"
if ($stack.Count -eq 0 -and $errCount -eq 0) {
    Write-Host "✅ HTML structure in index.html is 100% PERFECT!"
}
