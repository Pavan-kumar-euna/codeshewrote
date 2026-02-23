terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "BeyondTrust-POC"
      ManagedBy   = "Terraform"
      Environment = "Production"
    }
  }
}


###############################################################################
# DATA SOURCES
###############################################################################

# Automatically find the latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Trust policy — allows EC2 instances to assume the IAM role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


###############################################################################
# IAM ROLE + INSTANCE PROFILE (for SSM Session Manager access)
###############################################################################

resource "aws_iam_role" "jumppoint_ssm" {
  name               = "BeyondTrust-JumpPoint-SSM-Role"
  description        = "Allows the BeyondTrust Jump Point EC2 to use SSM Session Manager"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Purpose = "Marketplace-Prod-JumpPoint"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.jumppoint_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "jumppoint_ssm" {
  name = "BeyondTrust-JumpPoint-SSM-Profile"
  role = aws_iam_role.jumppoint_ssm.name
}


###############################################################################
# EC2 INSTANCE — The Jump Point server
###############################################################################

resource "aws_instance" "jumppoint" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = aws_iam_instance_profile.jumppoint_ssm.name
  associate_public_ip_address = true

  # No key pair — we use SSM Session Manager for access

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  monitoring = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Forces IMDSv2
    http_put_response_hop_limit = 1
  }

  tags = {
    Name          = "BeyondTrust-JumpPoint-Marketplace"
    Purpose       = "Marketplace-Prod-JumpPoint"
    ManagedBy     = "BeyondTrust-PRA"
    BackoutPlan   = "Remove JumpPoint and restore home IP SG rules"
    JumpPointType = "Marketplace-Prod-App, Marketplace-Prod-DB"
  }

  # Uncomment for production to prevent accidental deletion:
  # disable_api_termination = true
}