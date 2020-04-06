# variables
variable "vm_sim1" {
  default = {
    "name"    = "sim1"
    "az"      = "nova"
    "vcpus"   = "4"
    "ram"     = "8"
    "disk"    = "20"
    fixed_ip  = "192.168.11.235"
  }
}

resource "openstack_networking_port_v2" "port_vm_sim1" {
  name               = "${var.vm_sim1["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.vm_sim1["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_sim1" {
  name  = "${var.vm_sim1["name"]}"
  ram   = "${var.vm_sim1["ram"] * 1024}"
  vcpus = "${var.vm_sim1["vcpus"]}"
  disk  = "${var.vm_sim1["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_sim1" {
  name              = "${var.vm_sim1["name"]}"
  availability_zone = "${var.vm_sim1["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_sim1.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_sim1.id}"
  }
  network {
    name = "database-net"
  }
  network {
    name = "service-net"
  }
}