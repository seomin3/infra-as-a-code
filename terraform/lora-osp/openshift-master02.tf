# variables
variable "vm_openshift-master02" {
  default = {
    "name"    = "openshift-master02"
    "az"      = "nova"
    "vcpus"   = "4"
    "ram"     = "16"
    "disk"    = "40"
  }
}

resource "openstack_compute_flavor_v2" "flavor_vm_openshift-master02" {
  name  = "${var.vm_openshift-master02["name"]}"
  ram   = "${var.vm_openshift-master02["ram"] * 1024}"
  vcpus = "${var.vm_openshift-master02["vcpus"]}"
  disk  = "${var.vm_openshift-master02["disk"]}"
}

resource "openstack_compute_instance_v2" "instance_vm_openshift-master02" {
  name              = "${var.vm_openshift-master02["name"]}"
  availability_zone = "${var.vm_openshift-master02["az"]}"
  image_id          = "${var.Instance["image_id"]}"
  flavor_id         = "${openstack_compute_flavor_v2.flavor_vm_openshift-master02.id}"
  key_pair          = "${var.Instance["key_pair"]}"
  security_groups   = [ "default", "openshift-firewall" ]
  user_data         = "${file("userdata.txt")}"
  config_drive      = "true"

  network {
    name = "${openstack_networking_network_v2.network_openshift-cp.name}"
  }
}

resource "openstack_networking_floatingip_v2" "fip_vm_openshift-master02" {
  pool = "${var.Network["ext_name"]}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_vm_openshift-master02" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_vm_openshift-master02.address}"
  instance_id = "${openstack_compute_instance_v2.instance_vm_openshift-master02.id}"
}
