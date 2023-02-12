# --- compute/main.tf ---

# data "availability_zones" "available" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

/*
data "aws_ami" "ubuntu_22_04" {

  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}
*/

data "template_file" "init" {
  template = filebase64("scripts/deploy_mysite.sh.tpl")

  vars = {
    UNIQUE_IDENTIFIER = var.UNIQUE_IDENTIFIER
    ARTIFACT = var.ARTIFACT
  }
}

resource "aws_launch_template" "web" {
  name_prefix            = "web"
  image_id               = data.aws_ami.amazon_linux.id
  instance_type          = var.web_instance_type
  vpc_security_group_ids = [var.web_sg]
  user_data              = data.template_file.init.rendered

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "web"
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "web"
  vpc_zone_identifier = tolist(var.public_subnet)
  min_size            = 2
  max_size            = 3
  desired_capacity    = 2
  min_elb_capacity    = 2
  health_check_type   = "ELB"
  load_balancers      = [aws_elb.web.name] 

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = {
      Name  = "webserver"
      Owner = "Yevhen Yakymov"
    }
    content {
    key                 = tag.key
    value               = tag.value
    propagate_at_launch = true
    }
  }

    lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "${var.UNIQUE_IDENTIFIER}-webserver"
  subnets            = tolist(var.public_subnet)
  # availability_zones = tolist(var.public_subnet)
  # availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  security_groups    = [var.web_sg]

  
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }

  tags = {
    "Name" = "webserver-elb"
  }
}