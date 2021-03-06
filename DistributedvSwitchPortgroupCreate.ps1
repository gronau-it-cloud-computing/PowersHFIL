# Import Modules

#if ((Get-PSSnapin | where {$_.Name -ilike "Vmware*Core"}).Name -ine "VMware.VimAutomation.Core")
#	{
#	Write-Host "Loading PS Snap-in: VMware VimAutomation Core"
#	Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue
#	}

# Global Variables
$vCenter = "prme-haas-2-vio-vcenter"
$vcuser = "administrator@vsphere.local"
$vcpass = "VMware1!"
$WarningPreference = "SilentlyContinue"

# Login to vCenter
Write-Host "vC: Logging into vCenter: $vCenter"
$vcenterlogin = Connect-VIServer $vCenter -User $vcuser -Password $vcpass | Out-Null



New-VMHostNetworkAdapter -VMHost "<HOST>" -PortGroup "<PORTGROUP>" -VirtualSwitch "dvSwitch Lab" -IP <IP> -SubnetMask <MASK> -VMotionEnabled:$true

# Source: https://dthomo.wordpress.com/2013/07/19/create-a-csv-of-port-group-names-and-vlan-ids-for-both-standard-and-distributed-vswitches/
foreach ($pg in get-vdportgroup | where {$_.Name -ilike "Management*"} | Where { $_.Name -NotMatch “-Uplinks” }) {
$pg.Name
$pg.ExtensionData.Config.DefaultPortConfig.Vlan.VlanId
}

#Management External API
#964
#Management Floating IP
#974
#Management vMotion
#3101
#Management NFS
#3100

$myvds = Get-VDSwitch | Where-Object {$_.Name -ilike "*Edge*"}

New-VDPortgroup -VDSwitch $myvds -Name "Management External API" -VlanId 964
New-VDPortgroup -VDSwitch $myvds -Name "Management Floating IP" -VlanId 974
New-VDPortgroup -VDSwitch $myvds -Name "Management vMotion" -VlanId 3101
New-VDPortgroup -VDSwitch $myvds -Name "Management NFS" -VlanId 3100
New-VDPortgroup -VDSwitch $myvds -Name "Management Management" -VlanId 2248


#Create vmkernel ports
#Source http://www.virten.net/vmware/powercli-snippets/
NFS: 192.168.100
vMo: 192.168.101

New-VMHostNetworkAdapter -VMHost "prme-haas-esx095.eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.95 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost "prme-haas-esx095.eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.95 -SubnetMask 255.255.255.0 -VMotionEnabled:$true
New-VMHostNetworkAdapter -VMHost "prme-haas-esx096.eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.96 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost "prme-haas-esx096.eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.96 -SubnetMask 255.255.255.0 -VMotionEnabled:$true
New-VMHostNetworkAdapter -VMHost "prme-haas-esx097.eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.97 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost "prme-haas-esx097.eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.97 -SubnetMask 255.255.255.0 -VMotionEnabled:$true
New-VMHostNetworkAdapter -VMHost "prme-haas-esx098.eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.98 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost "prme-haas-esx098.eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.98 -SubnetMask 255.255.255.0 -VMotionEnabled:$true
New-VMHostNetworkAdapter -VMHost "prme-haas-esx099.eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.99 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost "prme-haas-esx099.eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.99 -SubnetMask 255.255.255.0 -VMotionEnabled:$true
New-VMHostNetworkAdapter -VMHost "prme-haas-esx100.eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.100 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost "prme-haas-esx100.eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.100 -SubnetMask 255.255.255.0 -VMotionEnabled:$true
New-VMHostNetworkAdapter -VMHost "prme-haas-esx101.eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.101 -SubnetMask 255.255.255.0
New-VMHostNetworkAdapter -VMHost "prme-haas-esx101.eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.101 -SubnetMask 255.255.255.0 -VMotionEnabled:$true

#Scrap

#$counter = 96
#$lc=96..101 | foreach {$_} {
#New-VMHostNetworkAdapter -VMHost "prme-haas-esx"$_".eng.vmware.com" -PortGroup "Management NFS" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.100.$_ -SubnetMask 255.255.255.0
#New-VMHostNetworkAdapter -VMHost "prme-haas-esx"$_".eng.vmware.com" -PortGroup "Management vMotion" -VirtualSwitch "Management_Edge_Compute" -IP 192.168.101.$_ -SubnetMask 255.255.255.0 -VMotionEnabled:$true
#}




# Logout of vCenter
Write-Host "vC: Logging out of vCenter: $vCenter"
$vcenterlogout = Disconnect-VIServer $vCenter -Confirm:$false