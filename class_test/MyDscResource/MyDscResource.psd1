@{
    Author               = 'Fluffy-Ckaes'
    CompanyName          = 'Fluffy-Ckaes'
    Copyright            = ''
    Description          = 'Testing DSC stuff'
    DscResourcesToExport = @('MySvc')
    FunctionsToExport    = @('Get-ThisSvc','Set-ThisSvc','Test-ThisSvc')
    GUID                 = '3854d71c-5810-4abf-8be3-fa0d19f73c3e'
    ModuleVersion        = '1.0.0'
    PowerShellVersion    = '7.0'
    RootModule           = 'MyDscResource.psm1'
    PrivateData          = @{
        PSData           = @{}
    }
}