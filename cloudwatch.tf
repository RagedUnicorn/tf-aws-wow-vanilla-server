###################
# Cloudwatch rules
###################

# GMT -2 effective time 23:55
# resource "aws_cloudwatch_event_rule" "stop_instance" {
#   name                = "rg-tf-wow-vanilla-server-ec2-stop-instance"
#   description         = "Stop instances nightly"
#   schedule_expression = "cron(55 21 * * ? *)"
# }

# GMT -2 effective time 17:05
# resource "aws_cloudwatch_event_rule" "start_instance" {
#   name                = "rg-tf-wow-vanilla-server-ec2-start-instance"
#   description         = "Start instances in the evening"
#   schedule_expression = "cron(5 15 * * ? *)"
# }

####################
# Cloudwatch target
####################
# resource "aws_cloudwatch_event_target" "stop_instance" {
#   rule  = "${aws_cloudwatch_event_rule.stop_instance.name}"
#   arn   = "${aws_lambda_function.start_stop_instance.arn}"
#   input = "{\"action\": \"stop\",\"region\": \"${var.aws_region}\",\"instanceId\": \"${module.server.id}\"}"
# }

# resource "aws_cloudwatch_event_target" "start_instance" {
#   rule  = "${aws_cloudwatch_event_rule.start_instance.name}"
#   arn   = "${aws_lambda_function.start_stop_instance.arn}"
#   input = "{\"action\": \"start\",\"region\": \"${var.aws_region}\",\"instanceId\": \"${module.server.id}\"}"
# }
