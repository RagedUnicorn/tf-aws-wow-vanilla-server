############
# S3 Bucket
############
resource "aws_s3_bucket" "vanilla_backup" {
  bucket = "rg-tf-wow-vanilla-backup"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Type         = "rg-generated"
    Organization = "ragedunicorn"
    Name         = "tf-wow-vanilla-backup"
    Description  = "Ragedunicorn WoW-Vanilla-Server S3 backup bucket"
    Environment  = "prod"
  }
}
