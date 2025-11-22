terraform {
  required_version = ">= 0.12"
}


provider "aws" {
     region = "us-east-1"  # Set your desired AWS region
}

data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}


resource "aws_s3_bucket" "terraform_state" {
    bucket = "${local.account_id}-terraform-state"

    versioning {
        enabled = true
    }

   server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }

    tags = {
        Name = "TerraformStateBucket"
    }
}


resource "aws_dynamodb_table" "terraform_lock" {
    name = "terraform-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

# terraform {
#   backend "s3" {
#     bucket = "${local.account_id}-terraform-state"
#     key    = "aws/remote_state/main.tfstate"
#     region = "us-east-1"
#     encrypt = true
#     dynamodb_table = "terraform-lock"
#   }
# }



