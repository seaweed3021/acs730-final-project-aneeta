resource "aws_s3_bucket" "images" {
  bucket = "${lower(var.name_prefix)}-${var.env_name}-images-421381591322"

  tags = {
    Name        = "${var.name_prefix}-${var.env_name}-ImagesBucket"
    Environment = var.env_name
  }
}

resource "aws_s3_bucket_versioning" "images" {
  bucket = aws_s3_bucket.images.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "images" {
  bucket                  = aws_s3_bucket.images.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "site_image" {
  bucket = aws_s3_bucket.images.id
  key    = "site-image.webp"
  source = var.image_file_path
  etag   = filemd5(var.image_file_path)
}