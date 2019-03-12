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
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::${bucket}/*"
    }
  ]
}
