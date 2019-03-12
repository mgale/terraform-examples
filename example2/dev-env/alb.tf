resource "aws_alb" "neo4j" {
  name = "neo4j"
  internal = false

  security_groups = [
    "${aws_security_group.ecs.id}",
    "${aws_security_group.alb.id}",
  ]

  subnets = [
    "${module.vpc.public_subnets[0]}",
    "${module.vpc.public_subnets[1]}"
  ]
}

resource "aws_alb_target_group" "neo4j" {
  name = "neo4j"
  protocol = "HTTP"
  port = "7474"
  vpc_id = "${module.vpc.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/"
  }
}

resource "aws_alb_listener" "neo4j" {
  load_balancer_arn = "${aws_alb.neo4j.arn}"
  port = "7474"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.neo4j.arn}"
    type = "forward"
  }

  depends_on = ["aws_alb_target_group.neo4j"]
}

resource "aws_alb_target_group" "neo4jwebsocket" {
  name = "neo4jwebsocket"
  protocol = "HTTP"
  port = "7687"
  vpc_id = "${module.vpc.vpc_id}"
  target_type = "ip"

  health_check {
    path = "/"
    port = 7474
  }
}
resource "aws_alb_listener" "neo4jwebsocket" {
  load_balancer_arn = "${aws_alb.neo4j.arn}"
  port = "7687"
  protocol = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.neo4jwebsocket.arn}"
    type = "forward"
  }

  depends_on = ["aws_alb_target_group.neo4j"]
}

output "alb_dns_name" {
  value = "${aws_alb.neo4j.dns_name}"
}