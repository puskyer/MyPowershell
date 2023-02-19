
New-Alias -Name sudo -Value $ENV:UserProfile\Documents\WindowsPowerShell\sudo.ps1
New-Alias -Name ll   -Value Get-ChildItem

if ( Test-Path -Path ("$ENV:UserProfile\.ssh\id_rsa_pasqu@PuskyRoG") -PathType Leaf) { ssh-add.exe $ENV:UserProfile\.ssh\id_rsa_pasqu@PuskyRoG }
if ( Test-Path -Path ("$ENV:UserProfile\.ssh\id_ras_xcp-ng") -PathType Leaf) { ssh-add.exe $ENV:UserProfile\.ssh\id_ras_xcp-ng }
