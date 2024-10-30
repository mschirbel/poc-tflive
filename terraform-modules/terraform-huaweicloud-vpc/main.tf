resource "huaweicloud_vpc" "vpc" {
  name = var.vpc_name
  cidr = var.vpc_cidr

  tags = {
    foo = "bar"
    key = "value"
  }
}

resource "huaweicloud_vpc_subnet" "mysubnet" {
  for_each = var.subnet_cidr
  name       = each.name
  cidr       = each.cidr
  gateway_ip = each.gateway_ip

  //dns is required for cce node installing
  primary_dns   = each.primary_dns
  secondary_dns = each.secondary_dns
  vpc_id        = huaweicloud_vpc.myvpc.id
}