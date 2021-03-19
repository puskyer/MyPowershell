

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
$RootDIR = "D:\RICCIOCAST\Data\"
$fileExt = ".*"
$dateStr3 = '(201[0-9]_[0-9][0-9]_[0-9][0-9] [0-9][0-9]_[0-9][0-9]_[0-9][0-9] UTC)'
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

$dataArray= [System.Collections.ArrayList]::new()
$dates = [System.Collections.ArrayList]::new()

$Objs | ForEach-Object { 

    #$ObjDir = $_.DirectoryName+"\"
    $Objfile = ($_.Name).trim()
    $fileExt = ($_.Extension).trim()

    $Obj = $Objfile.split("(")
    
    $Obj | ForEach-Object {    
       if ( $_ -cmatch '(201[0-9]_[0-9][0-9]_[0-9][0-9] [0-9][0-9]_[0-9][0-9]_[0-9][0-9] UTC)') {
        $stg = '"('+($_).Replace($fileExt,"")+'"'

       }
    }
        
    $null = $dataArray.add("$stg")

}

$dataArray | Select-Object -Unique | ForEach-Object { 

    if (($_ -match '(201[0-9]_[0-9][0-9]_[0-9][0-9] [0-9][0-9]_[0-9][0-9]_[0-9][0-9] UTC)')) { $null = $dates.add($_)}

}

$Objs | ForEach-Object {

    $ObjDir = $_.DirectoryName+"\"
    $Objfile = ($_.Name).trim()
    $fileExt = ($_.Extension).trim()
    $FileBaseName = ($_.Basename).trim()
    #$Obj = $Objfile.split("(",2)
    #$stg = '"('+($Obj[1]).Replace($fileExt,"")+'"'

    $dates | ForEach-Object {
        $stg = $_.trim('"')

        if ( $FileBaseName -match $stg ) {
            $ObjBaseName = ($FileBaseName.Replace($stg,"")).trim()+$fileExt
        }
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
        #Write-Host(($ObjDir+$Objfile)+" would be renamed to "+$ObjBaseName)
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



