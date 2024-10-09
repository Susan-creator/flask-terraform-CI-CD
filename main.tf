provider "aws" {
  region     = "us-east-1"  # Make sure this is your desired region
  access_key = var.aws_access_key_id  # Reference your variable or secret here
  secret_key = var.aws_secret_access_key  # Reference your variable or secret here
}


variable "cidr" {
  default = "10.0.0.0/16"
}

data "aws_key_pair" "keypair" {
  key_name   = "all-key-pair"
  
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "10.0.0.0/24"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "websg" {
  name   = "web"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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

  tags = {
    Name = "Web-sg"
  }
}

resource "aws_instance" "server" {
  ami                    = "ami-0866a3c8686eaeeba"
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",  # Update package lists
      "sudo apt install -y python3-flask",  # Install Flask
      "cd /home/ubuntu",  # Change to the home directory
      "sudo nohup python3 app.py > app.log 2>&1 &",  # Start Flask app in the background
      "echo 'Flask app started and logging to app.log'",  # Confirmation message
    ]
  }

  tags = {
    Name = "server"
  }

}
