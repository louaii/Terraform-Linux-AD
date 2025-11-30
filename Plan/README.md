# Project_Plan.md

## PHASE 1 — Terraform Backend Setup (Before Infrastructure)

### 🎯 Goal: Prepare remote Terraform state for safety and reliability.

1. **Create an S3 bucket for Terraform state (manual step)**

   * Example name: `tf-state-louay`
   * Block all public access
   * Enable versioning

2. **Create a DynamoDB table for state locking**

   * Table name: `terraform-lock`
   * Partition key: `LockID` (String)

3. **Define the Terraform backend configuration**

   * Backend type: S3
   * State locking: DynamoDB
   * This will be added later in `backend.tf`

---

## PHASE 2 — Build Core Networking (VPC Layer)

### 🎯 Goal: Create the foundation where all servers and services will be deployed.

1. **Create a VPC**

   * CIDR: `10.0.0.0/16`

2. **Create Subnets**

   * Public Subnet: `10.0.1.0/24` (Bastion Host)
   * Private Subnet A: `10.0.2.0/24` (AD Domain Controller)
   * Private Subnet B: `10.0.3.0/24` (Future servers: Monitoring, File Server, etc.)

3. **Create Internet Gateway (IGW)**

   * Attach it to the VPC

4. **Create Route Tables**

   * Public Route Table → route to IGW
   * Private Route Tables → no NAT (to remain free tier–friendly)

5. **Associate route tables to subnets**

   * Public subnet → Public RT
   * Private subnets → Private RT

6. **Create Security Groups**

   * Bastion: SSH allowed only from your IP
   * AD DC: Allow DNS, Kerberos, LDAP, SMB from VPC
   * Others: Minimal inbound, only needed ports

---

## PHASE 3 — Deploy Bastion Host (Management Gateway)

### 🎯 Goal: Deploy a secure public EC2 server for accessing private instances.

1. Deploy a small EC2 instance:

   * Amazon Linux 2023
   * Instance type: `t2.micro` (Free Tier)
   * Public IP enabled
   * Security Group allows SSH from your IP only

2. **Create or import SSH key pair**

3. **Test SSH connectivity**

4. **Prepare the Bastion**

   * Install common tools (`htop`, `bind-utils`, etc.)

---

## PHASE 4 — Deploy Linux Active Directory (Samba AD DC)

### 🎯 Goal: Deploy and configure a Samba Active Directory-compatible Domain Controller.

1. Create a private EC2 instance:

   * Ubuntu Server 22.04
   * Instance type: `t2.micro`
   * No public IP
   * Attached to Private Subnet A (10.0.2.0/24)

2. **Access via Bastion Host** using ProxyCommand or SSM later

3. **Prepare the server**

   * Set hostname (`dc01`)
   * Update `/etc/hosts`
   * Install Samba AD packages and dependencies

4. **Provision the Domain**

   * Domain: `corp.local`
   * NETBIOS Name: `CORP`
   * Internal DNS: Samba DNS
   * Administrator password

5. **Validate services**

   * Kerberos (`kinit`)
   * DNS (`nslookup`, `dig`)
   * AD functions (`samba-tool`)

---

## PHASE 5 — Optional: Deploy Additional Servers

### 🎯 Extend the infrastructure with free-tier servers.

1. **Monitoring Server (Zabbix or LibreNMS)**

   * Private Subnet B
   * Access restricted to Bastion

2. **File Server**

   * Domain-joined
   * SMB share provisioning

3. **Linux Workstations**

   * Domain-joined (optional)

4. **Windows Server or Workstation** (Not free tier)

   * Optional for full AD test environment

---

## PHASE 6 — Testing & Validation

### 🎯 Ensure everything works before automating.

1. Test DNS resolution within the VPC
2. Test Kerberos authentication
3. Create users using `samba-tool`
4. Join another Linux instance to the domain
5. Validate network isolation and security

---

## PHASE 7 — Documentation & Repo Finalization

### 🎯 Make the project ready for GitHub or portfolio use.

Add:

* Architecture README
* Project plan (this document)
* Diagrams
* Terraform folder modules
* Samba install scripts
* Cost breakdown
* Troubleshooting guide

---

## PHASE 8 — Implement Terraform Automation

### 🎯 Convert manual setup into full Terraform automation.

1. Add scripts via `user_data`
2. Automate Samba provisioning
3. Implement reusable Terraform modules
4. Add variables and outputs

---

## PHASE 9 — Destroy and Re-Deploy for Validation

### 🎯 Prove that the entire infrastructure can be rebuilt automatically.

1. Run `terraform destroy`
2. Deploy again from scratch
3. Confirm AD and network functionality
4. Document final deployment time and results

---

This completes the actionable step-by-step project plan for building the AWS + Linux AD infrastructure.
