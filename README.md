# Terraform CI/CD Pipeline to Deploy a Flask App on AWS

This repository contains the Terraform configuration for deploying a Python Flask application on an AWS EC2 instance. It also includes a GitHub Actions CI/CD pipeline that automates the deployment process.

## Project Overview

This project automates the provisioning and deployment of a Flask application using Terraform. The infrastructure includes:
- A VPC with a public subnet.
- An EC2 instance that runs the Flask application.
- Security groups for SSH and HTTP access.
- CI/CD pipeline using GitHub Actions for seamless deployment.

## Prerequisites

To use this project, ensure you have the following set up:
- **Terraform** installed ([installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)).
- **AWS Account** with an access key and secret key.
- **GitHub Secrets** configured for AWS credentials and SSH keys.

## Configuration

### AWS Setup

You need to configure the following AWS resources:
- AWS Key Pair: The key pair should be created in the AWS console and used for SSH access to the EC2 instance.

### GitHub Secrets

Add the following secrets in your GitHub repository:
- `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
- `SSH_PRIVATE_KEY`: Your SSH private key to access the EC2 instance.

### Variables

Make sure to update the `main.tf` file or set these variables if required:

- `aws_access_key_id`
- `aws_secret_access_key`
- `region` (default is `us-east-1`)
- `cidr` (default is `10.0.0.0/16`)

## CI/CD Workflow

The GitHub Actions workflow (`.github/workflows/terraform.yml`) automates the following steps:
1. **Checkout Code**: Retrieves the latest code from the `main` branch.
2. **Setup Terraform**: Installs and configures Terraform.
3. **Terraform Init**: Initializes the Terraform environment.
4. **Terraform Plan**: Plans the infrastructure changes.
5. **Terraform Apply**: Applies the changes to AWS and provisions the resources.
6. **SSH Setup**: Sets up the SSH agent using your private key.
7. **Retrieve EC2 IP**: Gets the public IP of the EC2 instance.
8. **Print EC2 IP**: Outputs the EC2 instance's public IP.

## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/terraform-CI-CD.git
   cd terraform-CI-CD
