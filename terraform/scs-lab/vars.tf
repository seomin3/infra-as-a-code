# global variables
variable "Instance" {
  default = {
    image_id      = "e78eb83e-0df2-4d04-91d1-ce2dc90b84ef"
    lb_image_id   = "0bf25a77-1981-4e04-a65e-882d7255170c"
    key_pair      = "packstack"
  }
}

variable "network" {
  default = {
    id          = "673f7841-91f8-46f9-96fb-f051908bfb01"
    subnet_id   = "46b78aaa-1c79-4f9e-94c8-b1cb2c4470a6"
    secgroup_id = "e30480ee-dbad-4dbf-905e-1093a6554d7a "
  }
}
