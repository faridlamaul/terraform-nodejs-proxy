# Configure the AWS Provider with the ap-southeast-1 region
provider "aws" {
  region = "ap-southeast-1"
}

# Create a VPC
resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "app-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "app-public-subnet" {
  vpc_id     = aws_vpc.app-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "app-public-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "app-igw" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "app-igw"
  }
}

# Create a security group
resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "Allow HTTP and SSH traffic"
  vpc_id      = aws_vpc.app-vpc.id

  # Allow SSH Traffic
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP Traffic
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS Traffic
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create instance
resource "aws_instance" "app-instance" {
  # AMI for CentOS 7
  ami                    = "ami-0a8ab25085477038e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.app-public-subnet.id
  vpc_security_group_ids = aws_security_group.app-sg.id

  tags = {
    Name = "app-instance"
  }

  # Provisioner to install nginx and nodejs
  provisioner "remote-exec" {
    inline = [
      "yum update -y",
      "yum install -y epel-release",
      "yum install -y nodejs",
      "yum install -y nginx",
      "systemctl start nginx",
      "systemctl enable nginx",
      "cd /usr/share/nginx/html",
      "echo '<h1>Node.js App</h1>' > index.html",
      "cd /etc/nginx/conf.d/",
      "echo 'server { \n listen 80;\n server_name _;\n return 301 https://$host$request_uri;\n}' > redirect_to_https.conf",
      "systemctl restart nginx",
    ]
  }
}

output "nodejs_instance_public_ip" {
  value = aws_instance.app-instance.public_ip
}