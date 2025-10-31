# Specify the provider
provider "aws" {
  region = "us-east-1"
}

# Create a security group to allow HTTP traffic
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = "default" # Replace with your VPC ID if needed

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "WebSecurityGroup"
    Environment = "Production"
  }
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name        = "WebServer"
    Environment = "Production"
  }
}

# Allocate and associate an Elastic IP with the instance
resource "aws_eip" "web_eip" {
  instance = aws_instance.web_server.id

  tags = {
    Name        = "WebServerEIP"
    Environment = "Production"
  }
}
