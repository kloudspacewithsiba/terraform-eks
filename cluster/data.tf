data "aws_region" "current" {}

data "aws_eks_cluster" "this" {
  name       = aws_eks_cluster.this.id
}

data "aws_eks_cluster_auth" "this" {
  name       = aws_eks_cluster.this.id
}

data "aws_caller_identity" "current" {}

# Datasource: AWS EBS CSI IAM Policy get from kubernetes-sigs/aws-ebs-csi-driver Repo
# The http data source makes an HTTP GET request to the given URL and exports information about the response.
# Referennce: https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http
# Reference: https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json
# data "http" "eks_cluster_ebs_csi_iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"
#   request_headers = {
#     Accept = "application/json"
#   }
# }



# ############################################################################################################
# # To get the Policy response body returned as a string
# ############################################################################################################
# output "eks_cluster_ebs_csi_iam_policy" {
#   value = data.http.eks_cluster_ebs_csi_iam_policy.response_body
# }