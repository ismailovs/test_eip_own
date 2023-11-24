resource "aws_key_pair" "cloud_2021" {
  key_name       = "cloud_2025"
  public_key     = file("~/.ssh/cloud_2025.pem.pub")
}

resource "aws_eip" "cloud_2025" {
  instance = aws_instance.web.id
  domain   = "vpc"
  tags = {
    Name = "cloud_2025_EIP"
  }
}

output "eip" {
  value = aws_eip.cloud_2025.public_ip
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "cloud_2025_IGW"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "cloud_2025_RT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}





resource "aws_instance" "web" {
  ami           = var.ami["us-east-1a"]
  instance_type = var.instance_types[0]
  subnet_id = aws_subnet.main.id
  associate_public_ip_address = true
  key_name = "cloud_2025"
  security_groups = [  ]
  vpc_security_group_ids = [module.security_groups.security_group_id["web_sg"]]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd.service
              sudo systemctl enable httpd.service
              sudo echo "<h1> At $(hostname -f) </h1>" > /var/www/html/index.html                   
              EOF

  tags = {
    Name = "cloud_2025_EC2"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cloud_2025_VPC"
  }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true # To ensure the instance gets a public IP
  tags = {
    Name = "cloud_2025_Subnet"
  }
}