variable "vpc_name" {
  default = "huaweicloud_vpc"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "subnets" {
  type = list(
    name          = string
    cidr          = string
    gateway_ip    = string
    primary_dns   = string
    secondary_dns = string
  )
  default = []
}
