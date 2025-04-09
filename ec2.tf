resource "aws_launch_template" "Web_end2end_lt" {
  name_prefix   = "Web_end2end_lt"
  image_id      = var.ami
  instance_type = "t2.micro"
   key_name      = var.key_name
  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    subnet_id                  = aws_subnet.pub_subnet1.id
    security_groups = [aws_security_group.asg_ec2_sg.id, aws_security_group.alb_sg.id, aws_security_group.allow_tls.id ]
  }
  
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl restart httpd
    systemctl enable httpd
    echo "<h1>Welcome to ASG end2end domino instances</h1>" > /var/www/html/index.html
  EOF
  )

  tags = {
    Environment = "dev"
    Name        = "Web_end2end_lt"
  }
}
