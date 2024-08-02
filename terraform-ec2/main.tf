provider "aws" {
  region = "ca-central-1" # Change to your preferred region
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Allow SSH and HTTP"
  vpc_id      = "" # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "jenkins" {
  ami           = "ami-0abcdef1234567890" # 
  instance_type = "t2.micro" 
  key_name      = "mynewkey" 

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install jenkins java-1.8.0-openjdk-devel -y
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  subnet_id              = "" # Replace with your subnet ID

  tags = {
    Name = "Jenkins Server"
  }
}
