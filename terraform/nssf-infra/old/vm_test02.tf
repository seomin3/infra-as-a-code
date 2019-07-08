# variables
variable "vm_test02" {
  default = {
    "name"    = "test02"
    "az"      = "server04"
    "vcpus"   = "4"
    "ram"     = "4"
    "disk"    = "22"
    fixed_ip  = "192.168.11.228"
  }
}

resource "openstack_networking_port_v2" "port_vm_test02" {
  name               = "${var.vm_test02["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.vm_test02["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_test02" {
  name  = "${var.vm_test02["name"]}"
  ram   = "${var.vm_test02["ram"] * 1024}"
  vcpus = "${var.vm_test02["vcpus"]}"
  disk  = "${var.vm_test02["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_test02" {
  name              = "${var.vm_test02["name"]}"
  availability_zone = "${var.vm_test02["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_test02.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_test02.id}"
  }
  network {
    name = "service-net"
  }
  network {
    name = "database-net"
  }
}
