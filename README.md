# terraform-vsphere-lab
Terraform script for creating basic infrastructure for vSphere homelab

# Usage
1. Clone this repo
```bash
git clone https://github.com/SagaOfAGuy/terraform-vsphere-lab.git
```
2. Browse to this repo's folder
```bash
cd terraform-vsphere-lab
```
3. Configure infrastructure references and credentials in `variables.tf`
4. To find the `filter` and `disks` values for the `vsphere_vmfs_disks` and the `vsphere_vmfs_datastore` resources, follow the steps below: 
   - Navigate to the ESXi host hosting the vSphere client
   - Click on the storage device on the left hand side of the navigation screen. In our case, this would be `DS3` 
   - After clicking on `DS3`, take note of the `Extent 0` value highlighted in red
   - For the `filter` field of `vsphere_vmfs_disks` resource set it to `naa.xxxxxxxx` with the first 8 numbers following `naa`. In our case, this is `na.61418770` 
   -  For the `disks` field of the `vsphere_vmfs_datastore` resource, paste the entire `naa` extent ID. In our case, this would be `naa.6141877044d509002b8a7c1d06c4214c`
   
5. Apply terraform script to the vSphere environment
```bash
terraform apply
```
6.  To destroy the infrastructure, simply destroy via `terraform`
```bash
terraform destroy
```
7.  Observe the created infrastructure in vSphere client


## Reference to Resources

### VMFS Disks Resource
```bash
# List available VMFS disks
data "vsphere_vmfs_disks" "available" {
	host_system_id = resource.vsphere_host.esxi_host.id
	rescan = true
	filter = "naa.61418770"
}
```

### VMFS Datastore Resource
```bash
# VMFS Datastore
resource "vsphere_vmfs_datastore" "datastore" {
	count = 0
	name = "test ${count.index}"
	host_system_id = resource.vsphere_host.esxi_host.id
	disks = ["naa.6141877044d509002b8a7c1d06c4214c"]
	folder = "/DC1/datastore"
}
```

