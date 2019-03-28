# global variables
variable "Instance" {
  default = {
    image_id    = "f7e51a9e-4fa3-4de0-bed7-6ebc61505c43"   # CentOS-7-x86_64-GenericCloud-1707
    key_pair    = "stack"
  }
}

variable "Network" {
  default = {
    ext_name    = "ext_net"
    ext_id      = "1330b6a2-c5ee-4f99-85cb-9db8662be1a5"
  }
}
