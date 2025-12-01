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

#Storage Container
# S3 bucket for remote backend TF state
#resource "type" "name" ==> locally in the code
#       bucket = "name" ==> on aws
resource "aws_s3_bucket" "state" {
  bucket = "s3-state"
}

# Enable versioning on S3 bucket ==> every change makes a new snapshot(History of changes like in git)
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "db_locks" {
  name         = "state-locks-envs"
  billing_mode = "PAY_PER_REQUEST" #pay_on_request
  hash_key     = "LockID" #primary_key
  attribute {
    name = "LockID"
    type = "S"
  }
}