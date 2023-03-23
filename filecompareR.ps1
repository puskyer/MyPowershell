
$logpath = "E:\Pictures\output\output.log"
$transactionlog = "E:\Pictures\output\transaction.log"

Start-Transcript -Path $transactionlog

write-host "Start logging to $logpath " > $($logpath)

if ( -not (Test-Path -Path E:\Pictures\Output\Data.csv -PathType Leaf)) {
  (Get-ChildItem -Path E:\Pictures\Backup -Recurse -ErrorAction SilentlyContinue -Force).Fullname | ForEach-Object {
    Get-FileHash -Path $_ |  Select-Object -Property hash,path 
    } | Export-Csv -Path E:\Pictures\Output\Data.csv -NoTypeInformation 
}

 
    $csv = Import-Csv E:\Pictures\Output\Data.csv -delimiter ","
    foreach($item in $csv){
    #Write-Host "$($item.path) has $($item.hash) " >> $($logpath)
    $isfilename = Split-Path -Path "$($item.path)" -Leaf -Resolve
    #Write-Host "Working on Filename $($isfilename) " >>  $($logpath)
    $newfullname = Join-path -path E:\Pictures\Pictures -ChildPath $($isfilename)
    if (-not (Test-Path -Path $($newfullname) -PathType Leaf)) {
       $newfullname = (Get-ChildItem -Path E:\Pictures\Pictures -filter $($isfilename)  -Recurse -ErrorAction SilentlyContinue -Force).Fullname
       }
        if ( ($newfullname) -and ( ($newfullname).count -eq 1 ) ) {
            if (Test-Path -Path $($newfullname) -PathType Leaf) {
                $newhash = Get-FileHash -Path $($item.path) |  Select-Object -Property hash
                #Write-Host "$($newhash.hash)" >> $logpath
                if( $($item.hash) -eq $($newhash.hash) ) {
                    Write-Host "File $($newfullname) with Hash $($newhash.hash) Matches" >> $($logpath)
                } else {
                    Write-Host "File $($newfullname) with Hash $($newhash.hash) does not Match $($item.hash)" >> $($logpath)
                }
            }` else {
                Write-Host "File $($newfullname) does not exist!" >> $($logpath)
            }
        } elseif ( ($newfullname).count -gt 1 ) {
            
            #Start-Sleep -Seconds 10
            $newfullname | ForEach-Object {
                write-host "Start looping" >> $($logpath)
                $newhash = Get-FileHash -Path $($_) |  Select-Object -Property hash
                #Write-Host "$($newhash.hash)" >> $logpath
                if( $($item.hash) -eq $($newhash.hash) ) {
                    Write-Host "File $($_) with Hash $($newhash.hash) Matches" >> $($logpath)
                } else {
                    Write-Host "File $($_) with Hash $($newhash.hash) does not Match $($item.hash)" >> $($logpath)
                }
            }
            write-host "End of looping" >> $($logpath)
            # Start-Sleep -Seconds 30
        } else {
          Write-Host "File $($item.path) with Hash $($item.hash) does not exist! " >> $($logpath)
        }
    
    }

Stop-Transcript


#Format-Table
#Get-Content -Path E:\Pictures\Output\Data.csv
#$Folder1 = Get-childitem "E:\Pictures\Pictures"
#$Folder2 = Get-childitem  "E:\Pictures\Backup"
#Compare-Object $Folder1 $Folder2 -Property Name, Length  | Where-Object {$_.SideIndicator -eq "<="}
#Compare-Object $Folder1 $Folder2 -Property Name, Length  | Where-Object {$_.SideIndicator -eq "<="} | ForEach-Object {
#    Copy-Item "C:\Folder1\$($_.name)" -Destination "C:\Folder3" -Force
#    }


#$LHS = Get-ChildItem �Path E:\Pictures\Backup -Recurse | foreach {Get-FileHash �Path $_.FullName}
#$RHS = Get-ChildItem �Path E:\Pictures\Pictures -Recurse | foreach {Get-FileHash �Path $_.FullName}
#Compare-Object -ReferenceObject $LHS -DifferenceObject $RHS -Property hash -PassThru | Format-List

#$newhash = Get-FileHash �Path E:\Pictures\Backup\1606069682350.jpg |  Select-Object -Property hash
# (Get-ChildItem -Path E:\Pictures\Pictures -Filter  01_20201110104725.jpg  -Recurse -ErrorAction SilentlyContinue -Force).Fullname
#$csv = Import-Csv E:\Pictures\Output\Data.csv -delimiter ","
#$csv | Select-Object -Property hash,path

#%{$_.FullName} | Get-FileHash 

# Get-FileHash  E:\Pictures\Backup\1606069682350.jpg |  Get-Member
# Split-Path -Path "E:\Pictures\Backup\1606069682350.jpg" -Leaf -Resolve
# Get-Member
# (Get-ChildItem -Path E:\Pictures\Backup -Filter SAM_1536.JPG -Recurse -ErrorAction SilentlyContinue -Force).gethashcode() | Get-Member
