terraform {
  required_version = ">= 1.3.0"

  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.40.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.3"
    }
  }
}