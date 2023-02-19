

<#
$FileExtenions = @(

    ".mp4",
    ".mov",
    ".3GP",
    ".AVI",
    ".bdmv",
    ".clpi",
    ".cos2",
    ".cpi",
    ".db",
    ".index",
    ".ini",
    ".JPG",
    ".K02VcP",
    ".m2ts",
    ".MOV",
    ".mpg",
    ".mpls",
    ".mts",
    ".pps",
    ".scn",
    ".THM",
    ".wmv",
    ".xml"
)
#>

$SrcRootDIR = "G:\Android\"

Set-Location $SrcRootDIR

#$csvFile = ('C:\temp\FileHashInfo_'+(Get-Date).Day+"-"+(Get-Date).Month+"-"+(Get-Date).Year+"-"+(Get-Date).Hour+"-"+(Get-Date).Minute+".csv")

$RootdataArray = [System.Collections.ArrayList]::new()
$dataArray = @()

(Get-ChildItem -path $SrcRootDIR -Recurse -Directory -Depth 0 | Select-Object name) | ForEach-Object { $null =  $RootdataArray.add($_) }

$RootdataArray.Name  | ForEach-Object {
    $_
    (Get-ChildItem -path $SrcRootDIR+$_ -Recurse -Directory | Select-Object fullname) | ForEach-Object { $null =  $dataArray.add($_) }   

}

