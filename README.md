## 📦 Prerequisites

- AWS CLI configured (`aws configure`)
- Terraform installed (v1.3+ recommended)
- GitHub repo for your application (see [this repo](https://github.com/yourusername/terraform-project-task-1))
- The repo must contain:
- ✅ [`buildspec.yml`](examples/buildspec.yml) — Defines the build and artifact steps
- ✅ [`appspec.yml`](examples/appspec.yml) — Required by CodeDeploy
- ✅ [`scripts/install.sh`](examples/scripts/install.sh) — Installs dependencies on EC2
- ✅ [`scripts/start.sh`](examples/scripts/start.sh) — Starts the React app (e.g. `serve -s build`)

  - You can copy these files from the [`examples/`](examples) folder in this repo OR refer to [this repo](https://github.com/yourusername/terraform-project-task-1) as a working example if unsure.

 ## 🛠️ Setup Instructions

### 1. Clone this repo and configure variables

```bash
git clone https://github.com/yourusername/CodePipeline-using-Terraform.git
cd CodePipeline-using-Terraform
```
### 2. Configure `terraform.tfvars`

Before running Terraform, create a `terraform.tfvars` file in the root of this repo and add the following:

```hcl
project_name       = "myApp"
bucket_name        = "your-bucket-name"
aws_region         = "your-region"
ami_id             = "ami-xxxxxxxxxxxxxxxxx"   
instance_type      = "t3.micro"
key_name           = "your-keypair-name"           # Must exist in your AWS account
github_owner       = "your-github-username"
github_repo        = "your-application-repo"   
github_branch      = "your-branch-name"
github_token       = "your-github-access-token"      # Create a GitHub Personal Access Token with repo access
instance_tag_key   = "Name"
instance_tag_value = "MyAppServer"
```

⚠️ Warning: Never commit terraform.tfvars to GitHub — it can contain secrets like your GitHub token.

### 3. Provision AWS
```bash
aws configure
```

### 4. Terraform 
```bash
terraform init
terraform plan
terraform apply
```

---

## 🧠 Common Problems & Fixes

| Problem                                    | Fix                                                                            |
|-------------------------------------------|---------------------------------------------------------------------------------|
| ❌ `HEALTH_CONSTRAINTS` error in CodeDeploy | Ensure your EC2 IAM role has `s3:GetObject` permissions on the artifact bucket |
| ❌ EC2 agent not running                    | Check if `codedeploy-agent` is running (see `user_data` script in `main.tf`)   |
| ❌ Pipeline fails at source                 | Verify GitHub repo, branch name, and token permissions                         |
| ❌ Build fails                              | Check `buildspec.yml` and make sure it's valid and points to correct scripts   |
