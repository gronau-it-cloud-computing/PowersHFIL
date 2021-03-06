# Import Modules
if ((Get-Module |where {$_.Name -ilike "CiscoUcsPS"}).Name -ine "CiscoUcsPS")
	{
	Write-Host "Loading Module: Cisco UCS PowerTool Module"
	Import-Module CiscoUcsPs
	}

if ((Get-PSSnapin | where {$_.Name -ilike "Vmware*Core"}).Name -ine "VMware.VimAutomation.Core")
	{
	Write-Host "Loading PS Snap-in: VMware VimAutomation Core"
	Add-PSSnapin VMware.VimAutomation.Core -ErrorAction SilentlyContinue
	}



$server = get-vmhost -name "san-cc2-blade24.san-dc1-core.cscehub.com"
$vS0 = Get-VirtualSwitch -VMHost $server -Standard -Name vSwitch0
Get-VMHostNetworkAdapter -VMHost $server -
Remove-VMHostNetworkAdapter

