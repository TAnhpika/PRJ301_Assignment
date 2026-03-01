Get-ChildItem -Path 'web' -Recurse -Include '*.jsp','*.html' | ForEach-Object {
    $content = Get-Content $_.FullName -Raw -Encoding UTF8
    $original = $content
    $content = $content -replace 'dist/view/assets/css/bootstrap', 'dist/css/bootstrap'
    $content = $content -replace 'dist/view/assets/js/bootstrap', 'dist/js/bootstrap'
    $content = $content -replace 'font-awesome/6\.4\.0/view/assets/css/', 'font-awesome/6.4.0/css/'
    $content = $content -replace 'font-awesome/6\.0\.0/view/assets/css/', 'font-awesome/6.0.0/css/'
    $content = $content -replace 'font-awesome/6\.0\.0-beta3/view/assets/css/', 'font-awesome/6.0.0-beta3/css/'
    if ($content -ne $original) {
        Set-Content $_.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Fixed CDN: $($_.FullName)"
    }
}
