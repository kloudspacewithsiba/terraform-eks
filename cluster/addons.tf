# data "http" "ebs_csi_iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"
#   request_headers = {
#     Accept = "application/json"
#   }
# }

# resource "aws_iam_policy" "ebs_csi_iam_policy" {
#   name        = "${var.eks_name}-AmazonEKS_EBS_CSI_Driver_Policy"
#   path        = "/"
#   description = "EBS CSI IAM Policy"
#   policy = data.http.ebs_csi_iam_policy.response_body
# }

# resource "aws_iam_role" "ebs_csi_iam_role" {
#   name = "${var.eks_name}-ebs-csi-iam-role"
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
#             "${element(split("oidc-provider/", "${aws_iam_openid_connect_provider.oidc_provider.arn}"), 1)}:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
#           }
#         }        

#       },
#     ]
#   })

#   tags = {
#     tag-key = "${var.eks_name}-ebs-csi-iam-role"
#   }
# }

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
