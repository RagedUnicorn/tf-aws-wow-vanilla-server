#####
# S3
#####
output "s3_id" {
  description = "ID of the created bucket"
  value       = aws_s3_bucket.state_store.id
}

output "s3_arn" {
  description = "The ARN of the bucket."
  value       = aws_s3_bucket.state_store.arn
}

output "s3_bucket_domain_name" {
  description = " The bucket domain name."
  value       = aws_s3_bucket.state_store.bucket_domain_name
}

output "s3_region" {
  description = "The AWS region this bucket resides in."
  value       = aws_s3_bucket.state_store.region
}

######
# IAM
######
output "iam_arn" {
  description = "The ARN assigned by AWS for this user."
  value       = aws_iam_user.wow_vanilla_server_user.arn
}

output "iam_name" {
  description = "The user's name."
  value       = aws_iam_user.wow_vanilla_server_user.name
}

output "iam_unique_id" {
  description = "The unique ID assigned by AWS."
  value       = aws_iam_user.wow_vanilla_server_user.unique_id
}

output "iam_access_key" {
  description = "The AWS access key."
  value       = aws_iam_access_key.wow_vanilla_server_key.id
}

output "iam_secret_key" {
  description = "The AWS secret key."
  value       = aws_iam_access_key.wow_vanilla_server_key.secret
}
