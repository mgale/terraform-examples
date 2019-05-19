{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          ${principal_list}
        ]
      },
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::${bucket}"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          ${principal_list}
        ]
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${bucket}/*"
    },
    {
    "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${bucket}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${bucket}/*"
        }
  ]
}