$filePath = "index.html"
$lines = [System.IO.File]::ReadAllLines($filePath, [System.Text.Encoding]::UTF8)

$stack = [System.Collections.Generic.Stack[hashtable]]::new()

for ($lineIdx = 1343; $lineIdx -lt 4866; $lineIdx++) {
    $lineNo = $lineIdx + 1
    $line = $lines[$lineIdx]
    
    $inSingleQuote = $false
    $inDoubleQuote = $false
    $inBacktick = $false
    
    for ($cIdx = 0; $cIdx -lt $line.Length; $cIdx++) {
        $char = $line[$cIdx]
        
        if ($char -eq '/' -and ($cIdx + 1) -lt $line.Length -and $line[$cIdx+1] -eq '/' -and -not $inSingleQuote -and -not $inDoubleQuote -and -not $inBacktick) {
            break
        }
        
        if ($char -eq '"' -and -not $inSingleQuote -and -not $inBacktick) {
            $inDoubleQuote = -not $inDoubleQuote
        } elseif ($char -eq "'" -and -not $inDoubleQuote -and -not $inBacktick) {
            $inSingleQuote = -not $inSingleQuote
        } elseif ($char -eq '`' -and -not $inSingleQuote -and -not $inDoubleQuote) {
            $inBacktick = -not $inBacktick
        }
        
        if (-not $inSingleQuote -and -not $inDoubleQuote -and -not $inBacktick) {
            if ($char -eq '(' -or $char -eq '{' -or $char -eq '[') {
                $item = @{ char = $char; line = $lineNo; col = ($cIdx + 1) }
                $stack.Push($item)
            } elseif ($char -eq ')' -or $char -eq '}' -or $char -eq ']') {
                if ($stack.Count -eq 0) {
                    Write-Host "🚨 UNMATCHED CLOSING '$char' at line $lineNo, col $($cIdx + 1)"
                } else {
                    $top = $stack.Pop()
                    $expected = if ($top.char -eq '(') { ')' } elseif ($top.char -eq '{') { '}' } else { ']' }
                    if ($char -ne $expected) {
                        Write-Host "🚨 MISMATCH: expected '$expected' for '$($top.char)' (from L$($top.line):C$($top.col)), but found '$char' at L${lineNo}:C$($cIdx+1)"
                        Write-Host "   Line content: $line"
                    }
                }
            }
        }
    }
}

if ($stack.Count -gt 0) {
    Write-Host "🚨 UNCLOSED ELEMENTS REMAIN: $($stack.Count)"
    while ($stack.Count -gt 0 -and $i -lt 10) {
        $top = $stack.Pop()
        Write-Host "   Unclosed '$($top.char)' at L$($top.line):C$($top.col)"
    }
} else {
    Write-Host "✅ Stack check completely clean!"
}
