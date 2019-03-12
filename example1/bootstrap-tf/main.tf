module "terraform-bucket" {
  source      = "modules/s3-wVersioning"
  bucket_name = "${var.aws_account_number}-${var.aws_region}-terraform"
  versioning  = true
  region = "${var.aws_region}"

  kms_key_arn = "${var.aws_ksm_key}"

  tags {
    CreatedBy = "Michael Gale"
    Project   = "DevOps"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "terraform-bucket-iam-policy"
  path        = "/"
  description = "S3 policy allowing access to Terraform state objects"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "${var.aws_ksm_key}"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${module.terraform-bucket.bucket_name}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::${module.terraform-bucket.bucket_name}/*"
    }
  ]
}
EOF
}