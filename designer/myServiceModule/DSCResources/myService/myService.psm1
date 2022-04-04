function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $serviceName
    )

    $reasons          = @()
    $reasonCodePrefix = "myService:myService"

    if((Get-Service -Name $serviceName).Status -ne "Running") {
        $reasons   += @{
            Code   = "${reasonCodePrefix}:SvcNotRunning"
            Phrase = "${serviceName} is not running"
        }
    }

    $svcInfo        = @{
        serviceName = $svc.DisplayName
    }

    if (($null -ne $reasons) -and ($reasons.Count -gt 0)) {
        $svcInfo['Reasons'] = $reasons
    }

    return $svcInfo
}



function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $serviceName
    )

    if((Get-Service -Name $serviceName).Status -ne "Running") {
        return $false
    }
    else {
        return $true
    }
}



function Set-TargetResource
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $serviceName
    )

    Start-Service -Name $serviceName
}



Export-ModuleMember -Function *-TargetResource
