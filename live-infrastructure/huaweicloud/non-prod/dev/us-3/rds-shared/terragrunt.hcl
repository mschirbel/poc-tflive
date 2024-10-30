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
  source = "https://github.com/empresamaneira/terraform-modules.git//hc_rds?version=1.0.0"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name = "shared"
  engine = "mysql"

  vpc_id = dependency.vpc.outputs.vpc_id
}
