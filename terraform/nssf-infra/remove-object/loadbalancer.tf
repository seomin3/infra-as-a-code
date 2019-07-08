# lbaas

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "${var.Network["ext_name"]}"
}

resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  port_id     = "${openstack_lb_loadbalancer_v2.lb_1.vip_port_id}"
}

resource "openstack_lb_loadbalancer_v2" "lb_1" {
  vip_subnet_id = "${openstack_networking_subnet_v2.subnet_private.id}"
}

resource "openstack_lb_listener_v2" "listener_1" {
  protocol        = "HTTP"
  protocol_port   = 8080
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.lb_1.id}"
}

resource "openstack_lb_pool_v2" "pool_1" {
  name        = "pool_1"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.listener_1.id}"

  persistence {
    type        = "HTTP_COOKIE"
  }
}

resource "openstack_lb_member_v2" "member_1" {
  address       = "${openstack_compute_instance_v2.instance_vm_pofcs-kubernetes-node01.access_ip_v4}"
  subnet_id     = "${openstack_networking_subnet_v2.subnet_private.id}"
  protocol_port = 8080
  pool_id       = "${openstack_lb_pool_v2.pool_1.id}"
}

resource "openstack_lb_member_v2" "member_2" {
  address       = "${openstack_compute_instance_v2.instance_vm_pofcs-kubernetes-node02.access_ip_v4}"
  subnet_id     = "${openstack_networking_subnet_v2.subnet_private.id}"
  protocol_port = 8080
  pool_id       = "${openstack_lb_pool_v2.pool_1.id}"
}
