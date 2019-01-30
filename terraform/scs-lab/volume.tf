resource "openstack_blockstorage_volume_v3" "volume_1" {
  region      = "RegionOne"
  name        = "volume_1"
  size        = 2
}
