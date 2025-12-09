# Linux-AD Project Structure

This directory outlines the skeleton structure of the **Linux-AD** project, including Terraform modules and Ansible playbooks.

## Directory Layout
linux-ad/
├─ README.md # Main project documentation
├─ envs/ # Terraform modules
│ ├─ backend/ # S3 + DynamoDB backend
│ ├─ linux_ad.tf # EC2 instance + Linux AD
│ ├─ network.tf # VPC, subnet, IGW, route tables, SG
│ ├─ outputs.tf
│ └─ variables.tf # Terraform variables
├─ ansible/ # Ansible playbooks
│ ├─ inventory.ini # Hosts inventory
│ ├─ active_directory.yml # Phase 4: Linux AD validation
│ ├─ bastion.yml # Phase 5: Bastion host provisioning
│ ├─ kerberos.yml # Kerberos testing
│ ├─ samba.yml # Samba AD tests
│ └─ group_vars/linux_ad.yml # Shared variables for Ansible
├─ structure/ # Project skeleton
│ └─ README.md # This file


---

## Purpose

This skeleton helps maintain a **modular and organized structure**, separating:

- **Infrastructure**: Terraform modules for backend, network, and Linux AD
- **Configuration Management**: Ansible playbooks for AD, Kerberos, Samba, bastion host
- **Variables**: Centralized variable definitions and group vars
- **Documentation**: README and project plans

---

## Key Notes

- Terraform backend uses **S3 bucket + DynamoDB** for state management.
- EC2 instances are configured for Linux Active Directory and are free-tier compatible.
- Ansible automates **AD deployment, validation, and extended testing**.
- Bastion host is provisioned separately for secure SSH access.


