# Application Load Balancer

resource "aws_lb" "jypark_alb" {
    name               = "${var.name}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.jypark_allow_http.id]
    subnets            = [aws_subnet.jypark_pub[0].id,aws_subnet.jypark_pub[1].id]

    # enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.bucket
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

    tags = {
      Environment = "production"
    }
}

# Application Load Balancer Target Group

resource "aws_lb_target_group" "jypark_lb_tg" {
    name        = "${var.name}-lb-tg"
    port        = var.port_num.http
    protocol    = var.protocol.http
    # target_type = "ip"
    vpc_id      = aws_vpc.jypark_vpc.id

      health_check {
          enabled             = true
          healthy_threshold   = 3
          interval            = 5
          matcher             = "200"
          path                = "/"
          port                = "traffic-port"
          protocol            = var.protocol.http
          timeout             = 2
          unhealthy_threshold = 2
      }
}

# Application Load Balancer Listener

resource "aws_lb_listener" "jypark_lb_front" {
    load_balancer_arn = aws_lb.jypark_alb.arn
    port              = var.port_num.http
    protocol          = var.protocol.http
  #   ssl_policy        = "ELBSecurityPolicy-2016-08"
  #   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.jypark_lb_tg.arn
    }
  }

  # data "aws_instances" "test1" {
  #   instance_tags = {
  #     Name = "jypark-web-a1"
  #   }
  # }

  # data "aws_instances" "test2" {
  #   instance_tags = {
  #     Name = "jypark-web-c1"
  #   }
# }

resource "aws_lb_target_group_attachment" "jypark_lb_tg_ass" {
    target_group_arn = aws_lb_target_group.jypark_lb_tg.arn
    target_id        = aws_instance.jypark_web.id
    port             = var.port_num.http
}