$files = Get-ChildItem "Screenshot 2025-*.png" | Sort-Object Name

$count = 1
foreach ($file in $files) {
    $newName = "query$count.png"
    Write-Host "Renaming $($file.Name) -> $newName"
    Rename-Item -Path $file.FullName -NewName $newName
    $count++
}
