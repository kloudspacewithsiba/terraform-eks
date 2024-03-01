
resource "helm_release" "velero" {
  depends_on = [ aws_s3_bucket.this, aws_iam_role_policy_attachment.velero_attachment]
  name = "velero"
  namespace = var.namespace
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart = "velero"

  set {
    name = "configuration.backupStorageLocation[0].provider"
    value = "aws"
  }

  set {
    name = "configuration.backupStorageLocation[0].bucket"
    value = "${aws_s3_bucket.this.id}"
  }

  set {
    name = "configuration.backupStorageLocation[0].config.region"
    value = "${data.aws_region.current.name}"
  }

 
  set {
    name = "serviceAccount.server.create"
    value = false
  }

  set {
    name = "serviceAccount.server.name"
    value = var.service_account_name
  }


  set {
    name = "serviceAccount.server.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "${aws_iam_role.role.arn}"
  }



  set {
    name = "configuration.volumeSnapshotLocation[0].name"
    value = "k8s-prod-velero-backup-volume-location"
  }

  set {
    name = "configuration.volumeSnapshotLocation[0].provider"
    value = "aws"
  }

  set {
    name = "configuration.volumeSnapshotLocation[0].config.region"
    value = "${data.aws_region.current.name}"
  }

  set {
    name = "initContainers[0].name"
    value = "velero-plugin-for-aws"
  }

  set {
    name = "initContainers[0].image"
    value = "velero/velero-plugin-for-aws:v1.3.0"
  }

  set {
    name = "initContainers[0].volumeMounts[0].mountPath"
    value = "/target"
  }

  set {
    name = "initContainers[0].volumeMounts[0].name"
    value = "plugins"
  }

}