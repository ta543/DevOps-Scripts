resource "aws_s3_account_public_access_block" "block-public" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# XXX: Edit
resource "aws_s3_bucket" "mybucket" {
  bucket = "${var.project_name}-mybucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }

  versioning {
    enabled = true
    #mfa_delete = true  # default: false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# policy to prevent any public access        XXX: Edit
resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id # XXX: Edit

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ============================================================================ #
#                             G C P   B u c k e t s
# ============================================================================ #

# XXX: edit
resource "google_storage_bucket" "mybucket" {
  # XXX: edit
  #name                        = "${var.project_name}-mybucket"
  name                        = "${var.project_id}-mybucket"
  location                    = "EU"
  uniform_bucket_level_access = true # XXX: GCS defaults to fine-grained security otherwise, which is more likely to have a human misconfiguration data leak
}
