resource "aws_iam_policy" "velero_iam_policy" {
    name = "velero-iam-policy-${random_integer.this.id}"
    path = "/"
    description = "Velero service account IAM permissions."
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "ec2:DescribeVolumes",
                    "ec2:DescribeSnapshots",
                    "ec2:CreateTags",
                    "ec2:CreateVolume",
                    "ec2:CreateSnapshot",
                    "ec2:DeleteSnapshot"
                ]
                Effect   = "Allow"
                Resource = "*"
            },
            {
                Action = [
                  "s3:GetObject",
                  "s3:DeleteObject",
                  "s3:PutObject",
                  "s3:AbortMultipartUpload",
                  "s3:ListMultipartUploadParts"
                ]
                Effect   = "Allow"
                Resource = [
                    "${aws_s3_bucket.this.arn}/*",
                ]
            },
            {
                Action = [
                    "s3:ListBucket"
                ]
                Effect   = "Allow"
                Resource = [
                    "${aws_s3_bucket.this.arn}"
                ]
            }
        ]
    })
}

resource "aws_iam_role" "role" {
  name = "velero-service-account-iam-role-${random_integer.this.id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.oidc_provider_uri}"
        }
        Condition = {
          StringEquals = {
            "${var.oidc_provider_uri}:aud": "sts.amazonaws.com",
            "${var.oidc_provider_uri}:sub": "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      },
    ]
  })
}


resource "aws_iam_role_policy_attachment" "velero_attachment" {
  policy_arn = aws_iam_policy.velero_iam_policy.arn
  role       = aws_iam_role.role.name
}
