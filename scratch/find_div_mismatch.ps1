$filePath = "index.html"
$lines = [System.IO.File]::ReadAllLines($filePath, [System.Text.Encoding]::UTF8)

$depth = 0

for ($i = 0; $i -lt 1344; $i++) {
    $lineNo = $i + 1
    $line = $lines[$i]
    
    $opens = ([regex]::Matches($line, '<div[\s>]')).Count
    $closes = ([regex]::Matches($line, '</div>')).Count
    
    $depth += ($opens - $closes)
    
    if ($depth -lt 0) {
        Write-Host "🚨 DEPTH BELOW ZERO at line ${lineNo}: depth=${depth} | Line: ${line}"
        $depth = 0
    }
}

Write-Host "Final HTML body depth at script start: ${depth}"
