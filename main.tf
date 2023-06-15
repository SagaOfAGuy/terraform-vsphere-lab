terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.3.1"
    }
  }
}

# Define Vsphere provider 
provider "vsphere" {
  user		 = var.vsphere_user
  password	 = var.vsphere_password
  vsphere_server = var.vsphere_host
  allow_unverified_ssl = true
}

# Create Datacenter
resource "vsphere_datacenter" "datacenter" {
	name = var.datacenter_name
}

# Create a Cluster inside of Datacenter
resource "vsphere_compute_cluster" "datastore_cluster" { 
	name = var.cluster_name
	datacenter_id = "${resource.vsphere_datacenter.datacenter.moid}"
	drs_enabled = true
	drs_automation_level = "fullyAutomated"
}

# Create thumbprint for ESXi host
data "vsphere_host_thumbprint" "thumbprint" { 
	address = var.esxi_hostname
	insecure=true
}

# Add ESXi host to cluster
resource "vsphere_host_ip" "esxi_host" { 
        force = true
	thumbprint = data.vsphere_host_thumbprint.thumbprint.id
	hostname=var.esxi_hostname
        username=var.esxi_username
        password=var.esxi_password
    	cluster = resource.vsphere_compute_cluster.datastore_cluster.id
}


# List available VMFS disks
data "vsphere_vmfs_disks" "available" {
	host_system_id = resource.vsphere_host.esxi_host.id
	rescan = true
	filter = var.disk_filter
}

# Add resource pool to cluster
resource "vsphere_resource_pool" "resource_pool" { 
	name = var.resource_pool
	parent_resource_pool_id = resource.vsphere_compute_cluster.datastore_cluster.resource_pool_id
}

resource "vsphere_vmfs_datastore" "datastore" {
	count = 0
	name = "test ${count.index}"
	host_system_id = resource.vsphere_host.esxi_host.id
	disks = [var.disk_extent_id]
	folder = "${var.datacenter_name}/datastore"
}