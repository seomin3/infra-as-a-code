# variables
variable "scsqcnoti" {
  default = {
    name     = "scsqcnoti"
    az       = "server2"
    vcpus    = "4"
    ram      = "8"
    disk     = "100"
    fixed_ip = "192.168.12.19"
    image_id = "7b814363-10e2-4459-ba2d-58c268212210"
  }
}

resource "openstack_networking_port_v2" "port_scsqcnoti" {
  name               = "${var.scsqcnoti["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqcnoti["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqcnoti" {
  name  = "${var.scsqcnoti["name"]}"
  ram   = "${var.scsqcnoti["ram"] * 1024}"
  vcpus = "${var.scsqcnoti["vcpus"]}"
  disk  = "${var.scsqcnoti["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqcnoti" {
  name              = "${var.scsqcnoti["name"]}"
  availability_zone = "${var.scsqcnoti["az"]}"
  image_id          = "${var.scsqcnoti["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqcnoti.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqcnoti.id}"
  }
}
