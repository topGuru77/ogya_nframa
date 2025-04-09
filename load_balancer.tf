resource "aws_lb" "asgapp_alb" {
  name               = "asgapp-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    aws_subnet.pub_subnet1.id,
    aws_subnet.pub_subnet2.id,
    aws_subnet.pub_subnet3.id
  ]
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "asgapp_tg" {
  name     = "asgapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.ASG_network.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.asgapp_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asgapp_tg.arn
  }
}

