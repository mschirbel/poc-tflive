# Include core configuration in root
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  region_vars = find_in_parent_folders("region.hcl")
  account_vars = find_in_parent_folders("account.hcl")
  env_vars = find_in_parent_folders("env.hcl")
}

terraform {
  source = "https://github.com/empresamaneira/terraform-modules.git//hc_vpc?version=1.0.0"
}

inputs = {
  vpc_name = "${local.hc_region}-${local.env_vars.env}"
  vpc_cidr = "192.168.0.0/16"

  subnets = [
    {
      name = "one"
      cidr = "192.168.2.0/24"
      gateway_ip = "192.168.2.1"
      primary_dns = "100.125.1.250"
      secondary_dns ="100.125.21.250"
    },
    {
      name = "two"
      cidr = "192.168.3.0/24"
      gateway_ip = "192.168.3.1"
      primary_dns = "100.125.1.250"
      secondary_dns ="100.125.21.250"
    }
  ]
}
