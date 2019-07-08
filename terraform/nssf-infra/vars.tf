# global variables
variable "Instance" {
  default = {
    image_id    = "4aae9086-15f1-45b1-9474-18200947eb62"   # CentOS-7-x86_64-GenericCloud-1901
    key_pair    = "stack"
  }
}

variable "Network" {
  default = {
    ext_name   = "management"
    network_id = "c7eb055a-1941-4851-8525-b18ebad9f4f6"
    subnet_id  = "4b0fe31a-3e75-469c-add5-8d4b61bdfa18"
  }
}
