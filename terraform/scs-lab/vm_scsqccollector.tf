# variables
variable "scsqccollector" {
  default = {
    name     = "scsqccollector"
    az       = "server2"
    vcpus    = "3"
    ram      = "8"
    disk     = "100"
    fixed_ip = "192.168.12.17"
    image_id = "9618eb67-5460-496d-8d95-82958873bf69"
  }
}

resource "openstack_networking_port_v2" "port_scsqccollector" {
  name               = "${var.scsqccollector["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqccollector["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqccollector" {
  name  = "${var.scsqccollector["name"]}"
  ram   = "${var.scsqccollector["ram"] * 1024}"
  vcpus = "${var.scsqccollector["vcpus"]}"
  disk  = "${var.scsqccollector["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqccollector" {
  name              = "${var.scsqccollector["name"]}"
  availability_zone = "${var.scsqccollector["az"]}"
  image_id          = "${var.scsqccollector["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqccollector.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqccollector.id}"
  }
}
