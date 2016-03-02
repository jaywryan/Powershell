Function Get-JWRESXDrivers {
<#
.Synopsis
   Retrieve drivers and version for ESXi hosts
.DESCRIPTION
   This is function uses PowerCLI and ESXCLI to retrieve the drivers
   from any ESXi host.  This is used to verify the driver version
   against to determine if the driver  needs  updated.  This was created
   to avoid manually logging into the hosts, enabling SSH or ESXi Shell
.EXAMPLE
   Get-FFBESXDrivers -vcenter vcenter1.local -hosts esxihost1.local

   Description: Gets the Cisco drivers from the host specified
.EXAMPLE
   Get-FFBESXDrivers -vcenter vcenter1.local

   Description: Gets the drivers for all the hosts registered to this Vcenter

.EXAMPLE
   Get-FFBESXDrivers -vcenter vcenter1.local -Vendor Cisco

   Description: Gets the Cisco drivers all the hosts registered to this Vcenter
.NOTES
    ===========================================================================
    Created on:       3/1/2016
    Contact:          Jay Ryan, http://github.com/jaywryan
    Filename:         Get-JWRESXDrivers.ps1
    ===========================================================================
#>
    Param (
        $VCenter,
        [string[]]$Hosts,
        $Vendor = "*"
    )
    
    
    Connect-VIServer $VCenter | Out-Null

    If (-not ($Hosts) ){
        $Hosts = Get-VMHost | Select-Object -ExpandProperty Name
        }

    Foreach ($esxhost in $hosts) {
    
    $esxcli = Get-EsxCli -VMHost $esxhost
    $obj = $esxcli.software.vib.list() | where {$_.Vendor -like "$Vendor"} | select name,Version,AcceptanceLevel,CreationDate,Vendor,InstallDate
    $obj | Add-Member -MemberType NoteProperty -Name 'ESX Host' -Value $esxhost
    Write-Output $obj

    }

}