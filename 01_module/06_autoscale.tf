# Make AMI for Auto Scaling

resource "aws_ami_from_instance" "jypark_web_id" {
    name               = "jypark-web-id"
    source_instance_id = aws_instance.jypark_web.id

    depends_on = [
		aws_instance.jypark_web
	]
}

# Auto Scaling Configuration

resource "aws_launch_configuration" "jypark_as_conf" {
    name_prefix   = "jypark-web-"
    image_id      = aws_ami_from_instance.jypark_web_id.id
    instance_type = "t2.micro"
    iam_instance_profile = "admin_role"
    security_groups = [aws_security_group.jypark_allow_http.id]
    key_name = "tf key"
    user_data =<<-EOF
                  #!/bin/bash
                  systemctl restart httpd
                  systemctl enable httpd
                  EOF

    lifecycle {
      create_before_destroy = true
    }
}

# resource "aws_placement_group" "jypark_pg" {
  #   name     = "jypark-pg"
  #   strategy = "cluster"
# }

resource "aws_autoscaling_group" "jypark_ag" {
    name                      = "jypark-ag"
    max_size                  = 8
    min_size                  = 2
    health_check_grace_period = 300
    health_check_type         = "ELB"
    desired_capacity          = 2
    force_delete              = true
    # placement_group           = aws_placement_group.jypark_pg.id
    launch_configuration      = aws_launch_configuration.jypark_as_conf.name
    vpc_zone_identifier       = [aws_subnet.jypark_pub[0].id,aws_subnet.jypark_pub[1].id]
}

# Auto Scaling - ALB Target Group Attachment

resource "aws_autoscaling_attachment" "jypark_asg_attachment" {
    autoscaling_group_name 	  = aws_autoscaling_group.jypark_ag.id
    alb_target_group_arn   	  = aws_lb_target_group.jypark_lb_tg.arn
}