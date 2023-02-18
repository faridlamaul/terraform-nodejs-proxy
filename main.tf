# Create random_id for suffix name of resources
resource "random_id" "random_suffix" {
  byte_length = 8
}

# Create s3 bucket for terraform state
resource "aws_s3_bucket" "terraform-state" {
  bucket        = "terraform-state-${random_id.random_suffix.hex}"
  force_destroy = true
}

# Create s3 bucket acl for terraform state
resource "aws_s3_bucket_acl" "terraform-state-acl" {
  bucket = aws_s3_bucket.terraform-state.id
  acl    = "private"
}

# Create s3 bucket versioning for terraform state
resource "aws_s3_bucket_versioning" "terraform-state-versioning" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create dynamodb table for terraform state
resource "aws_dynamodb_table" "terraform-state-lock" {
  name         = "terraform-state-lock-${random_id.random_suffix.hex}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# Create EC2 Instance 1
resource "aws_instance" "ec2_instance_1" {
  ami             = "ami-0a8ab25085477038e" # AMI for CentOS 7
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg_instances.name]
  # Install nginx and nodejs
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
              yum install -y nodejs
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              cd /usr/share/nginx/html
              echo '<h1>Node.js App 2</h1>' > index.html
              cd /etc/nginx/conf.d/
              echo 'server { \n listen 80;\n server_name _;\n return 301 https://$host$request_uri;\n}' > redirect_to_https.conf
              systemctl restart nginx
              python3 -m http.server 8080 &
              EOF
}

# Create EC2 Instance 2
resource "aws_instance" "ec2_instance_2" {
  ami             = "ami-0a8ab25085477038e" # AMI for CentOS 7
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg_instances.name]
  # Install nginx and nodejs
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              curl -sL https://rpm.nodesource.com/setup_12.x | sudo bash -
              yum install -y nodejs
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              cd /usr/share/nginx/html
              echo '<h1>Node.js App 2</h1>' > index.html
              cd /etc/nginx/conf.d/
              echo 'server { \n listen 80;\n server_name _;\n return 301 https://$host$request_uri;\n}' > redirect_to_https.conf
              systemctl restart nginx
              python3 -m http.server 8080 &
              EOF
}
