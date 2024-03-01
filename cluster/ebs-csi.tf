# # Datasource: EBS CSI IAM Policy get from EBS GIT Repo (latest)
data "http" "eks_cluster_ebs_csi_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"
  request_headers = {
    Accept = "application/json"
  }
}

output "eks_cluster_ebs_csi_iam_policy" {
  value = data.http.eks_cluster_ebs_csi_iam_policy.response_body
}


# Resource: Create EBS CSI IAM Policy 
resource "aws_iam_policy" "ebs_csi_iam_policy" {
  name        = "${var.eks_name}-AmazonEKS_EBS_CSI_Driver_Policy"
  path        = "/"
  description = "EBS CSI IAM Policy"
  policy = data.http.eks_cluster_ebs_csi_iam_policy.response_body
}

output "eks_cluster_ebs_csi_iam_policy_arn" {
  value = aws_iam_policy.ebs_csi_iam_policy.arn
}
# # Resource: Create IAM Role and associate the EBS IAM Policy to it
resource "aws_iam_role" "ebs_csi_iam_role" {
  name = "${var.eks_name}-ebs-csi-iam-role"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.oidc_provider.arn}"
        }
        Condition = {
          StringEquals = {            
            "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }        

      },
    ]
  })

  tags = {
    tag-key = "${var.eks_name}-ebs-csi-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSEBSDriverPolicyAttachment" {
  policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn
  role = aws_iam_role.ebs_csi_iam_role.name
}

resource "aws_eks_addon" "eks_cluster_ebs_csi_addon" {
  cluster_name             = var.eks_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.25.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi_iam_role.arn
  depends_on = [
    aws_iam_policy.ebs_csi_iam_policy,
    aws_iam_role.ebs_csi_iam_role,
    aws_eks_node_group.this
  ]
  tags = {
    tag-key = "${var.eks_name}-ebs-csi-addon"
  }
}

# # Associate EBS CSI IAM Policy to EBS CSI IAM Role
# resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn 
#   role       = aws_iam_role.ebs_csi_iam_role.name
# }

# output "ebs_csi_iam_role_arn" {
#   description = "EBS CSI IAM Role ARN"
#   value = aws_iam_role.ebs_csi_iam_role.arn
# }

# resource "aws_eks_addon" "ebs_eks_addon" {
#   depends_on = [aws_iam_role.ebs_csi_iam_role, aws_eks_node_group.this ]
#   addon_name = "aws-ebs-csi-driver"
#   cluster_name = aws_eks_cluster.this.name
#   service_account_role_arn = aws_iam_role.ebs_csi_iam_role.arn 
#   addon_version = "v1.12.1-eksbuild.1"
# }

# resource "kubernetes_storage_class_v1" "ebs_storage_class" {
#   metadata {
#     name = "${aws_eks_cluster.this.name}-sc"
#   }
#   storage_provisioner = "ebs.csi.aws.com"
#   volume_binding_mode = "WaitForFirstConsumer"
# }

# # resource "kubernetes_persistent_volume_claim_v1" "pvc" {
# #   metadata {
# #     name = "${aws_eks_cluster.this.name}-pvc"
# #   }
# #   spec {
# #     access_modes = [ "ReadWriteOnce" ]
# #     storage_class_name = kubernetes_storage_class_v1.ebs_storage_class.metadata.0.name
# #     resources {
# #       requests = {
# #         storage = "5Gi"
# #       }
# #     }
# #   }
# # }

# /******** DO NOT REMOVE **************/
# # Install EBS CSI Driver using HELM
# # Resource: Helm Release 
# # resource "helm_release" "ebs_csi_driver" {
# #   depends_on = [aws_iam_role.ebs_csi_iam_role, aws_eks_cluster.this]
# #   name       = "${var.eks_name}-aws-ebs-csi-driver"
# #   repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
# #   chart      = "aws-ebs-csi-driver"
# #   namespace = "kube-system"     

# #   set {
# #     name = "image.repository"
# #     value = "602401143452.dkr.ecr.eu-north-1.amazonaws.com" # Changes based on Region - This is for us-east-1 Additional Reference: https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
# #   }       

# #   set {
# #     name  = "controller.serviceAccount.create"
# #     value = "true"
# #   }

# #   set {
# #     name  = "controller.serviceAccount.name"
# #     value = "ebs-csi-controller-sa"
# #   }

# #   set {
# #     name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
# #     value = "${aws_iam_role.ebs_csi_iam_role.arn}"
# #   }
    
# # }

# # output "ebs_csi_helm_metadata" {
# #   description = "Metadata Block outlining status of the deployed release."
# #   value = helm_release.ebs_csi_driver.metadata
# # }