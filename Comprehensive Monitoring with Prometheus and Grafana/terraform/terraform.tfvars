############################################################
# terraform.tfvars
#
# Development Environment Variables
############################################################

############################################################
# AWS Configuration
############################################################

aws_account_id = "705557196379"

aws_region = "ap-south-2"

############################################################
# Project Information
############################################################

project_name = "Monitoring-Kubernetes-deployment"

environment = "dev"

############################################################
# Networking
############################################################

vpc_cidr = "10.0.0.0/16"

public_subnet_1 = "10.0.1.0/24"

public_subnet_2 = "10.0.2.0/24"

private_subnet_1 = "10.0.3.0/24"

private_subnet_2 = "10.0.4.0/24"

############################################################
# Availability Zones
############################################################

az1 = "ap-south-2a"

az2 = "ap-south-2b"

############################################################
# Amazon EKS
############################################################

cluster_name = "Monitoring-Kubernetes-eks"

kubernetes_version = "1.30"

############################################################
# Worker Node Configuration
############################################################

node_group_name = "Monitoring-Kubernetes-node-group"

instance_types = [
  "c7i-flex.large"
]

ami_type = "AL2023_x86_64_STANDARD"

disk_size = 30

capacity_type = "ON_DEMAND"

############################################################
# Auto Scaling Configuration
############################################################

desired_size = 2

min_size = 2

max_size = 2

############################################################
# Kubernetes API Endpoint
############################################################

endpoint_public_access = true

endpoint_private_access = true

public_access_cidrs = [
  "0.0.0.0/0"
]

############################################################
# CloudWatch Logging
############################################################

log_retention_days = 30

cluster_log_types = [

  "api",

  "audit",

  "authenticator",

  "controllerManager",

  "scheduler"

]

############################################################
# IAM Roles for Service Accounts (IRSA)
############################################################

enable_irsa = true

############################################################
# Kubernetes Node Labels
############################################################

node_labels = {

  Environment = "dev"

  Project = "Monitoring-Kubernetes-deployment"

}

############################################################
# Additional AWS Tags
############################################################

additional_tags = {

  Owner = "Ravi"

  ManagedBy = "Terraform"

  Environment = "dev"

  Project = "Monitoring-Kubernetes-deployment"

}

############################################################
# CloudWatch
############################################################

alarm_email = "ravitejabodla1108@gmail.com"

cpu_threshold = 80

############################################################
# Database Credentials
############################################################

db_username = "admin"

db_password = "ChangeMe123!"

############################################################
# Memory Alarm Threshold
############################################################

memory_threshold = 80