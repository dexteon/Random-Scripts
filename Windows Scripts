
## Windows Scripts

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
## Tamper Monkey Scripts

Instacart Ad Remover Based on Data Attribute
```
// ==UserScript==
// @name         Instacart Ad Remover Based on Data Attribute
// @namespace    http://tampermonkey.net/
// @version      2.2
// @description  Removes  sponsored products from Instacart view.
// @author       GPT-4
// @grant        none
// @match        *://*.instacart.com/*
// ==/UserScript==
(function() {
    'use strict';
    function removeSponsoredProducts() {
        document.querySelectorAll('[data-cfp-eligible]').forEach((element) => {
            const sponsoredItem = element.closest('li');
            if (sponsoredItem) {
                sponsoredItem.remove();
            }
        });
    }
    const observer = new MutationObserver(() => {
        removeSponsoredProducts();
    });
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    removeSponsoredProducts();
})();
```
