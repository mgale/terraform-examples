module "rds_cluster_aurora_mysql_serverless" {
  source          = "git::https://github.com/cloudposse/terraform-aws-rds-cluster.git?ref=master"
  namespace       = "django"
  stage           = "${var.environment}"
  name            = "db"
  engine          = "aurora"
  engine_mode     = "serverless"
  cluster_family  = "aurora5.6"
  cluster_size    = "0"
  admin_user      = "admin"
  admin_password  = "${var.auora_password}"
  db_name         = "${var.auora_db_name}"
  db_port         = "3306"
  instance_type   = "${var.aurora_instance_type}"
  vpc_id          = "${module.vpc.vpc_id}"
  security_groups = ["${aws_security_group.alb.id}", "${aws_security_group.ecs.id}"]
  subnets         = "${module.vpc.private_subnets}"

  scaling_configuration = [
    {
      auto_pause               = true
      max_capacity             = "${var.aurora_max_capacity}"
      min_capacity             = "${var.aurora_min_capacity}"
      seconds_until_auto_pause = "${var.aurora_auto_pause_seconds}"
    },
  ]

  tags = {
    Owner       = "DevOpsTerraform"
    Environment = "${var.environment}"
    StackName   = "${var.stack_name}"
  }
}
