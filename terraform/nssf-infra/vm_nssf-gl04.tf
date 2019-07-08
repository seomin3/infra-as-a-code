# variables
variable "vm_nssf-gl04" {
  default = {
    "name"    = "nssf-gl04"
    "az"      = "nova"
    "vcpus"   = "4"
    "ram"     = "16"
    "disk"    = "32"
    fixed_ip  = "192.168.11.216"
  }
}

resource "openstack_networking_port_v2" "port_vm_nssf-gl04" {
  name               = "${var.vm_nssf-gl04["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.vm_nssf-gl04["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_nssf-gl04" {
  name  = "${var.vm_nssf-gl04["name"]}"
  ram   = "${var.vm_nssf-gl04["ram"] * 1024}"
  vcpus = "${var.vm_nssf-gl04["vcpus"]}"
  disk  = "${var.vm_nssf-gl04["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_nssf-gl04" {
  name              = "${var.vm_nssf-gl04["name"]}"
  availability_zone = "${var.vm_nssf-gl04["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_nssf-gl04.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_nssf-gl04.id}"
  }
}
