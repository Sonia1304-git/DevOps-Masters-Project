# ⚙️ CodePipeline with Terraform & DevSecOps using GitHub Actions and Kubernetes Sealed Secrets

This project establishes a robust CI/CD pipeline on AWS using Terraform, enhanced with cutting-edge DevSecOps practices via GitHub Actions. It provisions an end-to-end AWS CodePipeline (Source, Build, Deploy to EC2) and validates infrastructure with Terratest. Further, it integrates GitHub Actions for automated DevSecOps, incorporating security scanning (tfsec for Terraform, Trivy for Docker images) and secure secret management with Kubernetes Sealed Secrets. This ensures a secure, automated, and efficient application delivery workflow, triggered on every code push.

## 🌐 Live Demo

[https://github.com/Ayush-silicon/DevOps-Masters-Project](https://github.com/Ayush-silicon/DevOps-Masters-Project)

## ✨ Features

-   ⚙️ **End-to-end AWS CodePipeline**: Fully provisioned with Terraform (Source, Build, Deploy).
-   🚀 **CI/CD Automation**: Leverages GitHub Actions for seamless workflow orchestration.
-   🔒 **DevSecOps Integration**: Incorporates `tfsec` for Terraform security and `Trivy` for Docker image vulnerability scanning.
-   🔑 **Secure Secret Management**: Utilizes Kubernetes Sealed Secrets for encrypting and managing sensitive data.
-   🧪 **Infrastructure Testing**: Validates Terraform modules and deployed infrastructure using Terratest.
-   ☁️ **Flexible Deployment**: Supports deployment to AWS EC2 instances and Kubernetes clusters.
-   🔐 **IAM & S3**: Configures necessary IAM roles and S3 buckets for artifact storage.

## 💻 Tech Stack

| Category           | Tools / Platforms                                  |
|--------------------|----------------------------------------------------|
| **IaC**            | Terraform, Terratest                               |
| **Cloud**          | AWS (CodePipeline, CodeBuild, CodeDeploy, S3, IAM) |
| **DevSecOps**      | tfsec, Trivy                                       |
| **Secret Management** | Sealed Secrets (Bitnami)                        |
| **CI/CD**          | GitHub Actions                                     |
| **Containers**     | Docker, Kubernetes                                 |
| **Languages**      | Go (Terratest), YAML                               |

## ⚙️ Installation

To set up and run this project, follow these steps:

1.  **Clone the Repository**

    ```bash
    git clone https://github.com/yourusername/DevOps-Masters-Project.git
    cd DevOps-Masters-Project
    ```

2.  **Configure AWS CLI**

    ```bash
    aws configure
    # Follow prompts to enter your AWS Access Key ID, Secret Access Key, Region, and output format.
    ```

3.  **Install Terraform**

    Ensure you have Terraform (v1.3+ recommended) installed on your system. Refer to the [official Terraform documentation](https://developer.hashicorp.com/terraform/downloads) for installation instructions.

4.  **Configure `terraform.tfvars`**

    Create a file named `terraform.tfvars` in the root of the cloned repository and add your project-specific configurations.

    ```hcl
    project_name       = "myApp"
    bucket_name        = "your-unique-artifact-bucket-name"
    aws_region         = "your-aws-region"
    ami_id             = "ami-xxxxxxxxxxxxxxxxx"        # e.g., ami-0abcdef1234567890 (Ubuntu, Amazon Linux 2, etc.)
    instance_type      = "t3.micro"
    key_name           = "your-keypair-name"            # Must exist in your AWS account
    github_owner       = "your-github-username"
    github_repo        = "your-application-repo"        # The repository containing your app code
    github_branch      = "your-branch-name"
    github_token       = "your-github-personal-access-token" # Token with 'repo' access
    instance_tag_key   = "Name"
    instance_tag_value = "MyAppServer"
    ```

    ⚠️ **Warning:** Never commit `terraform.tfvars` to GitHub as it may contain sensitive information like your GitHub token.

5.  **Provision AWS Infrastructure with Terraform**

    ```bash
    terraform init
    terraform plan
    terraform apply --auto-approve
    ```

### Environment Variables

_Ensure all necessary environment variables (e.g., AWS credentials, GitHub tokens) are securely configured in your CI/CD environment or local setup._

## 📸 Screenshots

_Add screenshots here_

## 🚀 Usage / How it Works

This project is divided into two main tasks: provisioning an AWS CodePipeline with Terraform and enhancing it with DevSecOps practices using GitHub Actions and Kubernetes Sealed Secrets.

### Task 1: AWS CodePipeline using Terraform

This task focuses on provisioning a CI/CD pipeline using AWS CodePipeline, CodeBuild, and CodeDeploy with Terraform. It sets up an automated deployment from GitHub to an EC2 instance, with infrastructure validation using Terratest.

#### 📌 Task Objectives

-   Use Terraform to provision AWS CodePipeline with Source (GitHub), Build (AWS CodeBuild), and Deploy (AWS CodeDeploy to EC2) stages.
-   Define infrastructure as code for CodePipeline, CodeBuild, CodeDeploy, IAM roles/policies, and an S3 artifact bucket.
-   Write infrastructure tests using [Terratest](https://terratest.gruntwork.io/) to validate Terraform modules.
-   Apply Terraform and verify a successful deployment.

#### 📦 Prerequisites for Application Deployment

Your application repository must contain:
-   ✅ [`buildspec.yml`](examples/buildspec.yml): Defines the build and artifact steps for AWS CodeBuild.
-   ✅ [`appspec.yml`](examples/appspec.yml): Required by AWS CodeDeploy for EC2 deployments.
-   ✅ [`scripts/install.sh`](examples/scripts/install.sh): Script to install dependencies on the EC2 instance.
-   ✅ [`scripts/start.sh`](examples/scripts/start.sh): Script to start your application (e.g., a React app).

You can copy these example files from the `examples/` folder in this repository or refer to a working example application repository.

#### 🧪 Infrastructure Testing with Terratest

To validate the Terraform modules using Terratest:

1.  **Install Prerequisites**: Ensure you have Go (for Terratest), Terraform, and Git installed.
2.  **Project Structure**: Organize your project like this:
    ```
    DevOps-Masters-Project/
    ├── terraform/                     # Your Terraform code (main.tf, variables.tf, etc)
    └── test/                          # Terratest files
        └── terraform_pipeline_test.go
    ```
3.  **Write the Test Code**: Create `test/terraform_pipeline_test.go`
    ```go
    package test

    import (
      "testing"

      "github.com/gruntwork-io/terratest/modules/terraform"
      "github.com/stretchr/testify/assert"
    )

    func TestTerraformPipeline(t *testing.T) {
      t.Parallel()

      tf := &terraform.Options{
        TerraformDir: "../terraform", // Adjust path as per your directory
      }

      defer terraform.Destroy(t, tf)             // Cleanup resources after test
      terraform.InitAndApply(t, tf)             // Run terraform init + apply

      pipelineName := terraform.Output(t, tf, "codepipeline_name") // Replace with actual output variable name
      assert.NotEmpty(t, pipelineName)
    }
    ```
4.  **Ensure Terraform Output Is Defined**: In your `terraform/output.tf` (or `main.tf`), include an output for the pipeline name:
    ```hcl
    output "codepipeline_name" {
      value = aws_codepipeline.my_pipeline.name # Update "my_pipeline" with your actual resource name.
    }
    ```
5.  **Initialize Go Project**: From the `DevOps-Masters-Project` root:
    ```bash
    go mod init devops-masters-test
    go get github.com/gruntwork-io/terratest/modules/terraform
    go get github.com/stretchr/testify/assert
    ```
6.  **Run the Test**: From the root directory:
    ```bash
    go test ./test
    ```
    This will initialize and apply your Terraform, capture and assert outputs, and automatically destroy resources.


## 🧠 Common Problems & Fixes

| Problem                                    | Fix                                                                            |
|-------------------------------------------|---------------------------------------------------------------------------------|
| ❌ `HEALTH_CONSTRAINTS` error in CodeDeploy | Ensure your EC2 IAM role has `s3:GetObject` permissions on the artifact bucket |
| ❌ EC2 agent not running                    | Check if `codedeploy-agent` is running (see `user_data` script in `main.tf`)   |
| ❌ Pipeline fails at source                 | Verify GitHub repo, branch name, and token permissions                         |
| ❌ Build fails                              | Check `buildspec.yml` and make sure it's valid and points to correct scripts   |
