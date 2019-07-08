# variables
variable "vm_nssf-ems02" {
  default = {
    "name"    = "nssf-ems02"
    "az"      = "server02"
    "vcpus"   = "4"
    "ram"     = "16"
    "disk"    = "64"
    fixed_ip  = "192.168.11.204"
  }
}

resource "openstack_networking_port_v2" "port_vm_nssf-ems02" {
  name               = "${var.vm_nssf-ems02["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.vm_nssf-ems02["fixed_ip"]}"
  }

  allowed_address_pairs {
    ip_address = "192.168.11.239"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_nssf-ems02" {
  name  = "${var.vm_nssf-ems02["name"]}"
  ram   = "${var.vm_nssf-ems02["ram"] * 1024}"
  vcpus = "${var.vm_nssf-ems02["vcpus"]}"
  disk  = "${var.vm_nssf-ems02["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_nssf-ems02" {
  name              = "${var.vm_nssf-ems02["name"]}"
  availability_zone = "${var.vm_nssf-ems02["az"]}"
  image_id          = "9ceff3eb-65ef-4bd8-a60e-9141dc6c7b50"  # nssf-ems01.190531
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_nssf-ems02.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_nssf-ems02.id}"
  }
}
