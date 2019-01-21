# variables
variable "scsqcportal" {
  default = {
    name     = "scsqcportal"
    az       = "server2"
    vcpus    = "2"
    ram      = "8"
    disk     = "100"
    fixed_ip = "192.168.12.21"
    image_id = "e6a4f2e6-066b-4446-b290-a8ff76d55ae9"
  }
}

resource "openstack_networking_port_v2" "port_scsqcportal" {
  name               = "${var.scsqcportal["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqcportal["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqcportal" {
  name  = "${var.scsqcportal["name"]}"
  ram   = "${var.scsqcportal["ram"] * 1024}"
  vcpus = "${var.scsqcportal["vcpus"]}"
  disk  = "${var.scsqcportal["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqcportal" {
  name              = "${var.scsqcportal["name"]}"
  availability_zone = "${var.scsqcportal["az"]}"
  image_id          = "${var.scsqcportal["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqcportal.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqcportal.id}"
  }
}
