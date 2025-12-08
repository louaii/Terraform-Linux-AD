provider "aws" {
  region = "us-east-1"
}

# Create the S3 bucket
resource "aws_s3_bucket" "tf_s3_state" {
  bucket = "tf-linux-ad-state"
}

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "s3_state_versioning" {
  bucket = aws_s3_bucket.tf_s3_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for locking
resource "aws_dynamodb_table" "db_locks" {
  name         = "state-locks-envs"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
