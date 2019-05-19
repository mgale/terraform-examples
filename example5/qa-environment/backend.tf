terraform {
  backend "s3" {
    bucket  = "<aws-account>-<region>-terraform"
    key     = "tf/django-example/qa-environment/terraform.tfstate"
    region  = "<region>"
    profile = "exampleTerraform"
  }
}

#Looks like there are still a few bugs with the S3 backend
#and which credentials to use.
#I needed to set the following for terraform init to work:
#export AWS_PROFILE="exampleTerraform"

