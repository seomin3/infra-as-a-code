resource "openstack_networking_network_v2" "network_private" {
  name           = "private"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_private" {
  name       = "private"
  network_id = "${openstack_networking_network_v2.network_private.id}"
  cidr       = "172.16.45.0/24"
  no_gateway = "false"
  ip_version = 4
}

resource "openstack_networking_router_v2" "router_private" {
  name                = "private"
  external_network_id = "${var.Network["ext_net_id"]}"
  external_fixed_ip {
    subnet_id  = "${var.Network["ext_sub_id"]}"
    ip_address = "192.168.11.200"
  }
}

resource "openstack_networking_router_interface_v2" "router_interface_private" {
  router_id = "${openstack_networking_router_v2.router_private.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_private.id}"
}
