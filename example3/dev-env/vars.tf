# vars.tf: Constants related to this environment.
# The variables list below must be defined or Terraform will prompt at run time.

variable "stack_name" {
  default = "devenv1"
}

variable "environment" {
  default = "devenv"
}


variable "aws_region" {
    default = "us-west-2"
}

variable "aws_account_number" {
    default = "422666712471"
}

variable "aws_ksm_key" {
    default = "arn:aws:kms:us-west-2:422666712471:key/add7a6f0-d00f-4871-9cd1-fbf611d4c74a"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_azs" {
    default             = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

