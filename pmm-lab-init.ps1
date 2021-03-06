# Import Modules

#if ((Get-PSSnapin | where {$_.Name -ilike "Vmware*Core"}).Name -ine "VMware.VimAutomation.Core")
#	{
#	Write-Host "Loading PS Snap-in: VMware VimAutomation Core"
#	Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue
#	}

Connect-VIServer -Server prme-haas-vio-vcenter

Connect-VIServer -Server prme-haas-2-vio-vcenter

# Add host to vCenter
Add-VMHost prme-haas-esx093.eng.vmware.com -Location VIO-DC-1 -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx094.eng.vmware.com -Location Management -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx097.eng.vmware.com -Location Edge -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx098.eng.vmware.com -Location Edge -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx099.eng.vmware.com -Location Production -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx100.eng.vmware.com -Location Production -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx101.eng.vmware.com -Location Development -User root -Password PasswordsAreGreat123! -RunAsync -force:$true

Add-VMHost prme-haas-esx093.eng.vmware.com -Location VIO-DC-1 -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx095.eng.vmware.com -Location Management -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx097.eng.vmware.com -Location Edge -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx098.eng.vmware.com -Location Edge -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx099.eng.vmware.com -Location Production -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx100.eng.vmware.com -Location Production -User root -Password PasswordsAreGreat123! -RunAsync -force:$true
Add-VMHost prme-haas-esx101.eng.vmware.com -Location Development -User root -Password PasswordsAreGreat123! -RunAsync -force:$true

$esx = get-vmhost prme-haas-esx096.eng.vmware.com
$esx.Name -match "haas-(.+).eng"
$localdatastore=$matches[1].ToUpper()
$vds = Get-VDSwitch "VIO"
# Move VMhost to cluster. alternatively. set location during add operation to cluster name
Move-VMHost $esx -Location Development -Confirm $false

#rename local storage
#$esx | get-datastore | where {$_.name -match "datastore1"} | set-datastore -name "ESX093-Local"
$esx | get-datastore | where {$_.name -match "datastore1"} | set-datastore -name $localdatastore"-Local"
#Advanced use case of multiple hosts - http://www.pcli.me/?p=25
#$hostnames = get-cluster mycluster | get-vmhost | %{$_.name}
#foreach($ahost in $hostnames){
#$one1 = $ahost.split(“.”)
#$two2 = $one1[0]
#$thename = $two2+”-local”
#get-vmhost $ahost | get-datastore | where {$_.name -match “datastore1″} | set-datastore -name $thename
#}


# Add host to VDS
Add-VDSwitchVMHost -VDSwitch VIO -VMHost $esx -RunAsync
$vmhostNetworkAdapter = $esx | Get-VMHostNetworkAdapter -Physical -Name vmnic1
$vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter

# Create NFS and vMotion VMKernels
New-VMHostNetworkAdapter -VMHost $esx -PortGroup "vStorage NFS" -VirtualSwitch $vds -IP 192.168.100.93 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost $esx -PortGroup "vMotion" -VirtualSwitch $vds -IP 192.168.101.93 -SubnetMask 255.255.255.0 -VMotionEnabled:$true

# Add NFS Storage
get-vmhost -Location Development | New-Datastore -NFS -Name OPSTK-1 -Path /OPSTK-1 -nfshost 192.168.100.242
get-vmhost -Location Development | New-Datastore -NFS -Name OPSTK-2 -Path /OPSTK-2 -nfshost 192.168.100.242
get-vmhost -Location Development | New-Datastore -NFS -Name OPSTK-3 -Path /OPSTK-3 -nfshost 192.168.100.242
get-vmhost -Location Development | New-Datastore -NFS -Name OPSTK-4 -Path /OPSTK-4 -nfshost 192.168.100.242
get-vmhost -Location Development | New-Datastore -NFS -Name OPSTK-5 -Path /OPSTK-5 -nfshost 192.168.100.243

#Verify that Tech Support Mode enabled
Get-VMHost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH" } |select VMHost, Label, Running

#Enable Tech Support Mode
Get-VMHost | Foreach {
  Start-VMHostService -HostService ($_ | Get-VMHostService | Where { $_.Key -eq "TSM-SSH"} )
}

Disconnect-ViServer -Confirm:$false