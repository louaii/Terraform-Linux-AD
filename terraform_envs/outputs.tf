# -----------------------------
# EC2 Instance Public IP
# -----------------------------
output "linux_ad_public_ip" {
  description = "Public IP of the Linux AD EC2 instance"
  value       = aws_instance.linux_ad.public_ip
}

# -----------------------------
# EC2 Instance Private IP
# -----------------------------
output "linux_ad_private_ip" {
  description = "Private IP of the Linux AD EC2 instance"
  value       = aws_instance.linux_ad.private_ip
}

# -----------------------------
# EC2 Instance Public DNS
# -----------------------------
output "linux_ad_public_dns" {
  description = "Public DNS of the Linux AD EC2 instance"
  value       = aws_instance.linux_ad.public_dns
}

# -----------------------------
# VPC ID
# -----------------------------
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

# -----------------------------
# Public Subnet ID
# -----------------------------
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

# -----------------------------
# Security Group ID
# -----------------------------
output "ad_sg_id" {
  description = "ID of the Linux AD security group"
  value       = aws_security_group.ad_sg.id
}
