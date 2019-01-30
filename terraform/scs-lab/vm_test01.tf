# variables
variable "vm_test01" {
  default = {
    "name"    = "test01"
    "az"      = "server1"
    "vcpus"   = "1"
    "ram"     = "1"
    "disk"    = "10"
    "fixed_ip" = "192.168.5.51"
  }
}

#resource "openstack_networking_port_v2" "port_vm_test01" {
#  name               = "${var.vm_test01["name"]}"
#  network_id         = "${var.network["id"]}"
#  admin_state_up     = "true"
#
#  fixed_ip {
#    "subnet_id"  = "${var.network["subnet_id"]}"
#    "ip_address" = "${var.vm_test01["fixed_ip"]}"
#  }
#}

resource "openstack_compute_flavor_v2" "flavor_vm_test01" {
  name  = "${var.vm_test01["name"]}"
  ram   = "${var.vm_test01["ram"] * 1024}"
  vcpus = "${var.vm_test01["vcpus"]}"
  disk  = "${var.vm_test01["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_test01" {
  name              = "${var.vm_test01["name"]}"
  availability_zone = "${var.vm_test01["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_test01.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"

#  network {
#    port = "${openstack_networking_port_v2.port_vm_test01.id}"
#  }
  network {
    name = "guest01"
  }
}
