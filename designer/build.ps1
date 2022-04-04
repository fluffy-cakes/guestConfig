$serviceName = New-xDscResourceProperty `
    -Name        "ServiceName" `
    -Type        "String" `
    -Attribute   "Key" `
    -Description "The service name to check"

$reasons = New-xDscResourceProperty `
    -Name      "Reasons" `
    -Type      "String[]" `
    -Attribute "Read"

New-xDscResource `
    -ModuleName "myServiceModule" `
    -Name       "myService" `
    -Path       "." `
    -Property   $serviceName, $reasons
