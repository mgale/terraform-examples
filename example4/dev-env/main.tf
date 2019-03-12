provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.stack_name}"

  cidr = "10.0.0.0/16"

  azs             = "${var.aws_azs}"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  assign_generated_ipv6_cidr_block = true
  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support = true

  enable_nat_gateway = true
  single_nat_gateway = false

  tags = {
    Owner       = "DevOpsTerraform"
    Environment = "${var.stack_name}"
  }

  vpc_tags = {
    Name = "${var.stack_name}"
  }
}

