# Terraform Backend Setup

This folder contains the Terraform backend configuration.

## Purpose of Backend Components

### 1. S3 Bucket

* Stores the Terraform state file remotely.
* Keeps track of what resources exist in AWS and their configurations.
* Durable and accessible from anywhere.
* Does **not** host any network services in your infrastructure.

### 2. DynamoDB Table

* Provides state locking for Terraform.
* Prevents multiple users or processes from running `terraform apply` at the same time and corrupting state.
* Does **not** provide database services for your network.

### Summary

| Component      | Role in Terraform      | Role in AWS network                           |
| -------------- | ---------------------- | --------------------------------------------- |
| S3 Bucket      | Stores Terraform state | None                                          |
| DynamoDB Table | Locks Terraform state  | None                                          |
| AD DC EC2      | Runs your domain       | Actual network services (DNS, LDAP, Kerberos) |

## Steps

1. Create S3 bucket for remote state
2. Create DynamoDB table for state locking
3. Ensure `backend.tf` points to correct bucket/table
4. Run `terraform init` in your environment folder to initialize backend
