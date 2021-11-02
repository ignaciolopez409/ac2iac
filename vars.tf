variable "vpc_cidr"{
  type = string
  default = "10.0.0.0/16"
}

variable "front_cdir" {
  type = string
  default = "10.0.1.0/24"
}

variable "back_cdir" {
  type = string
  default = "10.0.2.0/24"
}

variable "db_cdir" {
  type = string
  default = "10.0.3.0/24"
}

variable "ac2iac_rt_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}