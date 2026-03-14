$tmp = Join-Path $env:TEMP "yazi-chosen-$PID"
Start-Process yazi -ArgumentList "--chooser-file=$tmp" -Wait

if (Test-Path $tmp -PathType Leaf) {
    $paths = Get-Content -Raw $tmp
    
    if ($paths -ne $null -and $paths.Trim() -ne "") {
        # search:// 形式の場合、実際のパスを抽出
        if ($paths -like "search://*") {
            $paths = $paths -replace '^search://[^/]*/', ''
        }

        Remove-Item $tmp -ErrorAction SilentlyContinue
        
        # Zellij 操作
        zellij action toggle-floating-panes
        zellij action write 27
        zellij action write-chars ":open `"$paths`""
        zellij action write 13
    }
    else {
        Remove-Item $tmp -ErrorAction SilentlyContinue
        zellij action toggle-floating-panes
    }
}
else {
    zellij action toggle-floating-panes
}