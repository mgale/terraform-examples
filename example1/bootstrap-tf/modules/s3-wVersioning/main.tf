variable bucket_name {}
variable kms_key_arn {}

variable versioning {
  default = "true"
}

variable region {}


variable tags {
  type = "map"
}

# Who is allowed to use the bucket
variable "principal_list" {
  type    = "list"
  default = []
}

data "template_file" "policy" {
  template = "${file("${path.module}/policy.json.tpl")}"

  vars {
    principal_list = "${join(",\n", formatlist("\"%s\"", var.principal_list))}"
    bucket         = "${var.bucket_name}"
  }
}

resource "aws_s3_bucket" "kmsEncrypted-wVersioning" {
  bucket = "${var.bucket_name}"
  region = "${var.region}"
  acl    = "private"
  policy = "${data.template_file.policy.rendered}"

  versioning {
    enabled = "${var.versioning}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${var.kms_key_arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # merge: Defaults go first, passed tags can override defaults.
  tags = "${merge(
    map(
      "Terraform", "true",
      "Name", "${var.bucket_name}",
      "Project", "TerraForm"
    ),
    "${var.tags}"
  )}"
}

output "bucket_name" {
  value = "${var.bucket_name}"
}
