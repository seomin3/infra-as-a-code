resource "openstack_networking_network_v2" "network_si-cp" {
  name           = "si-cp"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_si-cp" {
  name       = "si-cp"
  network_id = "${openstack_networking_network_v2.network_si-cp.id}"
  cidr       = "10.10.32.0/24"
  no_gateway = "false"
  ip_version = 4
  dns_nameservers = [ "1.1.1.1", "1.0.0.1" ]
}

resource "openstack_networking_router_v2" "router_si-cp" {
  name                = "si-cp"
  external_network_id = "${var.Network["ext_id"]}"
}

resource "openstack_networking_router_interface_v2" "router_interface_si-cp" {
  router_id = "${openstack_networking_router_v2.router_si-cp.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_si-cp.id}"
}
