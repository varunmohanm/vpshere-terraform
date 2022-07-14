data "vsphere_datacenter" "dc" {
  name = "pcc-149-202-254-29_datacenter2863-AG"
}

data "vsphere_datastore" "datastore" {
  name          = "pcc-005268"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Cluster1/Varun"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "public"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  ovf_deploy {
    allow_unverified_ssl_cert = false
    remote_ovf_url            = "https://templatefactory.rbx2b.pcc.ovh.net/Linux/Ubuntu_1804/Ubuntu_1804.ovf"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "STATIC_MANUAL"

    }
  }

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }