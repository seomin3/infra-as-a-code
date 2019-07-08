# variables
variable "vm_nomori_test" {
  default = {
    "name"    = "nomori-test"
    "az"      = "server02"
    "vcpus"   = "2"
    "ram"     = "8"
    "disk"    = "20"
  }
}

resource "openstack_networking_port_v2" "port_vm_nomori_test" {
  name               = "${var.vm_nomori_test["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

}

resource "openstack_compute_flavor_v2" "flavor_vm_nomori_test" {
  name  = "${var.vm_nomori_test["name"]}"
  ram   = "${var.vm_nomori_test["ram"] * 1024}"
  vcpus = "${var.vm_nomori_test["vcpus"]}"
  disk  = "${var.vm_nomori_test["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_nomori_test" {
  name              = "${var.vm_nomori_test["name"]}"
  availability_zone = "${var.vm_nomori_test["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_nomori_test.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_nomori_test.id}"
  }
  network {
    name = "database-net"
  }
  network {
    name = "service-net"
  }
  network {
    name = "mgmt-net"
  }
  network {
    name = "nfv-ipc-net"
  }
  network {
    name = "nfv-ext-net"
  }
}

