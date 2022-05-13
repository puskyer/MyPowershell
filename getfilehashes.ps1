Get-ChildItem -Path 'D:\eBookLibrary\ebooks\ePub' -Exclude {Get-ChildItem 'D:\eBookLibrary\ebooks\ePub\Tolkien, J.R.R_\'} -Recurse -File  | 
    Get-FileHash -Algorithm MD5 | 
    Select-Object * -ExcludeProperty Algorithm |
    Export-Csv -Path 'D:\MediaMD5Hashes.csv' -UseCulture -NoTypeInformation