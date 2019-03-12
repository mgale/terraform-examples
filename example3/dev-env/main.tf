provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "stack" {
  source      = "/media/psf/Home/Workspace/personal/code/stack" # the module source
  name        = "mgale-web" # the name for our project
  environment = "${var.environment}"
  key_name    = "team-ci-key" # reference a key you've previously created
}
