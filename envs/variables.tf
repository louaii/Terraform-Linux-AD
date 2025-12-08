# -----------------------------
# VPC & Subnet
# -----------------------------
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
  description = "CIDR block for the main VPC"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
  description = "CIDR block for the public subnet"
}

# -----------------------------
# SSH Access
# -----------------------------
variable "allowed_ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed to SSH to instance (VPN IP changes; 0.0.0.0/0 for dev)"
}

variable "key" {
  type        = string
  default     = "linux-ad-key"
  description = "Name of existing EC2 Key Pair to use for SSH access"
}

# -----------------------------
# Linux AD & Instance
# -----------------------------
variable "samba_admin_password" {
  type        = string
  default     = "!@#AdminPassword123!@#"
  description = "Temporary admin password used during Samba AD provisioning — change after provisioning"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type for Linux AD server (free tier eligible)"
}

# -----------------------------
# Common Tags
# -----------------------------
variable "common_tags" {
  type = map(string)
  default = {
    Project = "Terraform-Linux-AD"
    Owner   = "Louay"
  }
  description = "Tags applied to all resources"
}
