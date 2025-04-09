terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # or any other version you prefer
    }
  }

  required_version = ">= 1.0"
}

