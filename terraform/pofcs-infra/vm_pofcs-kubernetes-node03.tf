# variables
variable "vm_pofcs-kubernetes-node03" {
  default = {
    "name"    = "pofcs-kubernetes-node03"
    "az"      = "server01"
    "vcpus"   = "20"
    "ram"     = "62"
    "disk"    = "980"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_pofcs-kubernetes-node03" {
  name  = "${var.vm_pofcs-kubernetes-node03["name"]}"
  ram   = "${var.vm_pofcs-kubernetes-node03["ram"] * 1024}"
  vcpus = "${var.vm_pofcs-kubernetes-node03["vcpus"]}"
  disk  = "${var.vm_pofcs-kubernetes-node03["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_pofcs-kubernetes-node03" {
  name              = "${var.vm_pofcs-kubernetes-node03["name"]}"
  availability_zone = "${var.vm_pofcs-kubernetes-node03["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_pofcs-kubernetes-node03.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"

  network {
    name = "${openstack_networking_network_v2.network_private.name}"
  }
}

resource "openstack_networking_floatingip_v2" "fip_vm_pofcs-kubernetes-node03" {
  address = "192.168.11.203"
  pool    = "${var.Network["ext_name"]}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_vm_pofcs-kubernetes-node03" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_vm_pofcs-kubernetes-node03.address}"
  instance_id = "${openstack_compute_instance_v2.instance_vm_pofcs-kubernetes-node03.id}"
}
