provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.stack_name}-${var.environment}"

  cidr = "10.0.0.0/16"

  azs             = "${var.aws_azs}"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  assign_generated_ipv6_cidr_block = true
  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = {
    Owner       = "DevOpsTerraform"
    Environment = "${var.environment}"
    StackName   = "${var.stack_name}"
  }
}

resource "aws_kms_key" "s3key" {
  description             = "KMS S3 1"
  deletion_window_in_days = 10
}

module "django_abl" {
  source              = "../modules/django_alb"
  name                = "djangoalb"
  vpc_id              = "${module.vpc.vpc_id}"
  alb_subnets         = "${join(",", "${module.vpc.public_subnets}")}"
  alb_security_groups = "${aws_security_group.alb.id}"
  alb_certificate_arn = "${aws_acm_certificate.ssl_cert.arn}"

  tags = {
    Owner       = "DevOpsTerraform"
    Name        = "djangoalb"
    Environment = "${var.environment}"
    StackName   = "${var.stack_name}"
  }
}

module "django_fargate" {
  source               = "../modules/django_fargate"
  name                 = "pollsapi"
  aws_region           = "${var.aws_region}"
  django_image_url     = "${var.django_image_url}"
  alb_target_group_arn = "${module.django_abl.alb_target_group_arn}"
  private_subnets      = "${module.vpc.private_subnets}"
  ecs_sg_id            = "${aws_security_group.ecs.id}"
  DB_USERNAME          = "admin"
  DB_PASSWORD          = "${var.auora_password}"
  DB_SERVER            = "${module.rds_cluster_aurora_mysql_serverless.endpoint}"
  DB_NAME              = "${var.auora_db_name}"

  tags = {
    Owner       = "DevOpsTerraform"
    Name        = "pollapi"
    Environment = "${var.environment}"
    StackName   = "${var.stack_name}"
  }
}
