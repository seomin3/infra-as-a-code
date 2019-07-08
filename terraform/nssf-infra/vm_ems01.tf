# variables
variable "ems01" {
  default = {
    "name"    = "ems01"
    "az"      = "server01"
    "vcpus"   = "4"
    "ram"     = "16"
    "disk"    = "64"
    fixed_ip  = "192.168.11.233"
  }
}

resource "openstack_networking_port_v2" "port_ems01" {
  name               = "${var.ems01["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.ems01["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_ems01" {
  name  = "${var.ems01["name"]}"
  ram   = "${var.ems01["ram"] * 1024}"
  vcpus = "${var.ems01["vcpus"]}"
  disk  = "${var.ems01["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_ems01" {
  name              = "${var.ems01["name"]}"
  availability_zone = "${var.ems01["az"]}"
  image_id          = "9ceff3eb-65ef-4bd8-a60e-9141dc6c7b50"  # nssf-ems01.190531
  flavor_id         = "${openstack_compute_flavor_v2.flavor_ems01.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_ems01.id}"
  }
}
