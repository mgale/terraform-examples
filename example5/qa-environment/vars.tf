# vars.tf: Constants related to this environment.
# The variables list below must be defined or Terraform will prompt at run time.

variable "environment" {}
variable "stack_name" {}

variable "aws_region" {
}

variable "aws_account_number" {
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_azs" {
}

variable "django_image_url" {
}

variable "aurora_instance_type" {
  default = "db.t2.small"
}

variable "auora_password" {
}

variable "auora_db_name" {
}

variable "aurora_min_capacity" {
  default = 2
}

variable "aurora_max_capacity" {
  default = 16
}

variable "aurora_auto_pause_seconds" {
  default = 300
}
