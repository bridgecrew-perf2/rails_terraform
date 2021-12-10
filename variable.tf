variable "aws_region" {
  default = "ap-northeast-1"
}
variable "root_domain" {
  default = "ymnk.work"
}
variable "r_prefix" {
  default = "pragmatic"
}
variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}
variable "cidr_block" {
  default = "10.0.0.0/21"
}

variable "az" {
  type    = list(string)
  default = ["1a", "1c"]
}