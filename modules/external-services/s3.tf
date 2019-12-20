locals {
  s3_name = "${var.prefix}-tfe-${var.install_id}"
}

resource "aws_s3_bucket" "tfe_objects" {
  bucket = "${locals.s3_name}"
  acl    = "private"

  tags = "${merge(
    var.tags,
    "Name", "${locals.s3_name}"
  )}"
}

resource "aws_s3_bucket_public_access_block" "tfe_objects" {
  bucket = "${aws_s3_bucket.tfe_objects.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
