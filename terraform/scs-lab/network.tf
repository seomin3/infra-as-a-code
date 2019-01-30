resource "openstack_networking_network_v2" "network_guest01" {
  name           = "guest01"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_guest01" {
  name       = "guest01"
  network_id = "${openstack_networking_network_v2.network_guest01.id}"
  cidr       = "172.16.1.0/24"
  no_gateway = "false"
  ip_version = 4
}
