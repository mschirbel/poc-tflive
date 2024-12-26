locals {
  # Automatically load stage-level variables
  stage_vars = read_terragrunt_config(find_in_parent_folders("stage.hcl"))

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  # Extract the variables we need for easy access
  stage      = local.stage_vars.locals.stage
  account_id = local.account_vars.locals.aws_account_id
  aws_region = local.region_vars.locals.aws_region
  namespace  = local.account_vars.locals.namespace
}

# Generate an AWS provider block
generate "aws_provider" {
  path      = "aws_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${local.account_id}"]
  default_tags {
    tags = {
      Namespace = "${local.namespace}"
      Environment = "${local.stage}"
      Terraform = "true"
      TerraformPath = "${path_relative_to_include()}"
    }
  }
}
EOF
}


# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    bucket         = "${local.namespace}-${local.aws_region}-terraform-${local.account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    dynamodb_table = "${local.namespace}-${local.aws_region}-${local.stage}-terraform-lock"
    region         = local.aws_region
    encrypt        = true
    s3_bucket_tags = {
      Namespace   = local.namespace
      Environment = local.stage
      Terragrunt  = "true"
    }
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.stage_vars.locals,
  local.region_vars.locals,
  local.global_vars.locals,
)
