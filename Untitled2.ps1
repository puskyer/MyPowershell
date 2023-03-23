#$newfullname = (Get-ChildItem -Path E:\Pictures\Pictures -filter SAM_1540.JPG  -Recurse -ErrorAction SilentlyContinue -Force).Fullname
#if ( ($newfullname) -and ( ($newfullname).count -eq 1 ) ) {
##if ( ($newfullname) ) {
#  Write-Host "just one"
#} elseif ( ($newfullname).count -gt 1 ) {
#  Write-Host "More then one"
#} else {
#  Write-Host "No Match"
#}

 $isfilename = "01_20201125102418.jpg"
 $newfullname = Join-path -path E:\Pictures\Pictures -ChildPath $($isfilename)
    if (-not (Test-Path -Path $($newfullname) -PathType Leaf)) {
       $newfullname = (Get-ChildItem -Path E:\Pictures\Pictures -filter $($isfilename)  -Recurse -ErrorAction SilentlyContinue -Force).Fullname
       }
 $newfullname
 

# SAM_1540.JPG
# 01_20201125102418.jpg
# 20190730_112033.jpg