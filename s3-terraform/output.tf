output "bucket_id" {
  description = "ID of the remote bucket"
  value       = aws_s3_bucket.main_s3.id
}
