terraform {
  backend "s3" {
    bucket         = "tf-linux-ad-state"
    key            = "envs/terraform.tfstate" #read from this file
    region         = "us-east-1"
    dynamodb_table = "state-locks-envs"
    encrypt        = true
  }
}