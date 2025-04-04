resource "aws_s3_bucket" "photos" {
  bucket = var.bucket_name
  force_destroy = true
}