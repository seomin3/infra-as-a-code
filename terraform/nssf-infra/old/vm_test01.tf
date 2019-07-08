# variables
variable "vm_test1" {
  default = {
    "name"    = "test1"
    "az"      = "nova"
    "vcpus"   = "1"
    "ram"     = "1"
    "disk"    = "8"
    fixed_ip  = "192.168.11.240"
  }
}

resource "openstack_networking_port_v2" "port_vm_test1" {
  name               = "${var.vm_test1["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.vm_test1["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_test1" {
  name  = "${var.vm_test1["name"]}"
  ram   = "${var.vm_test1["ram"] * 1024}"
  vcpus = "${var.vm_test1["vcpus"]}"
  disk  = "${var.vm_test1["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_test1" {
  name              = "${var.vm_test1["name"]}"
  availability_zone = "${var.vm_test1["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_test1.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_test1.id}"
  }
  network {
    name = "database-net"
  }
  network {
    name = "service-net"
  }
}
