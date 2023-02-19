Get-WmiObject -Class Win32_Product
Get-WmiObject -Class Win32Reg_AddRemovePrograms

Get-AppxPackage -AllUsers | Select Name, PackageFullName
Get-AppxPackage –User UserName | Select Name, PackageFullName