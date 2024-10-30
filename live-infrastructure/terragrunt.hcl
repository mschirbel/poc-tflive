locals {
  secret_vars = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yaml")))
  region_vars = find_in_parent_folders("region.hcl")
}

# Generate an AWS provider block
generate "huaweicloud_provider" {
  path      = "huaweicloud_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "huaweicloud" {
  region     = ${local.region_vars.huaweicloud_region}
  access_key = ${local.secret_vars.huaweicloud.access_key}
  secret_key = ${local.secret_vars.huaweicloud.secret_key}
}
EOF
}

generate "gcp_provider" {
  path      = "gcp_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "gcp" {
  project     = ${local.secret_vars.gcp.project}
  region      = ${local.secret_vars.gcp.region}
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    bucket   = "${local.namespace}-${local.aws_region}-terraform-${local.account_id}"
    key      = "${path_relative_to_include()}/terraform.tfstate"
    region   = local.aws_region
    endpoint = "https://obs.cn-north-1.myhuaweicloud.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
