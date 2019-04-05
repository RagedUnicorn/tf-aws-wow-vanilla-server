#########
# Lambda
#########
resource "aws_lambda_function" "start_stop_instance" {
  filename         = "lambda/lambda.zip"
  function_name    = "RGTFStartStopWoWVanillaServer"
  role             = "${aws_iam_role.lambda_execution_role.arn}"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = "${base64sha256(file("lambda/lambda.zip"))}"
  runtime          = "python3.6"
  timeout          = 60
}

# resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_start" {
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.start_stop_instance.function_name}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.start_instance.arn}"
# }

# resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda_stop" {
#   action        = "lambda:InvokeFunction"
#   function_name = "${aws_lambda_function.start_stop_instance.function_name}"
#   principal     = "events.amazonaws.com"
#   source_arn    = "${aws_cloudwatch_event_rule.stop_instance.arn}"
# }

resource "aws_lambda_permission" "allow_api_gateway_to_call_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.start_stop_instance.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.deployment.execution_arn}/*/*"
}
