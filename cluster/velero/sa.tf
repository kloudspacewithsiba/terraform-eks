# Service account 
resource "kubernetes_service_account_v1" "this" {
  depends_on = [aws_iam_role.role]
  count = var.create_service_account ? 1 : 0
  metadata {
    name = var.service_account_name
    namespace = var.namespace
    annotations = {
      "eks.amazonaws.com/role-arn": aws_iam_role.role.arn
    }
  }
}