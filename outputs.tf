# Output the public IP address of the EC2 instance

output "nodejs_instance_1_public_ip" {
  value = aws_instance.ec2_instance_1.public_ip
}

output "nodejs_instance_2_public_ip" {
  value = aws_instance.ec2_instance_2.public_ip
}
