data "template_file" "neo4j" {
  template = "${file("templates/neo4j.json.tpl")}"
  vars {
    REPOSITORY_URL = "neo4j"
    AWS_REGION = "${var.aws_region}"
    LOGS_GROUP = "${aws_cloudwatch_log_group.neo4j.name}"
  }
}

#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
resource "aws_ecs_task_definition" "neo4j" {
  family                = "neo4j"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = 2048
  memory = 4096
  container_definitions = "${data.template_file.neo4j.rendered}"
  execution_role_arn = "${aws_iam_role.ecs_task_assume.arn}"
}

resource "aws_ecs_service" "neo4jhttp" {
  name            = "neo4j"
  cluster         = "${aws_ecs_cluster.fargate.id}"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.neo4j.arn}"
  desired_count   = 1

  network_configuration = {
    subnets = ["${module.vpc.private_subnets[0]}"]
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  load_balancer {
   target_group_arn = "${aws_alb_target_group.neo4j.arn}"
   container_name = "neo4j"
   container_port = 7474
  }

  depends_on = [
    "aws_alb_listener.neo4j"
  ]
}

resource "aws_ecs_service" "neo4jwebsocket" {
  name            = "neo4jwebsocket"
  cluster         = "${aws_ecs_cluster.fargate.id}"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.neo4j.arn}"
  desired_count   = 1

  network_configuration = {
    subnets = ["${module.vpc.private_subnets[0]}"]
    security_groups = ["${aws_security_group.ecs.id}"]
  }

  load_balancer {
   target_group_arn = "${aws_alb_target_group.neo4jwebsocket.arn}"
   container_name = "neo4j"
   container_port = 7687
  }

  depends_on = [
    "aws_alb_listener.neo4j"
  ]
}
