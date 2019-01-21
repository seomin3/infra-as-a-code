# variables
variable "scsqcredis" {
  default = {
    name     = "scsqcredis"
    az       = "server1"
    vcpus    = "6"
    ram      = "32"
    disk     = "300"
    fixed_ip = "192.168.12.15"
    image_id = "52e11d45-e7bc-4370-8272-e06a886bffd8"
  }
}

resource "openstack_networking_port_v2" "port_scsqcredis" {
  name               = "${var.scsqcredis["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqcredis["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqcredis" {
  name  = "${var.scsqcredis["name"]}"
  ram   = "${var.scsqcredis["ram"] * 1024}"
  vcpus = "${var.scsqcredis["vcpus"]}"
  disk  = "${var.scsqcredis["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqcredis" {
  name              = "${var.scsqcredis["name"]}"
  availability_zone = "${var.scsqcredis["az"]}"
  image_id          = "${var.scsqcredis["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqcredis.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqcredis.id}"
  }
}
