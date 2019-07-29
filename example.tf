provider "aws" {
  profile    = "rands-nonprod_admin"
  region     = "eu-west-2"
}

# Create AWS S3 bucket
resource "aws_s3_bucket" "b" {
  bucket = "rt-terraform-test-bucket"
  acl    = "private"  # grantees and permissions to apply
  tags = {
    Name        = "terraform bucket"
    Environment = "Dev"
  }
  versioning {
      enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = "${aws_s3_bucket.b.id}"

  block_public_acls   = false
  block_public_policy = true
}

# Upload file to bucket
resource "aws_s3_bucket_object" "file_upload" {
  bucket = aws_s3_bucket.b.bucket
  key = "helloWorld.html"  # object name
  source = "./helloWorld.html"  # path to file to upload
  content_type = "text/html"
  acl="authenticated-read"
  # etag allows Terraform to recognise file changes
  etag = "${filemd5("./helloWorld.html")}"
}