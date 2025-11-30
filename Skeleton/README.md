# Terraform AWS + Linux AD Skeleton


```
terraform-aws-linux-ad/
│
├── backend/
│   ├── backend.tf                # Terraform backend (S3 + DynamoDB)
│   └── README.md                 # Backend setup instructions
│
├── envs/
│   ├── dev/
│   │   ├── main.tf               # Orchestration file for dev environment
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars      # Dev environment variables
│   │
│   └── prod/                     # Future production environment
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
│
├── modules/
│   ├── vpc/
│   │   ├── main.tf               # VPC: subnets, routes, IGW, SGs
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── bastion/
│   │   ├── main.tf               # Bastion EC2 host (public)
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ad_dc/
│   │   ├── main.tf               # Active Directory Domain Controller (Samba)
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── monitoring/               # Optional module (Zabbix/LibreNMS)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── s3_state/                 # Optional module for backend
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── scripts/
│   ├── samba/
│   │   ├── install_samba.sh      # Install Samba on AD DC
│   │   ├── provision_domain.sh   # Provision corp.local domain
│   │   └── join_domain.sh        # Join Linux servers to domain
│   │
│   └── bastion/
│       ├── setup_tools.sh        # Install tools on bastion host
│
├── diagrams/
│   ├── network-topology.png      # To be created
│   ├── ad-architecture.png       # To be created
│   └── routing-logic.png         # To be created

```

### Notes:

* All `.tf` files are placeholders for now.
* `scripts/` contains shell scripts for AD and Bastion setup.
* `diagrams/` folder is for images you create later.


