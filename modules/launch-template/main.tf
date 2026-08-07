data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_instance_profile" "lab_profile" {
  name = "LabInstanceProfile"
}

resource "aws_launch_template" "web" {
  name_prefix   = "${var.name_prefix}-${var.env_name}-WebLt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = data.aws_iam_instance_profile.lab_profile.name
  }

  vpc_security_group_ids = [var.web_sg_id]

  user_data = base64encode(templatefile("${path.module}/../../scripts/user-data.sh.tpl", {
    bucket_name = var.bucket_name
    image_key   = var.image_key
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.name_prefix}-${var.env_name}-WebServer"
      Environment = var.env_name
    }
  }

  tags = {
    Name        = "${var.name_prefix}-${var.env_name}-WebLt"
    Environment = var.env_name
  }
}