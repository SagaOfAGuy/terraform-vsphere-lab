# terraform-vsphere-lab
Terraform script for creating basic infrastructure for vSphere homelab

# Configure Resources
1. Clone this repo
```bash
git clone https://github.com/SagaOfAGuy/terraform-vsphere-lab.git
```
2. Browse to this repo's folder
```bash
cd terraform-vsphere-lab
```
3. Configure infrastructure references and credentials in `variables.tf`

4. To find the `filter` and `disks` values for the `vsphere_vmfs_disks` and the `vsphere_vmfs_datastore` resources, follow the steps below.

5. Navigate to the ESXi host hosting the vSphere client:
   
![image](https://github.com/SagaOfAGuy/terraform-vsphere-lab/assets/68156940/e85caa31-bf64-4f09-ba45-7a42b7254e7a)

6. Click on the storage device on the left hand side of the navigation screen. In our case, this would be `DS3` which is boxed in red in the screenshot below:
   
![image](https://github.com/SagaOfAGuy/terraform-vsphere-lab/assets/68156940/70a5116a-1919-44c6-ae71-ea4a77cb1484)

7. After clicking on `DS3`, take note of the `Extent 0` value highlighted in red

![image](https://github.com/SagaOfAGuy/terraform-vsphere-lab/assets/68156940/02735f19-8dc0-4cc9-9538-01380867eee3)

8. For the `filter` field of `vsphere_vmfs_disks` resource set it to `naa.xxxxxxxx` with the first 8 numbers following `naa`. In our case, this is `na.61418770` 

9. For the `disks` field of the `vsphere_vmfs_datastore` resource, paste the entire `naa` extent ID. In our case, this would be `naa.6141877044d509002b8a7c1d06c4214c`

10. Apply terraform script to the vSphere environment
```bash
terraform apply
```

12. Observe the created infrastructure in vSphere client

# Destroy Resources
To destroy the lab, run the following `terraform` command: 
```bash
terraform destroy
```

# Reference to Resources

### VMFS Disks Resource `vsphere_vmfs_disks`
```bash
# List available VMFS disks
data "vsphere_vmfs_disks" "available" {
	host_system_id = resource.vsphere_host.esxi_host.id
	rescan = true
	filter = "naa.61418770"
}
```

### VMFS Datastore Resource `vsphere_vmfs_datastore`
```bash
# VMFS Datastore
resource "vsphere_vmfs_datastore" "datastore" {
	count = 0
	name = "test ${count.index}"
	host_system_id = resource.vsphere_host.esxi_host.id
	disks = ["naa.6141877044d509002b8a7c1d06c4214c"]
	folder = "/${var.disk_extent_id}/datastore"
}
```
