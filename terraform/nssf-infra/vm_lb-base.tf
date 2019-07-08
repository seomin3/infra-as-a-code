# variables
variable "vm_lb-base" {
  default = {
    "name"    = "lb-base"
    "az"      = "nova"
    "vcpus"   = "2"
    "ram"     = "4"
    "disk"    = "20"
    fixed_ip  = "192.168.11.232"
  }
}

resource "openstack_networking_port_v2" "port_vm_lb-base" {
  name               = "${var.vm_lb-base["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.vm_lb-base["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_lb-base" {
  name  = "${var.vm_lb-base["name"]}"
  ram   = "${var.vm_lb-base["ram"] * 1024}"
  vcpus = "${var.vm_lb-base["vcpus"]}"
  disk  = "${var.vm_lb-base["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_lb-base" {
  name              = "${var.vm_lb-base["name"]}"
  availability_zone = "${var.vm_lb-base["az"]}"
  image_id          = "4dab387d-236f-4138-9b2e-01e394c8c7b0"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_lb-base.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_lb-base.id}"
  }
}
