# variables
variable "vm_db-base" {
  default = {
    "name"    = "db-base"
    "az"      = "nova"
    "vcpus"   = "2"
    "ram"     = "4"
    "disk"    = "20"
    fixed_ip  = "192.168.11.234"
  }
}

resource "openstack_networking_port_v2" "port_vm_db-base" {
  name               = "${var.vm_db-base["name"]}"
  network_id         = "${var.Network["network_id"]}"
  admin_state_up     = "true"

  fixed_ip {
    "subnet_id"  = "${var.Network["subnet_id"]}"
    "ip_address" = "${var.vm_db-base["fixed_ip"]}"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_db-base" {
  name  = "${var.vm_db-base["name"]}"
  ram   = "${var.vm_db-base["ram"] * 1024}"
  vcpus = "${var.vm_db-base["vcpus"]}"
  disk  = "${var.vm_db-base["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_db-base" {
  name              = "${var.vm_db-base["name"]}"
  availability_zone = "${var.vm_db-base["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_db-base.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata-nssf.txt")}"
  config_drive      = "true"

  network {
    port = "${openstack_networking_port_v2.port_vm_db-base.id}"
  }
}
