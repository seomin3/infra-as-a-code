# global variables
variable "Instance" {
  default = {
    lb_image_id = "0bf25a77-1981-4e04-a65e-882d7255170c"
    key_pair    = "packstack"
  }
}

variable "network" {
  default = {
    id          = "da858e28-98b9-4b5f-a63c-25bf64529521"
    subnet_id   = "a1ac164b-e80c-4898-9146-f03817da5c72"
    secgroup_id = "9643e3f1-3b1b-40d3-8a82-40794abba30a"
  }
}
