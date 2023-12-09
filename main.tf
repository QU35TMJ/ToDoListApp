provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

# Create a Virtual Private Cloud (VPC)
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block             = "10.0.1.0/24"
  availability_zone       = "us-east-1a" # Change this to your desired availability zone
}

# Create a security group
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a virtual machine instance
resource "aws_instance" "my_instance" {
  ami             = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI, change this to your desired AMI
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  vpc_security_group_ids  = [aws_security_group.my_security_group.id]

  tags = {
    Name = "my-instance"
  }
}
