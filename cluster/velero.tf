module "velero" {
  source = "./velero"
  namespace = "backups"
  create_namespace = true
  service_account_name = "velero"
  create_service_account = true
  oidc_provider_uri = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)
}

# Namespace
resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = "velero"
  }
}

# # Service account 
# resource "kubernetes_service_account_v1" "this" {
#   metadata {
#     name = local.serviceAccountName
#     namespace = kubernetes_namespace_v1.this.metadata[0].name
#     annotations = {
#       "eks.amazonaws.com/role-arn": aws_iam_role.velero_service_account_iam_role.arn
#     }
#   }
# }

# # S3 bucket for storing backups
# resource "aws_s3_bucket" "this" {
#   bucket = "${var.eks_name}-velero-backups-tool"
# }

# resource "aws_iam_policy" "velero_iam_policy" {
#     name = "${var.eks_name}-velero-iam-policy"
#     path = "/"
#     description = "Velero service account IAM permissions."
#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Action = [
#                     "ec2:DescribeVolumes",
#                     "ec2:DescribeSnapshots",
#                     "ec2:CreateTags",
#                     "ec2:CreateVolume",
#                     "ec2:CreateSnapshot",
#                     "ec2:DeleteSnapshot"
#                 ]
#                 Effect   = "Allow"
#                 Resource = "*"
#             },
#             {
#                 Action = [
#                   "s3:GetObject",
#                   "s3:DeleteObject",
#                   "s3:PutObject",
#                   "s3:AbortMultipartUpload",
#                   "s3:ListMultipartUploadParts"
#                 ]
#                 Effect   = "Allow"
#                 Resource = [
#                     "${aws_s3_bucket.this.arn}/*",
#                 ]
#             },
#             {
#                 Action = [
#                     "s3:ListBucket"
#                 ]
#                 Effect   = "Allow"
#                 Resource = [
#                     "${aws_s3_bucket.this.arn}"
#                 ]
#             }
#         ]
#     })
# }

# resource "aws_iam_role" "velero_service_account_iam_role" {
#   name = "${var.eks_name}-velero-service-account-iam-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
#         }
#         Condition = {
#           StringEquals = {
#             "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)}:aud": "sts.amazonaws.com",
#             "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)}:sub": "system:serviceaccount:${kubernetes_namespace_v1.this.metadata[0].name}:${local.serviceAccountName}"
#           }
#         }
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "velero_attachment" {
#   policy_arn = aws_iam_policy.velero_iam_policy.arn
#   role       = aws_iam_role.velero_service_account_iam_role.name
# }


# resource "helm_release" "velero" {
#   depends_on = [ aws_eks_node_group.this ]
#   name = "velero"
#   namespace = "velero"
#   repository = "https://vmware-tanzu.github.io/helm-charts"
#   chart = "velero"

#   set {
#     name = "configuration.backupStorageLocation[0].provider"
#     value = "aws"
#   }

#   set {
#     name = "configuration.backupStorageLocation[0].bucket"
#     value = "${aws_s3_bucket.this.id}"
#   }

#   set {
#     name = "configuration.backupStorageLocation[0].config.region"
#     value = "${data.aws_region.current.name}"
#   }

 
#   set {
#     name = "serviceAccount.server.create"
#     value = false
#   }

#   set {
#     name = "serviceAccount.server.name"
#     value = local.serviceAccountName
#   }


#   set {
#     name = "serviceAccount.server.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = "${aws_iam_role.velero_service_account_iam_role.arn}"
#   }



#   set {
#     name = "configuration.volumeSnapshotLocation[0].name"
#     value = "k8s-prod-velero-backup-volume-location"
#   }

#   set {
#     name = "configuration.volumeSnapshotLocation[0].provider"
#     value = "aws"
#   }

#   set {
#     name = "configuration.volumeSnapshotLocation[0].config.region"
#     value = "${data.aws_region.current.name}"
#   }

#   set {
#     name = "initContainers[0].name"
#     value = "velero-plugin-for-aws"
#   }

#   set {
#     name = "initContainers[0].image"
#     value = "velero/velero-plugin-for-aws:v1.3.0"
#   }

#   set {
#     name = "initContainers[0].volumeMounts[0].mountPath"
#     value = "/target"
#   }

#   set {
#     name = "initContainers[0].volumeMounts[0].name"
#     value = "plugins"
#   }

# }



























