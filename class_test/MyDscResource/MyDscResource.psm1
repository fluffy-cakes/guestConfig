enum ensure {
    Running
    Stopped
}




<#
    This class is used within the DSC Resource to standardize how data
    is returned about the compliance details of the machine.
#>
class Reason {
    [DscProperty()]
    [string]$Code

    [DscProperty()]
    [string]$Phrase
}




<#
    Public Functions
#>

function Get-ThisSvc {
    param(
        [ensure]$ensure,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$serviceName
    )

    $serviceDetails      = [reason]::new()
    $serviceDetails.Code = "myService:myService:${serviceName}"
    $ensureReturn        = "Stopped"

    if((Get-Service -Name $serviceName).Status -ne "Running") {
        $serviceDetails.Phrase = "${serviceName} is NOT running"
    }
    else {
        $serviceDetails.Phrase = "${serviceName} is running"
        $ensureReturn          = "Running"
    }

    return @{
        ensure  = $ensureReturn
        Reasons = @($serviceDetails)
    }
}

function Set-ThisSvc {
    param(
        [ensure]$ensure = "Running",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$serviceName
    )

    if($ensure -eq "Running") {
        Start-Service -Name $serviceName
    }
}

function Test-ThisSvc {
    param(
        [ensure]$ensure = "Running",

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$serviceName

    )
    $test = $false
    $get = Get-ThisSvc @PSBoundParameters

    if ($get.ensure -eq $ensure) {
        $test = $true
    }
    return $test
}




<#
    This resource manages the file in a specific path.
    [DscResource()] indicates the class is a DSC resource
#>

[DscResource()]
class MySvc {

    [DscProperty(Key)]
    [string]$serviceName

    [DscProperty(Mandatory)]
    [ensure]$ensure

    [DscProperty(NotConfigurable)]
    [Reason[]]$Reasons

    [MySvc] Get() {
        $get  = Get-ThisSvc -ensure $this.ensure -serviceName $this.serviceName
        return $get
    }

    [void] Set() {
        $set  = Set-ThisSvc -ensure $this.ensure -serviceName $this.serviceName
    }

    [bool] Test() {
        $test = Test-ThisSvc -ensure $this.ensure -serviceName $this.serviceName
        return $test
    }
}
