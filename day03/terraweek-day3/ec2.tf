resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH Access"

  ingress {
    description      = "SSH Access From Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "terraform-instance" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = var.keypair
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    tags = {
        Name = "terraform-instance"
    }

    provisioner "local-exec" {
        command = "echo \"The Server's IP Address is ${self.public_ip}\""
    }

    provisioner "local-exec" {
        when = destroy
        command = "echo \"Server ${self.public_ip} has been destroyed\"" 
    }

    lifecycle {
      prevent_destroy = false
    }
}

output "terraform-instance-ip" {
    value = aws_instance.terraform-instance.public_ip   
}
