terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "k8s" {
  count         = 2
  ami           = "ami-09a41e26df464c548"
  instance_type = "t2.micro"
  key_name      = "terraform"
  tags = {
    Name = "K8S-Master-0${count.index + 1}"
  }
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
}

resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "ssh"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh"
  }
}
