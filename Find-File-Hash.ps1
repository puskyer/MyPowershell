

#Get path
$hOjs.Path | Split-Path 

#get file names
$hOjs.Path | Split-Path -Leaf




$ObjDir = (($Objs.directory).fullname | Sort-Object -Unique)
$Objfiles = ($Objs.name | Sort-Object -Unique)
$ObjBaseName = ((Get-Item $($Obj.Path) ).Basename).split('(')

$numObjs = $Objs.Count
$Objs[0].DirectoryName
$Objs[0].Name


$Obj = Get-FileHash -Path 'I:\Videos\IMx3SEVer6\IMx_AVCHD\Camping 2011\riccio\Riccio - Emily - Tablet\*.mp4' -Verbose  -Algorithm SHA384





$Obj = Get-FileHash -Path 'I:\Videos\IMx3SEVer6\IMx_AVCHD\Camping 2011\riccio\Riccio - Emily - Tablet\*.mp4' -Verbose  -Algorithm SHA384
$Obj
$Objs = ((Get-Item $($Obj.Path) ).Basename).split('(')

#(Get-Item $($PSCommandPath.Path) ).Extension
(Get-Item $($PSCommandPath.Path) ).Basename
#(Get-Item $($PSCommandPath.Path) ).Name
#(Get-Item $($PSCommandPath.Path) ).DirectoryName
#(Get-Item $($PSCommandPath.Path) ).FullName

$fileExt = ".*"
$dateStr3 = "UTC)"
$mypath = "I:\Videos\*"+$dateStr3+$fileExt

$Objs = Get-ChildItem $mypath -Recurse
$Objs | ForEach-Object {
    $ObjDir = $_.DirectoryName+"\"
    $Objfile = ($_.Name).trim()
    $fileExt = ($_.Extension).trim()
    $ObjBaseName = (($Objfile.split('('))[0]).trim()+$fileExt

    $ObjDir
    $Objfile
    $fileExt
    $ObjBaseName
}

($Objs.Extension | Sort-Object -Unique)

