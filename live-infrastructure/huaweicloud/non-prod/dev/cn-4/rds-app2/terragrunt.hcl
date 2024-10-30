# Include core configuration in root
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "https://github.com/empresamaneira/terraform-modules.git//hc_rds?version=1.0.0"
}
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id   = dependency.vpc.outputs.id
  rds_name = "${local.env}-app2"
}
