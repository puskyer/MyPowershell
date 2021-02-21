

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

#$RootDIR = "G:\Pictures\"
$RootDIR = "F:\Jacinthe\Videos\"
$date2015 = " (2015_10_12 00_33_51 UTC)"
$date2016 = " (2016_08_13 18_00_38 UTC)"
$fileExt = ".*"
$dateStr3 = "UTC)"
$mypath = $RootDIR+"*"+$dateStr3+$fileExt

Set-Location $RootDIR

$Objs = @()
$Remove_count = 0
$keep_Count = 0
$NoExist_Count = 0

$csvFile = ('C:\temp\FileHashInfo_'+(Get-Date).Day+"-"+(Get-Date).Month+"-"+(Get-Date).Year+"-"+(Get-Date).Hour+"-"+(Get-Date).Minute+".csv")

$State = ""
$StateRemoved = "Deleted"
$StateKept = "KeptAsIs"
$StateRenamed = "Renamed"

$Objs = Get-ChildItem $mypath -Recurse


$Objs | ForEach-Object {

    $ObjDir = $_.DirectoryName+"\"
    $Objfile = ($_.Name).trim()
    #$fileExt = ($_.Extension).trim()
    #$ObjBaseName = (($Objfile.split('('))[0]).trim()+$fileExt
    if ($Objfile.Contains($date2015)) {
        $ObjBaseName = ($Objfile).replace($date2015,"")
    } elseif ($Objfile.Contains($date2016))  {
        $ObjBaseName = ($Objfile).replace($date2016,"")
    }
    if ((get-location).Path+"\" -ne $ObjDir) { 
        Set-Location $ObjDir 
        Write-Host("Working Directory is """+$ObjDir+""" File is """+$Objfile+"""")
    }

    # if file exist 
    if (Test-Path -Path ($ObjDir+$ObjBaseName) -PathType Leaf) {

        $HashBaseName = (Get-FileHash  $ObjBaseName -Verbose  -Algorithm SHA384)
        $Hashfile = (Get-FileHash  $Objfile -Verbose  -Algorithm SHA384)
        $FileStatsBaseName = Get-ChildItem -Path  $ObjBaseName
        $FileStatsfile = Get-ChildItem -Path  $Objfile

        # Hash, File Size and LastWriteTimeUtc must be the same before deleting
        if ( ($HashBaseName.Hash -eq $Hashfile.Hash) -and ($FileStatsBaseName.Length -eq $FileStatsfile.Length) -and ($FileStatsBaseName.LastWriteTimeUtc -eq $FileStatsfile.LastWriteTimeUtc) ) {
            #$MStringSame = 'File "'+(($HashBaseName).Path).trim()+'" is the same as "'+(($Hashfile).Path).trim()+'" !'
            Write-Host ('File "'+(($HashBaseName).Path).trim()+'" is the same as "'+(($Hashfile).Path).trim()+'" !')
            #Write-Host ("Would be removing "+($Hashfile).Path)
            Remove-Item -Path ($Hashfile).Path -Verbose -Force 
            $Remove_count +=1
            $state = $StateRemoved

        } else {
            #$MStringNotSame = 'File "'+(($HashBaseName).Path).trim()+'" is Not the same as "'+(($Hashfile).Path).trim()+'" !'
            Write-Host ('File "'+(($HashBaseName).Path).trim()+'" is Not the same as "'+(($Hashfile).Path).trim()+'" !')
            $keep_Count +=1
            $state = $StateKept
        }
    } else {
        Write-Host('"'+$ObjBaseName+'" Does not exist! Renaming "'+$ObjDir+$Objfile+'" to "'+$ObjDir+$ObjBaseName+'"')
        #Write-Host(($Hashfile).Path+" would be renamed to "+$ObjBaseName)
        Rename-Item -Path ($ObjDir+$Objfile) -NewName $ObjBaseName -Verbose
        $NoExist_Count +=1
        $state = $StateRenamed
    }

    # build the array of data we need
    $objectProperty = @{}
    $null = $objectProperty.Add('Folder',$ObjDir)
    $null = $objectProperty.Add('OrgFile',$Objfile)
    $null = $objectProperty.Add('OrgfileHash',$Hashfile.Hash)
    $null = $objectProperty.Add('OrgFileSize',$FileStatsfile.Length)
    $null = $objectProperty.Add('OrgFileLastWriteTimeUtc',$FileStatsfile.LastWriteTimeUtc)
    $null = $objectProperty.Add('BaseFileName',$ObjBaseName)
    $null = $objectProperty.Add('BaseFileNameHash',$HashBaseName.Hash)
    $null = $objectProperty.Add('BaseFileNameSize',$FileStatsBaseName.Length)
    $null = $objectProperty.Add('BaseFileNameLastWriteTimeUtc',$FileStatsBaseName.LastWriteTimeUtc)
    $null = $objectProperty.Add('FileState',$State)

    # create new Objects from the array
    $FileInfo = New-Object -TypeName PSCustomObject -Property $objectProperty
    #$FileInfo
    $FileInfo | Select-Object  Folder,OrgFile,OrgfileHash,OrgFileSize,OrgFileLastWriteTimeUtc,BaseFileName,BaseFileNameHash,BaseFileNameSize,BaseFileNameLastWriteTimeUtc,FileState | Export-Csv -Path $csvFile -NoTypeInformation -Append
}
Set-Location $RootDIR

Write-Host($Remove_count)
Write-Host("files removed")
Write-Host($keep_Count)
Write-Host("files Not removed")
Write-Host($NoExist_Count)
Write-Host("Root files that do Not exist")
Write-Host($Objs.count)
Write-Host("Total files")



