terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    
  required_version = ">= 0.12"
}


provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "app_server"{
    ami = "ami-0ecb62995f68bb549"
    instance_type = "t3.micro"
    subnet_id = "subnet-0bf5f48edaaf852fd"

    tags = {
        Name = "Terraform_Demo"
    }

}
