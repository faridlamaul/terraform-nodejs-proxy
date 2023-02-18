terraform {
  #############################################################
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU WILL UNCOMMENT THIS CODE THEN RERUN TERRAFORM INIT
  ## TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################
  #    backend "s3" {
  #      bucket         = "terraform-state-${random_id.random_suffix.hex}"
  #      key            = "web-app/nodejs/terraform.tfstate"
  #      region         = "ap-southeast-1"
  #      dynamodb_table = "terraform-state-lock"
  #      encrypt        = true
  #    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55.0"
    }
  }
}

# Configure the AWS Provider with the ap-southeast-1 region
provider "aws" {
  region = "ap-southeast-1"
}
