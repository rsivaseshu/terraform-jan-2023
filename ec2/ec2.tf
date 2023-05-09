resource "aws_instance" "name" {
  ami               = var.am_id
  instance_type     = var.instance_type
  subnet_id         = data.aws_subnet.pub_sub1.id
  availability_zone = data.aws_subnet.pub_sub1.availability_zone

  vpc_security_group_ids = [aws_security_group.demo_test_sg.id]
  key_name               = "rs-mum-8"

  user_data = <<EOF
#!/bin/bash

sudo apt update -y
mkdir sample_dir
sudo apt install nginx -y

sudo echo "welcome to nginx world" >> /var/www/html/index.htl
sudo systemctl enable nginx
sudo systemctl start nginx

EOF

  tags = {
    Name = "${var.env}_demo_instance"
    env  = var.env
  }
}


resource "aws_security_group" "demo_test_sg" {
  name        = "demo-test-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_subnet.pub_sub1.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}