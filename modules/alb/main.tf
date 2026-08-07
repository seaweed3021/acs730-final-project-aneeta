# trivy:ignore:AVD-AWS-0053 Public-facing ALB is intentional - this is the internet entry point for the web app
resource "aws_lb" "web" {
  name                     = "${lower(var.name_prefix)}-${var.env_name}-alb"
  internal                 = false
  load_balancer_type       = "application"
  security_groups          = [var.alb_sg_id]
  subnets                  = var.public_subnet_ids
  drop_invalid_header_fields = true

  tags = {
    Name        = "${var.name_prefix}-${var.env_name}-Alb"
    Environment = var.env_name
  }
}

resource "aws_lb_target_group" "web" {
  name     = "${lower(var.name_prefix)}-${var.env_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
  }

  tags = {
    Name        = "${var.name_prefix}-${var.env_name}-Tg"
    Environment = var.env_name
  }
}

# trivy:ignore:AVD-AWS-0054 HTTPS requires an ACM certificate and a registered domain, which is out of scope for this AWS Academy Learner Lab assignment
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}