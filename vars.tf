variable "vpc_cidr" {
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

variable "ssh_port" {
  type = number
  default = 22
}

variable "http_port" {
  type = number
  default = 80
}

variable "application_port" {
  type = number
  default = 8080
}

variable "database_port" {
  type = number
  default = 3306
}

variable "ec2_key_pair" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIr7wZAC7Ui1izn2UC6rxNn6kRk3XzGCC9CNHveZGJ8+Z3ZTAeTEsV3GenN3YlWawYR/htc2VLNe/mgt12br0Lxy66MgJCJZWXh1m2wEK+RJUN+eQvTR6A29cCp3kz3kbg+Pb7MOfGhmXYfefgDPIQH68cNIUvHu9UFzAGtFE480w/Nw/na0hY/2V12bO5Qm5JPpVALrCs31+EvYzsyQIhuWeg63gXTbq+AlpDXtcQxtMS1xBsxmPvR3vm60ujihYuBbqb+QJ4JNxtIPtAXnkVQuIfUoU7eZ1UObht937xQjnEoeqPPzZ9m0iC6GEvLAV9UDAZkrmpMI2mWTayNRw/ root@Devops01"
}

variable "ami_id" {
  type = string
  default = "ami-01cc34ab2709337aa"
}