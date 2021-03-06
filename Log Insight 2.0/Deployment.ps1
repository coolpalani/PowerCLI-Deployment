# Load OVF/OVA configuration into a variable
$ovffile = "C:\Software\VMware-vCenter-Log-Insight-2.0.3-1879692_1.ova"
$ovfconfig = Get-OvfConfiguration $ovffile

# Get the values to use for deployment
$VMHost = Get-Cluster "Cluster Site A" | Get-VMHost | Sort MemoryGB | Select -first 1
$Datastore = $VMHost | Get-datastore | Sort FreeSpaceGB -Descending | Select -first 1
$Network = Get-VirtualPortGroup -Name "VM Network" -VMHost $vmhost

# Fill out the OVF/OVA configuration parameters
$ovfconfig.DeploymentOption.Value = "xsmall"
$ovfconfig.NetworkMapping.Network_1.Value = $Network
$ovfconfig.IpAssignment.IpProtocol.value = "IPv4"
$ovfconfig.vami.VMware_vCenter_Log_Insight.hostname.Value = "LI01"
$ovfconfig.vm.rootpw.Value = "VMware1!"

# Deploy the OVF/OVA with the config parameters
Import-VApp -Source $ovffile -OvfConfiguration $ovfconfig -Name "LI01" -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin