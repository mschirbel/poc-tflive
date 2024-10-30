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
  source = "https://github.com/empresamaneira/terraform-modules.git//hc_generic-app?version=1.0.0"
}

inputs = {
  create_obs_bucket = false
  create_rds_instance = true

  name = "app2"
}
