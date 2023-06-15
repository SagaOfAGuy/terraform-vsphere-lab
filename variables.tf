variable "vsphere_user" {
    description = "vSphere Username"
    default = ""
}

variable "vsphere_password" {
  description = "vSphere password"
  default = ""
}

variable "vsphere_host_ip" {
  description = "vSphere (vCenter) Server IP"
  default = ""
}

variable "datacenter_name" { 
    description = "Datacenter name"
    default = ""
}

variable "datastore_name" { 
    description = "Datastore name"
    default = ""
}

variable "cluster_name" {
    description = "Compute Cluster name"
    default = ""
}

variable "esxi_hostname_ip" {
    description = "ESXi IP"
    default = ""
}

variable "esxi_username" {
    description = "ESXi username"
    default = ""
}

variable "esxi_password" {
    description = "ESXi password"
    sensitive = true
    default = ""
}

variable "resource_pool" {
  description = "Resource pool name"
  default = ""
}

variable "disk_filter" {
    description = "Disk filter value"
    default=""
}

variable "disk_extent_id" {
    description = "Disk Extent ID"
    default = ""
}