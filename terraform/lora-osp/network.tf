resource "openstack_networking_network_v2" "network_openshift-cp" {
  name           = "openshift-cp"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_openshift-cp" {
  name       = "openshift-cp"
  network_id = "${openstack_networking_network_v2.network_openshift-cp.id}"
  cidr       = "172.16.45.0/24"
  no_gateway = "false"
  ip_version = 4
  dns_nameservers = [ "1.1.1.1", "1.0.0.1" ]
}

resource "openstack_networking_router_v2" "router_openshift-cp" {
  name                = "openshift-cp"
  external_network_id = "${var.Network["ext_id"]}"
}

resource "openstack_networking_router_interface_v2" "router_interface_openshift-cp" {
  router_id = "${openstack_networking_router_v2.router_openshift-cp.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_openshift-cp.id}"
}
