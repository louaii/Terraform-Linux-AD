terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ------------------------------
# AWS Provider Configuration
# ------------------------------
provider "aws" {
  region = var.aws_region
}

# ------------------------------
# Variables
# ------------------------------
variable "aws_region" {
  type        = string
  default     = "eu-north-1"
  description = "AWS region for Terraform deployments"
}

# ------------------------------
# Backend Infrastructure Resources
# ------------------------------

#reached here
# S3 bucket for remote backend TF state
resource "aws_s3_bucket" "tf_state" {
  bucket = "myproject-tfstate-envs"
}

# Enable versioning on S3 bucket
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "tf_locks" {
  name         = "myproject-tfstate-locks-envs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}