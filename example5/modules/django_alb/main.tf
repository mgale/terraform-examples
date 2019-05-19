variable "name" {}

variable "vpc_id" {}

variable "alb_subnets" {}

variable "alb_security_groups" {}

variable "alb_certificate_arn" {}

variable "tags" {
  type    = "map"
  default = {}
}

variable "alb_port" {
  default = "8800"
}

variable "alb_health_check_path" {
  default = "/"
}

variable "alb_ssl_policy" {
  default = "ELBSecurityPolicy-2016-08"
}

resource "aws_alb" "this" {
  name     = "${var.name}"
  internal = false

  security_groups = ["${var.alb_security_groups}"]

  subnets = ["${split(",", "${var.alb_subnets}")}"]

  tags = "${merge(
    map(
      "Terraform", "True",
      "Name", "${var.name}",
    ),
    "${var.tags}"
  )}"
}

resource "aws_alb_target_group" "this" {
  name        = "${var.name}"
  protocol    = "HTTP"
  port        = "${var.alb_port}"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  health_check {
    path    = "${var.alb_health_check_path}"
    matcher = "200,202,401"
  }

  tags = "${merge(
    map(
      "Terraform", "True",
      "Name", "${var.name}",
    ),
    "${var.tags}"
  )}"
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = "${aws_alb.this.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.alb_ssl_policy}"
  certificate_arn   = "${var.alb_certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.this.arn}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.this"]
}

resource "aws_alb_listener" "http_redirect" {
  load_balancer_arn = "${aws_alb.this.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

output "alb_dns_name" {
  value = "${aws_alb.this.dns_name}"
}

output "alb_target_group_name" {
  value = "${aws_alb_target_group.this.name}"
}

output "alb_target_group_arn" {
  value = "${aws_alb_target_group.this.arn}"
}
