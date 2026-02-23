output "instance_id" {
  description = "EC2 Instance ID — use with SSM: aws ssm start-session --target <this>"
  value       = aws_instance.jumppoint.id
}

output "private_ip" {
  description = "Jump Point Private IP — THIS IS YOUR JP_IP for Step 5 security group rules"
  value       = aws_instance.jumppoint.private_ip
}

output "public_ip" {
  description = "Public IP (used for outbound internet to BeyondTrust Cloud)"
  value       = aws_instance.jumppoint.public_ip
}

output "ami_id" {
  description = "AMI ID used (Amazon Linux 2023)"
  value       = data.aws_ami.al2023.id
}

output "iam_role_name" {
  description = "IAM Role name attached to the instance"
  value       = aws_iam_role.jumppoint_ssm.name
}

output "ssm_connect_command" {
  description = "Copy-paste this to connect via SSM"
  value       = "aws ssm start-session --target ${aws_instance.jumppoint.id}"
}