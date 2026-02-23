###############################################################################
# terraform.tfvars — Your actual values
#
# Replace the placeholder values below with your real values before running
# terraform plan / terraform apply.
###############################################################################

# AWS region where your monitor-prod VPC lives
aws_region = "us-east-1"               # ← Change to your actual region

# VPC ID for monitor-prod (from the architecture diagram)
vpc_id = "vpc-61bc0119"

# Subnet ID — the public subnet inside monitor-prod (172.50.0.0/16)
# Find it: AWS Console → VPC → Subnets → filter by VPC "vpc-61bc0119"
# Copy the Subnet ID (starts with "subnet-")
subnet_id = "subnet-XXXXXXXX"          # ← REPLACE THIS

# Security Group ID from Step 1 (sg-beyondtrust-jumppoint)
# Find it: AWS Console → EC2 → Security Groups → search "sg-beyondtrust-jumppoint"
security_group_id = "sg-XXXXXXXX"      # ← REPLACE THIS

# Instance type (t3.small is fine for a Jump Point)
instance_type = "t3.small"

# Root volume size in GiB
volume_size = 20