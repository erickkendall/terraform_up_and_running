provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami                    = "ami-0f7919c33c90f5b58"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id, "sg-52eb493b"]
  key_name      = aws_key_pair.mykey.key_name


  user_data = <<-EOF
    #!/bin/bash
    sudo yum update
    sudo yum install httpd -y
    echo "Hello World!" > /var/www/html/index.html
    sudo service httpd start
    EOF

  connection {
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    host        = self.public_ip
  }


  tags = {
    Name = "terraform-example"
  }

}

resource "aws_security_group" "instance" {
  name = "terraform-example-instane"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}


output "public_ip" {
  value = aws_instance.example.public_ip
}
