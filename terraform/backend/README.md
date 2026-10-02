# Terraform Remote Backend Setup on AWS (S3)

This Terraform project provisions the necessary AWS infrastructure to **enable remote state management** using **Amazon S3**.

> Remote backends allow teams to securely share and lock Terraform state files, a critical requirement for collaboration and consistency in DevOps workflows.

---

## Step-01: What This Project Does

- Creates an **S3 Bucket** to store Terraform state files.
- Enables S3 bucket versioning.
- Enables AES256 server-side encryption.
- Blocks public access to the bucket.
- Uses `prevent_destroy` to protect the bucket from accidental destruction.
- Supports parameterization using input variables for environment-specific deployments.
- Uses S3 native state locking through `use_lockfile = true` in consuming Terraform projects.

---

## Step-02: File Structure

| File | Purpose |
|---|---|
| `c1-versions.tf` | Specifies required Terraform version and AWS provider |
| `c2-variables.tf` | Declares input variables for environment and AWS region |
| `c3-s3bucket.tf` | Creates and secures the S3 bucket for remote backend |
| `c4-outputs.tf` | Exposes outputs such as the bucket ARN and bucket ID |

---

## Step-03: Example Usage

After confirming AWS credentials and required permissions:

```bash
# Initialize the project
terraform init

# Validate the configuration
terraform validate

# Preview the resources to be created
terraform plan

# Apply only after reviewing and approving the plan
terraform apply
```

---

## Sample Backend Configuration (for other Terraform projects)

Once this backend is created, use the following block in the other Terraform projects to store state remotely:

```hcl
terraform {
  backend "s3" {
    bucket       = "your-tfstate-bucket-name"
    key          = "env-name/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

> Replace `your-tfstate-bucket-name` with the actual bucket name. Each Terraform component should use its own state key.

---

## Why Use Remote Backend?

* **Team Collaboration**: Centralizes Terraform state for shared infrastructure management.
* **State Locking**: S3 native lockfiles help prevent concurrent state operations.
* **Versioning**: Allows recovery of previous state object versions.
* **Encryption**: Protects state data at rest.
* **Access Protection**: Blocks public access to the state bucket.

---

## Next Step

After setting up the backend infrastructure, configure the V3 VPC, EKS, and platform Terraform projects to use the remote S3 backend.

---

# Retail Store V3 - Terraform Backend