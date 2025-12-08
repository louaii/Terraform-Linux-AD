# -----------------------------
# Get latest Ubuntu 22.04 LTS AMI (x86_64)
# -----------------------------
data "aws_ami" "ubuntu_22_04" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# -----------------------------
# EC2 Instance for Linux AD
# -----------------------------
resource "aws_instance" "linux_ad" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ad_sg.id]
  key_name               = var.key

  associate_public_ip_address = true

  tags = merge(var.common_tags, {
    Name = "linux-ad-server"
  })

  # -----------------------------
  # User-data for initial setup
  # -----------------------------
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              # Samba AD provisioning commands go here
              EOF
}
