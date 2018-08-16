###############
# IAM policies
###############
data "aws_iam_policy_document" "cloudwatch_lambda_policy_document" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

data "aws_iam_policy_document" "ec2_lambda_policy_document" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeImages",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeAvailabilityZones",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:StopInstances",
      "ec2:StartInstances",
    ]

    resources = [
      "arn:aws:ec2:*:*:instance/*",
    ]
  }
}

data "aws_iam_policy_document" "lambda_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "cloudwatch_lambda_policy" {
  name   = "rg-tf-wow-vanilla-server-cloudwatch"
  role   = "${aws_iam_role.lambda_execution_role.id}"
  policy = "${data.aws_iam_policy_document.cloudwatch_lambda_policy_document.json}"
}

resource "aws_iam_role_policy" "ec2_lambda_policy" {
  name   = "rg-tf-wow-vanilla-server-ec2"
  role   = "${aws_iam_role.lambda_execution_role.id}"
  policy = "${data.aws_iam_policy_document.ec2_lambda_policy_document.json}"
}

###########
# IAM role
###########
resource "aws_iam_role" "lambda_execution_role" {
  name        = "rg-tf-wow-vanilla-server-lambda"
  description = "Allows CloudWatch to invoke Lambda and Lambda to invoke EC2"

  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy_document.json}"
}
