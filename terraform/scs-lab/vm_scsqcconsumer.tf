# variables
variable "scsqcconsumer" {
  default = {
    name     = "scsqcconsumer"
    az       = "server2"
    vcpus    = "3"
    ram      = "8"
    disk     = "100"
    fixed_ip = "192.168.12.18"
    image_id = "a232af7f-b3f5-400d-9d2f-e5987d19757e"
  }
}

resource "openstack_networking_port_v2" "port_scsqcconsumer" {
  name               = "${var.scsqcconsumer["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqcconsumer["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqcconsumer" {
  name  = "${var.scsqcconsumer["name"]}"
  ram   = "${var.scsqcconsumer["ram"] * 1024}"
  vcpus = "${var.scsqcconsumer["vcpus"]}"
  disk  = "${var.scsqcconsumer["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqcconsumer" {
  name              = "${var.scsqcconsumer["name"]}"
  availability_zone = "${var.scsqcconsumer["az"]}"
  image_id          = "${var.scsqcconsumer["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqcconsumer.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqcconsumer.id}"
  }
}
