Find installed software excluding Windows and those missing executables 
```
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Where-Object { 
    $_.DisplayName -and 
    $_.Publisher -notmatch 'Microsoft' -and
    $_.InstallLocation -and
    (Test-Path "$($_.InstallLocation)\*.exe")
} |
Select-Object Publisher, DisplayName, DisplayVersion, @{Name="ExecutablePath";Expression={
    (Get-ChildItem "$($_.InstallLocation)\*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName)
}} |
Sort-Object -Property ExecutablePath |
Format-Table -AutoSize

```


Show Uninstall files
```
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, 
                 HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Where-Object { $_.DisplayName } |
Select-Object DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString |
Sort-Object -Property DisplayName |
Format-Table -AutoSize
```
