$config         = "base"
$stgAccountName = "pmacktestconfig"
$mgmtGroupId    = "xxx"


. "./${config}.ps1"
Invoke-Expression -Command $config


$package = New-GuestConfigurationPackage `
    -Name          $config  `
    -Configuration "./${config}/localhost.mof" `
    -Type          "Audit" `
    -Force `
    -Verbose


Get-AzStorageAccount |
    Where-Object { $_.StorageAccountName -eq $stgAccountName } |
        Get-AzStorageContainer -Name "guest-configs" |
            Set-AzStorageBlobContent -File $package.Path -Blob "${config}.zip" -Force -Verbose


$key = Get-AzStorageAccount |
    Where-Object { $_.StorageAccountName -eq $stgAccountName } |
        Get-AzStorageAccountKey


$sasToken = New-AzStorageContext -StorageAccountName $stgAccountName -StorageAccountKey $key[0].Value |
    New-AzStorageBlobSASToken `
        -Blob       "${config}.zip" `
        -Container  "guest-configs" `
        -Permission "r" `
        -StartTime  $((Get-Date).AddMinutes(-30)) `
        -ExpiryTime $((Get-Date).AddDays(60))



$def        = Get-AzPolicyDefinition -Custom | Where-Object { $_.Properties.DisplayName -eq $config }
$contentUri = "https://${stgAccountName}.blob.core.windows.net/guest-configs/${config}.zip"


if($def) {
    New-GuestConfigurationPolicy `
        -ContentUri  "${contentUri}${sasToken}" `
        -Description "Details about my policy" `
        -DisplayName $config `
        -Path        "./policies" `
        -Platform    "Windows" `
        -PolicyId    $def.ResourceName `
        -Version     1.0.0
} else {
    New-GuestConfigurationPolicy `
        -ContentUri  "${contentUri}${sasToken}" `
        -Description "Details about my policy" `
        -DisplayName $config `
        -Path        "./policies" `
        -Platform    "Windows" `
        -PolicyId    $((New-Guid).Guid) `
        -Version     1.0.0
}


Publish-GuestConfigurationPolicy -Path "./policies" -ManagementGroupName $mgmtGroupId

# az policy state trigger-scan --no-wait