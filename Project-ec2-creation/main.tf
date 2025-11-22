   provider "aws" {
     region = "us-east-1"  # Set your desired AWS region
   }

   resource "aws_instance" "example" {
     ami           = "ami-0ecb62995f68bb549"  # Specify an appropriate AMI ID
     instance_type = "t3.micro"
     subnet_id     = "subnet-0bf5f48edaaf852fd"
   }
