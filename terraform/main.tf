provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "Never2Funky_sg" {
  name        = "Never2Funky_sg"
  description = "Allow web and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "NeverFunky_server" {
  ami                    = "ami-02a53b0d62d37a757" # Amazon Linux 2
  instance_type          = "t2.micro"
  key_name               = "terraform-urbanalex"
  security_groups        = [aws_security_group.Never2Funky_sg.name]
  user_data              = file("userdata.sh")

  provisioner "file" {
    source      = "html"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo logger 'Terraform remote-exec start'",
      "sudo logger 'Terraform remote-exec stop'"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/terraform-urbanalex.pem")
    host        = self.public_ip
  }

  tags = {
    Name = "Never2Funky"
  }
}

output "instance_ip" {
  value = aws_instance.NeverFunky_server.public_ip
}
