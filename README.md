# Terraform AWS + Linux Active Directory Network Architecture

## Overview

This project provides a **fully-documented network architecture** for deploying a free-tier friendly IT infrastructure on AWS using **Terraform**, featuring:

* **Linux-based Active Directory (Samba AD DC)**
* **Private subnets for servers**
* **Public subnet for bastion access**
* **AWS VPC, routing, security groups**
* **EC2 instances sized for AWS Free Tier** (t2.micro/t3.micro)

This README serves as the **official documentation and planning file** for the network architecture.

---

## 📌 Goals

* Build a realistic corporate IT environment **fully automated with Terraform**.
* Simulate an on-premise-style network in AWS **at zero or minimal cost**.
* Include a domain controller, management server, and monitoring server.
* Provide a clean design that can be easily extended.

---

## 🏗️ High-Level Architecture

```
+-------------------------------------------------------------+
|                           AWS VPC                           |
|                    CIDR: 10.0.0.0/16                        |
|                                                             |
|  +---------------------+   +-----------------------------+  |
|  |    Public Subnet    |   |       Private Subnet        |  |
|  |     10.0.1.0/24     |   |       10.0.2.0/24           |  |
|  |                     |   |                             |  |
|  |  Bastion Host       |   |  Linux AD DC (Samba)        |  |
|  |  t2.micro           |   |  t2.micro                   |  |
|  |  SSH Allowed from   |   |  No Internet Access         |  |
|  |  Your IP Only       |   |  (NAT Optional)             |  |
|  +---------------------+   +-----------------------------+  |
|                                                             |
|                       Additional Private Subnet            |
|                       10.0.3.0/24                          |
|                       Optional Servers:                     |
|                       - Monitoring (Zabbix/LibreNMS)        |
|                       - File Server                         |
|                                                             |
+-------------------------------------------------------------+
```

---

## 🧱 Components

### 1. **VPC (10.0.0.0/16)**

A large CIDR to allow future expansion.

### 2. **Subnets**

| Subnet           | CIDR        | Type    | Purpose                    |
| ---------------- | ----------- | ------- | -------------------------- |
| Public Subnet    | 10.0.1.0/24 | Public  | Bastion host only          |
| Private Subnet A | 10.0.2.0/24 | Private | Linux AD Domain Controller |
| Private Subnet B | 10.0.3.0/24 | Private | Monitoring/File Server     |

### 3. **Route Tables**

* Public subnet → Internet Gateway
* Private subnets → (Optional) NAT Gateway (NOT FREE)
* To stay free: use **no outbound internet**, or attach **S3 VPC endpoint** for updates.

### 4. **EC2 Instances**

| Server                       | OS                  | Purpose                | Size (Free Tier) |
| ---------------------------- | ------------------- | ---------------------- | ---------------- |
| Bastion Host                 | Amazon Linux 2023   | SSH to private servers | t2.micro         |
| AD Domain Controller         | Ubuntu Server 22.04 | Samba AD DC            | t2.micro         |
| Monitoring Server (Optional) | Ubuntu              | Zabbix/LibreNMS        | t2.micro         |

### 5. **Security Groups**

#### Bastion SG

* Allow SSH from your IP only
* Allow SSH to private subnets

#### AD DC SG

* Allow domain ports from all subnets:

  * 53 (DNS)
  * 88 (Kerberos)
  * 389 (LDAP)
  * 445 (SMB)

#### Monitoring SG

* Allow web UI only from Bastion or your IP

### 6. **IAM**

Minimal IAM usage:

* Terraform user with programmatic access
* Least privilege policy for EC2, VPC, and S3 state bucket

### 7. **State Storage**

* S3 bucket for Terraform backend
* DynamoDB table for state locking (free tier)

---

## 🧩 Linux Active Directory (Samba AD DC)

The plan uses Samba as a full AD Domain Controller.

### AD Domain Details

* Domain Name: **corp.local**
* NETBIOS Name: **CORP**
* Functional Level: Windows Server 2012R2 compatible
* DNS Server: Samba internal DNS

### Domain Services Provided

* DNS
* Kerberos
* LDAP
* SMB shares (optional)

---

## 🔐 Authentication Flow

```
User Workstation (future) → AD DC (Samba) → DNS & Kerberos
```

Workstations can be added later using EC2 Windows instances (paid) or local VMs on your laptop.

---

## 🗂️ Terraform Structure (Recommended)

```
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── vpc/
│   ├── bastion/
│   ├── ad_dc/
│   └── monitoring/
└── README.md
```

---

## 🚀 Deployment Flow

1. Create Terraform backend (S3 + DynamoDB)
2. Deploy VPC
3. Deploy Bastion Host
4. Deploy AD Domain Controller
5. SSH into AD DC → Run Samba provisioning script
6. (Optional) Deploy monitoring/file servers

---

## ⚠️ Cost Awareness (Brief)

All resources are free when:

* EC2 instances are t2.micro or t3.micro
* Only **one** instance runs continuously
* Elastic IP is used only for Bastion
* No NAT Gateway is deployed
* No paid services used (RDS, FSx, etc.)

