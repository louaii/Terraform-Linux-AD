# Terraform Remote Backend Architecture (Phase 2)

This documentation explains the architecture of the Terraform remote backend using **S3** and **DynamoDB** for storing state and providing locking mechanisms. This setup is designed for **learning purposes** and uses AWS Free Tier resources.

---

## 1️⃣ Components

| Component | Type | Purpose |
|-----------|------|---------|
| **Terraform CLI / Terraform Run** | Client | Executes Terraform commands (`plan`, `apply`) |
| **S3 Bucket** | Storage | Stores the **Terraform state file** (`terraform.tfstate`) remotely. Acts as a single source of truth for all resources. |
| **S3 Versioning** | Feature of S3 | Keeps **historical versions** of the state file for recovery and rollback. |
| **DynamoDB Table** | NoSQL DB | Provides **state locking**, preventing multiple Terraform runs from modifying the state at the same time. |

---

## 2️⃣ Architecture Flow

┌───────────────────────┐
│     Terraform CLI     │
│  (terraform apply)    │
└───────────┬───────────┘
            │
            ▼
    ┌───────────────┐
    │ Acquire Lock  │
    │ DynamoDB Table│
    │   LockID      │
    └───────┬───────┘
            │
     Lock acquired
            ▼
    ┌───────────────┐
    │ Read Current  │
    │  State File   │
    │   S3 Bucket   │
    └───────┬───────┘
            │
     Terraform modifies
     resources in AWS
            ▼
    ┌───────────────┐
    │ Update State  │
    │  S3 Bucket    │
    │  (versioned)  │
    └───────┬───────┘
            │
     Release Lock
            ▼
    ┌───────────────┐
    │ DynamoDB Lock │
    │  Removed      │
    └───────────────┘


---

## 3️⃣ Explanation of the Flow

1. **Terraform CLI starts a run**  
   - Runs `terraform plan` or `terraform apply`.

2. **Acquire Lock in DynamoDB**  
   - Terraform creates an item in the DynamoDB table (`LockID`) to lock the state.  
   - Only one process can modify the state at a time.

3. **Read the current state**  
   - Terraform reads the latest `terraform.tfstate` from the **S3 bucket**.

4. **Apply changes to AWS resources**  
   - Terraform creates, updates, or deletes AWS resources according to your configuration.

5. **Update state in S3**  
   - Terraform writes the **new state** to the S3 bucket.  
   - S3 versioning ensures older states are preserved for recovery.

6. **Release Lock**  
   - Terraform deletes the lock item in DynamoDB, allowing other processes to run safely.

---

## 4️⃣ Why This Architecture Matters

- **Safety & Reliability**  
  - Prevents multiple concurrent Terraform runs from corrupting the state file.  
  - Versioning allows rollback to previous state versions.

- **Collaboration Ready**  
  - Multiple developers or CI/CD pipelines can work on the same project without conflicts.

- **Minimal Cost for Learning**  
  - DynamoDB on-demand (PAY_PER_REQUEST) is effectively free for low usage.  
  - S3 usage is minimal and free under AWS Free Tier.

---

## 5️⃣ Key Terraform Resources Used

| Terraform Resource | Purpose |
|------------------|---------|
| `aws_s3_bucket` | Stores the remote state file |
| `aws_s3_bucket_versioning` | Keeps history of state file versions |
| `aws_dynamodb_table` | Provides state locking for concurrent safety |

---
