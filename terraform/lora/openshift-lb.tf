# variables
variable "vm_openshift-lb" {
  default = {
    "name"    = "openshift-lb"
    "az"      = "nova"
    "vcpus"   = "4"
    "ram"     = "16"
    "disk"    = "20"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_openshift-lb" {
  name  = "${var.vm_openshift-lb["name"]}"
  ram   = "${var.vm_openshift-lb["ram"] * 1024}"
  vcpus = "${var.vm_openshift-lb["vcpus"]}"
  disk  = "${var.vm_openshift-lb["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_openshift-lb" {
  name              = "${var.vm_openshift-lb["name"]}"
  availability_zone = "${var.vm_openshift-lb["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_openshift-lb.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default", "openshift-firewall" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"

  network {
    name = "${openstack_networking_network_v2.network_openshift-cp.name}"
  }
}

resource "openstack_networking_floatingip_v2" "fip_vm_openshift-lb" {
  pool = "${var.Network["ext_name"]}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_vm_openshift-lb" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_vm_openshift-lb.address}"
  instance_id = "${openstack_compute_instance_v2.instance_vm_openshift-lb.id}"
}
