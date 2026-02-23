
###############################################################################
# variables.tf — All variable definitions for the Jump Point Terraform config
#
# These define WHAT variables exist and their defaults.
# Your actual values go in terraform.tfvars (separate file).
###############################################################################

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID for monitor-prod"
  type        = string
  default     = "vpc-61bc0119"
}

variable "subnet_id" {
  description = "Public subnet ID in monitor-prod VPC. Find via: VPC → Subnets → filter by vpc-61bc0119"
  type        = string
  # No default — you MUST provide this in terraform.tfvars
}

variable "security_group_id" {
  description = "Security Group ID created in Step 1 (sg-beyondtrust-jumppoint)"
  type        = string
  # No default — you MUST provide this in terraform.tfvars
}

variable "instance_type" {
  description = "EC2 instance type for the Jump Point"
  type        = string
  default     = "t3.small"
}

variable "volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 20
}