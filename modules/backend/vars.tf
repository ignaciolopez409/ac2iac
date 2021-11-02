variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "key_name" {
  type = string
}