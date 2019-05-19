resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow traffic for alb"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Owner       = "DevOpsTerraform"
    Environment = "${var.environment}"
    StackName   = "${var.stack_name}"
    Terraform   = "True"
  }
}

resource "aws_security_group" "ecs" {
  name        = "ecs"
  description = "Allow traffic for ecs"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
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
    Owner       = "DevOpsTerraform"
    Environment = "${var.environment}"
    StackName   = "${var.stack_name}"
    Terraform   = "True"
  }
}
