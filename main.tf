resource "aws_vpc" "ASG_network" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_instance_tenancy
  tags = var.tag_overlay 
}

resource "aws_internet_gateway" "ASG_igw" {
  vpc_id = aws_vpc.ASG_network.id

  tags = {
    Name = "ASG_igw"
  }
}

# resource "aws_internet_gateway_attachment" "ASG_igw_attachment" {
#   internet_gateway_id = aws_internet_gateway.ASG_igw.id
#   vpc_id              = aws_vpc.ASG_network.id
# }

resource "aws_subnet" "pub_subnet1" {
  vpc_id     = aws_vpc.ASG_network.id
  cidr_block = var.pub_subnet1_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet1"
  }
}

resource "aws_subnet" "pub_subnet2" {
  vpc_id     = aws_vpc.ASG_network.id
  cidr_block = var.pub_subnet2_cidr_block
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet2"
  }
}

resource "aws_subnet" "pub_subnet3" {
  vpc_id     = aws_vpc.ASG_network.id
  cidr_block = var.pub_subnet3_cidr_block
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet3"
  }
}

resource "aws_subnet" "priv_subnet1" {
  vpc_id     = aws_vpc.ASG_network.id
  cidr_block = var.priv_subnet1_cidr_block

  tags = {
    Name = "priv_subnet1"
  }
}

resource "aws_subnet" "priv_subnet2" {
  vpc_id     = aws_vpc.ASG_network.id
  cidr_block = var.priv_subnet2_cidr_block


  tags = {
    Name = "priv_subnet2"
  }
}

resource "aws_route_table" "pub-RT1"{
  vpc_id = aws_vpc.ASG_network.id

  route {
    cidr_block = var.pub-RT1_cidr_block
    gateway_id = aws_internet_gateway.ASG_igw.id
  }
}

# resource "aws_route_table" "pub-RT2"{
#   vpc_id = aws_vpc.ASG_network.id

#   route {
#     cidr_block = var.pub-RT2_cidr_block
#     gateway_id = aws_internet_gateway.ASG_igw.id
#   }
# }

resource "aws_route_table" "pub-RT3"{
  vpc_id = aws_vpc.ASG_network.id

  route {
    cidr_block = var.pub-RT3_cidr_block
    gateway_id = aws_internet_gateway.ASG_igw.id
  }
}

# resource "aws_route_table" "priv-RT1"{
#   vpc_id = aws_vpc.ASG_network.id

#   route {
#     cidr_block = var.priv-RT1_cidr_block
#     gateway_id = aws_nat_gateway.ASG_ngw.id
#   }
# }

# resource "aws_route_table" "priv-RT2"{
#   vpc_id = aws_vpc.ASG_network.id

#   route {
#     cidr_block = var.priv-RT2_cidr_block
#     gateway_id = aws_nat_gateway.ASG_ngw.id
#   }
# }

resource "aws_nat_gateway" "ASG_ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub_subnet3.id

  tags = {
    Name = "ASG_ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ASG_igw, aws_eip.eip]
}

resource "aws_eip" "eip" {
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.pub_subnet1.id
  route_table_id = aws_route_table.pub-RT1.id
}

# resource "aws_route_table_association" "rt2" {
#   subnet_id      = aws_subnet.pub_subnet2.id
#   route_table_id = aws_route_table.pub-RT2.id
# }

resource "aws_route_table_association" "rt3" {
  subnet_id      = aws_subnet.pub_subnet3.id
  route_table_id = aws_route_table.pub-RT3.id
}

# resource "aws_route_table_association" "rt5" {
#   subnet_id      = aws_subnet.priv_subnet2.id
#   route_table_id = aws_route_table.priv-RT2.id
# }

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow traffic from ALB"
  vpc_id      = aws_vpc.ASG_network.id

    ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 👈 Only from ALB SG
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.ASG_network.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS traffic"
  vpc_id      = aws_vpc.ASG_network.id

  ingress {
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
    Name = "allow_tls"
  }
}

resource "aws_security_group" "asg_ec2_sg" {
  name        = "asg-ec2-sg"
  description = "Security group for ASG EC2 instances"
  vpc_id      = aws_vpc.ASG_network.id  # must be the same VPC as the ALB and subnets

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Allow traffic from the ALB SG
  }

  ingress {
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.alb_sg.id]  # Allow SSH traffic from the ALB SG
}

  ingress {
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  security_groups = [aws_security_group.alb_sg.id]  # Allow SSH traffic from the ALB SG
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "asg-ec2-sg"
  }
}




