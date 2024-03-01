# S3 bucket for storing backups
resource "aws_s3_bucket" "this" {
  bucket = "velero-backups-storage-location-${random_integer.this.id}"
}