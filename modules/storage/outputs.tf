output "bucket_name" {
  value = aws_s3_bucket.images.id
}

output "image_key" {
  value = aws_s3_object.site_image.key
}