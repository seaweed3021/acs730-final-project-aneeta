# ACS730 Final Project — Two-Tier Web Application with Terraform

Automated deployment of a two-tier web application (ALB + Auto Scaling Group of EC2 web servers) across **dev**, **staging**, and **prod** environments using modular Terraform, on AWS Academy Learner Lab.

## Architecture
- **Public tier:** Application Load Balancer (2 public subnets, 2 AZs)
- **Private tier:** EC2 web servers in an Auto Scaling Group (2 private subnets, 2 AZs), reachable only via the ALB
- NAT Gateway for outbound internet access from private subnets
- S3 bucket per environment for the image displayed on the webpage
- S3 bucket per environment for Terraform remote state

## Prerequisites
1. AWS Academy Learner Lab access (uses the pre-existing `LabRole` / `LabInstanceProfile` — this project does not create IAM roles)
2. Terraform >= 1.5 and AWS CLI installed (Cloud9 recommended — Amazon Linux based)
3. Active AWS credentials configured (`~/.aws/credentials`) or Cloud9's managed temporary credentials enabled
4. **S3 buckets for Terraform state must exist before running `terraform init`** — one per environment, created manually via CLI:
```bash
   aws s3api create-bucket --bucket <name-env-tfstate-<account-id>> --region us-east-1
```
   (bucket names are already referenced in each environment's `backend.tf`)
5. **The site image must be uploaded manually** before first deploy — place it at `assets/site-image.webp` in the repo root. Terraform uploads it to S3 automatically from that path on `apply`.

## Deployment
For each environment (`dev`, `staging`, `prod`):
```bash
cd environments/<env>
terraform init
terraform plan
terraform apply
```
On success, Terraform outputs `alb_dns_name` — open that URL in a browser to view the deployed site.

## Cleanup
To tear down an environment:
```bash
cd environments/<env>
terraform destroy
```
Run this for all three environments (`dev`, `staging`, `prod`) to avoid leaving billable resources running in the Learner Lab account. The Terraform state S3 buckets are not managed by Terraform and must be deleted manually if no longer needed:
```bash
aws s3 rb s3://<bucket-name> --force
```

## Repository structure
```
modules/          reusable Terraform modules (networking, security-group, storage, launch-template, alb, asg)
environments/     per-environment root configs (dev, staging, prod) calling the shared modules
scripts/          EC2 user-data script (installs httpd, pulls image from S3)
.github/workflows/  GitHub Actions security scan (tflint + Trivy), runs on push to staging and PRs into prod
```