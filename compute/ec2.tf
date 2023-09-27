# -- compute/ec2.tf) -- #

locals {
  ## create the key pair with name ssh-key
  key_name = "ssh-key"
}


resource "aws_key_pair" "TF-Public-key" {
  key_name   = local.key_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-Private-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ssh-private-key"
}


resource "aws_security_group" "VPC-B-PRIVATE-SG" {
  count = var.ec2_name == "VPC-B-Private-host" ? 1 : 0
  name        = "security group for VPC-B private subnet"
  description = "Allow http/https from VPC-A public subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_a_subnet_id # VPC-A public subnet
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc_a_subnet_id
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_a_subnet_id
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-B-PRIVATE-SG"
  }
}

resource "aws_security_group" "public-example" {
  count = var.ec2_name == "VPC-A-Public-host" ? 1 : 0
  name        = "VPC-A-PUBLIC-EC2-SG"
  description = "SSH access to VPC-A public EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "ec2" {

  ami           = "ami-03a6eaae9938c858c" #Amazon Linux AMI
  instance_type = "t2.micro" #var.instance_type
  subnet_id  = var.subnet_id
  vpc_security_group_ids = [aws_security_group.security_group.id]
  
  tags = {
    Name = var.ec2_name

  }
  root_block_device {
    volume_size = "10"
  }
  user_data = var.ec2_name == "VPC-B-Private-host" ?  file("install_httpd.sh") : null

}
