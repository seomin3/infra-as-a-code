# variables
variable "scsqchaproxy" {
  default = {
    name     = "scsqchaproxy"
    az       = "server2"
    vcpus    = "4"
    ram      = "8"
    disk     = "100"
    fixed_ip = "192.168.12.20"
    image_id = "4f424815-a2a4-48bb-abe6-c2cd5692f42c"
  }
}

resource "openstack_networking_port_v2" "port_scsqchaproxy" {
  name               = "${var.scsqchaproxy["name"]}"
  network_id         = "${var.network["id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.network["subnet_id"]}"
    "ip_address" = "${var.scsqchaproxy["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_scsqchaproxy" {
  name  = "${var.scsqchaproxy["name"]}"
  ram   = "${var.scsqchaproxy["ram"] * 1024}"
  vcpus = "${var.scsqchaproxy["vcpus"]}"
  disk  = "${var.scsqchaproxy["disk"]}"
}

resource "openstack_compute_instance_v2" "vm_scsqchaproxy" {
  name              = "${var.scsqchaproxy["name"]}"
  availability_zone = "${var.scsqchaproxy["az"]}"
  image_id          = "${var.scsqchaproxy["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_scsqchaproxy.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"
  network {
    port = "${openstack_networking_port_v2.port_scsqchaproxy.id}"
  }
}
