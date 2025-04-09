resource "aws_autoscaling_group" "AS_gp" {
  desired_capacity     = 3
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = [                          
    aws_subnet.pub_subnet1.id,
    aws_subnet.pub_subnet2.id,
    aws_subnet.pub_subnet3.id
    ] 
  target_group_arns    = [aws_lb_target_group.asgapp_tg.arn]
  health_check_type    = "EC2"
  health_check_grace_period = 300
  
  launch_template {
    id      = aws_launch_template.Web_end2end_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "AS_gp_instance"
    propagate_at_launch = true
  }
}

# Create a new load balancer attachment
# resource "aws_autoscaling_attachment" "ASG_attachment1" {
#   autoscaling_group_name = aws_autoscaling_group.AS_gp.id
# }

# Create a new ALB Target Group attachment
# resource "aws_autoscaling_attachment" "ASG_attachment2" {
#   autoscaling_group_name = aws_autoscaling_group.AS_gp.id
#   lb_target_group_arn    = aws_lb_target_group.ASGapp_tg.arn
# }
