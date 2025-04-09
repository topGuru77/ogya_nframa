#!/bin/bash

# Run Terraform
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

# Git Operations
git add .
git commit -m "Auto commit after Terraform apply"
git push origin main