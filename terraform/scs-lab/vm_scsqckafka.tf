# variables
variable "scsqckafka" {
  default = {
    name     = "scsqckafka"
    az       = "server1"
    vcpus    = "6"
    ram      = "32"
    disk     = "800"
    fixed_ip = "192.168.12.14"
    image_id = "7089657a-6ab8-4e7a-856e-6a57af3cd0c0"
  }
}

resource "openstack_networking_port_v2" "port_scsqckafka" {
  name               = "${var.scsqckafka["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqckafka["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqckafka" {
  name  = "${var.scsqckafka["name"]}"
  ram   = "${var.scsqckafka["ram"] * 1024}"
  vcpus = "${var.scsqckafka["vcpus"]}"
  disk  = "${var.scsqckafka["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqckafka" {
  name              = "${var.scsqckafka["name"]}"
  availability_zone = "${var.scsqckafka["az"]}"
  image_id          = "${var.scsqckafka["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqckafka.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqckafka.id}"
  }
}
