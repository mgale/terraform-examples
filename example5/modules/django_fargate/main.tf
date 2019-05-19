variable "name" {}

variable "aws_region" {}

variable "django_image_url" {}

variable "alb_target_group_arn" {}

variable "DB_USERNAME" {}

variable "DB_PASSWORD" {}

variable "DB_SERVER" {}

variable "DB_NAME" {}

variable "private_subnets" {
  type = "list"
}

variable "ecs_sg_id" {}

variable "cpu" {
  default = 2048
}

variable "memory" {
  default = 4096
}

variable "container_port" {
  default = "8800"
}

variable "host_port" {
  default = "8800"
}

variable "tags" {
  type = "map"
}

data "template_file" "django_container" {
  template = "${file("${path.module}/templates/django_container_definition.json.tpl")}"

  vars {
    CONTAINER_NAME = "${var.name}"
    REPOSITORY_URL = "${var.django_image_url}"
    AWS_REGION     = "${var.aws_region}"
    LOG_GROUP_NAME = "${var.name}"
    CONTAINER_PORT = "${var.container_port}"
    HOST_PORT      = "${var.host_port}"
    DB_USERNAME    = "${var.DB_USERNAME}"
    DB_PASSWORD    = "${var.DB_PASSWORD}"
    DB_SERVER      = "${var.DB_SERVER}"
    DB_NAME        = "${var.DB_NAME}"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${var.name}"
  retention_in_days = 30

  tags = "${merge(
    map(
      "Terraform", "True",
      "Name", "${var.name}",
    ),
    "${var.tags}"
  )}"
}

resource "aws_ecs_cluster" "fargate" {
  name = "${var.name}"

  tags = "${merge(
    map(
      "Terraform", "True",
      "Name", "${var.name}",
    ),
    "${var.tags}"
  )}"
}

#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
resource "aws_ecs_task_definition" "mytask" {
  family                   = "${var.name}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"
  container_definitions    = "${data.template_file.django_container.rendered}"
  execution_role_arn       = "${aws_iam_role.ecs_task_assume.arn}"

  tags = "${merge(
    map(
      "Terraform", "True",
      "Name", "${var.name}",
    ),
    "${var.tags}"
  )}"
}

resource "aws_ecs_service" "this" {
  name        = "${var.name}"
  cluster     = "${aws_ecs_cluster.fargate.id}"
  launch_type = "FARGATE"

  task_definition = "${aws_ecs_task_definition.mytask.arn}"
  desired_count   = 1

  network_configuration = {
    subnets         = ["${var.private_subnets}"]
    security_groups = ["${var.ecs_sg_id}"]
  }

  load_balancer {
    target_group_arn = "${var.alb_target_group_arn}"
    container_name   = "${var.name}"
    container_port   = "${var.container_port}"
  }
}
