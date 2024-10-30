# POC TF Live Infrastructure

This repository contains the Terragrunt configuration for managing multi-cloud infrastructure across Huawei Cloud and Google Cloud Platform (GCP).

## Overview

This project uses Terragrunt to manage Terraform configurations for deploying and maintaining infrastructure across multiple cloud providers. It's designed to work with Huawei Cloud and GCP, with state files stored in a Huawei Cloud Object Storage Service (OBS) bucket.

## Prerequisites

- Terragrunt
- Terraform
- Access to Huawei Cloud and GCP
- Necessary credentials for both cloud providers

## Structure

The repository is structured as follows:
```
.
├── live-infrastructure/
│ └── terragrunt.hcl
├── secrets.yaml (encrypted)
└── region.hcl
```


## Configuration

### Provider Setup

The `terragrunt.hcl` file automatically generates provider configurations for both Huawei Cloud and GCP.

#### Huawei Cloud Provider

```hcl
provider "huaweicloud" {
  region     = <region from region.hcl>
  access_key = <access key from secrets.yaml>
  secret_key = <secret key from secrets.yaml>
}

provider "gcp" {
  project = <project from secrets.yaml>
  region  = <region from secrets.yaml>
}

remote_state {
  backend = "s3"
  config = {
    bucket   = "${namespace}-${aws_region}-terraform-${account_id}"
    key      = "${path_relative_to_include()}/terraform.tfstate"
    region   = <aws_region>
    endpoint = "https://obs.cn-north-1.myhuaweicloud.com"
    
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
```

## Usage
Ensure you have the necessary credentials set up for both Huawei Cloud and GCP.

Navigate to the directory containing the terragrunt.hcl file.

Run the following commands:

```
terragrunt init
terragrunt plan
terragrunt apply
```

## Security
Sensitive information is stored in an encrypted secrets.yaml file, which is decrypted using sops during Terragrunt execution.

## Contributing
Please ensure that any changes are thoroughly tested before submitting a pull request.

## License
This README provides an overview of your project, its structure, configuration details, and basic usage instructions. You may want to customize it further based on specific details of your project, such as adding information about individual modules, more detailed setup instructions, or any project-specific guidelines.

Remember to keep sensitive information like actual credentials or specific internal details out of the README, as it's typically committed to version control and may be publicly visible.