resource "aws_s3_bucket" "main_s3" {
  bucket = var.bucket_name

  tags = {
    Name        = "Remote backend"
    Environment = "prod"
    Creator     = "terraform"
  }
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.main_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
