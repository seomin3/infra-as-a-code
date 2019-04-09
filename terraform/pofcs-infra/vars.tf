# global variables
variable "Instance" {
  default = {
    image_id    = "4aae9086-15f1-45b1-9474-18200947eb62"   # CentOS-7-x86_64-GenericCloud-1901
    key_pair    = "stack"
  }
}

variable "Network" {
  default = {
    ext_name    = "public"
    ext_net_id  = "70f4cb52-7305-484d-9f71-e4d51f689e14"
    ext_sub_id  = "18bd6040-7f31-4c8e-88e2-c77c33ae99ee"
  }
}
