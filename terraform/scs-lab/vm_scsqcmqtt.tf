# variables
variable "scsqcmqtt" {
  default = {
    name     = "scsqcmqtt"
    az       = "server1"
    vcpus    = "4"
    ram      = "32"
    disk     = "500"
    fixed_ip = "192.168.12.16"
    image_id = "fcfa71de-d136-4e05-8a46-d395f6fd8584"
  }
}

resource "openstack_networking_port_v2" "port_scsqcmqtt" {
  name               = "${var.scsqcmqtt["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqcmqtt["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqcmqtt" {
  name  = "${var.scsqcmqtt["name"]}"
  ram   = "${var.scsqcmqtt["ram"] * 1024}"
  vcpus = "${var.scsqcmqtt["vcpus"]}"
  disk  = "${var.scsqcmqtt["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqcmqtt" {
  name              = "${var.scsqcmqtt["name"]}"
  availability_zone = "${var.scsqcmqtt["az"]}"
  image_id          = "${var.scsqcmqtt["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqcmqtt.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqcmqtt.id}"
  }
}
