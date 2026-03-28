# tmp file
$tmp = Join-Path $env:TEMP ("yazi-chosen-" + $PID)

# run yazi chooser
yazi --chooser-file "$tmp"

if (Test-Path $tmp -and (Get-Content $tmp).Length -gt 0) {
    $paths = Get-Content $tmp -Raw

    # search:// の場合は実パスを抽出
    if ($paths -like "search://*") {
        $paths = $paths -replace "search://[^/]*/", ""
    }

    Remove-Item $tmp -Force

    # zellij actions
    zellij action toggle-floating-panes
    zellij action write 27
    zellij action write-chars ":open `"$paths`""
    zellij action write 13
}
else {
    if (Test-Path $tmp) { Remove-Item $tmp -Force }
    zellij action toggle-floating-panes
}
