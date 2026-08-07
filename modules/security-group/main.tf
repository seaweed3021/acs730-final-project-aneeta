resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-${var.env_name}-AlbSg"
  description = "Allow HTTP from the internet to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
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
    Name        = "${var.name_prefix}-${var.env_name}-AlbSg"
    Environment = var.env_name
  }
}

resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-${var.env_name}-WebSg"
  description = "Allow HTTP only from the ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name_prefix}-${var.env_name}-WebSg"
    Environment = var.env_name
  }
}