# global variables
variable "Instance" {
  default = {
    image_id    = "4e586913-9176-4603-979a-d3cedbdb55c8"   # CentOS-7-x86_64-GenericCloud-1901
    key_pair    = "cobbler"
  }
}

variable "Network" {
  default = {
    ext_name    = "ext_net"
    ext_id      = "1330b6a2-c5ee-4f99-85cb-9db8662be1a5"
  }
}
