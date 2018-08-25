## Based on the location of the instances. This is for Israel where 
## people are working Sunday to Thursday and 5AM GTM is 8AM
resource "aws_cloudwatch_event_rule" "on_duty" {
    name = "on_duty"
    description = "Fires at the beginning of the working day"
    schedule_expression = "cron(0 5 ? * SUN-THU *)"
}

## people are working Sunday to Thursday and 4PM GTM is 7PM
resource "aws_cloudwatch_event_rule" "off_duty" {
    name = "off_duty"
    description = "Fires at the end of the working day"
    schedule_expression = "cron(0 16 ? * SUN-THU *)"
}

resource "aws_cloudwatch_event_target" "on_duty_start_instances" {
    rule = "${aws_cloudwatch_event_rule.on_duty.name}"
    target_id = "start_stop_sm"
    arn = "${aws_lambda_function.start_stop_sm.arn}"
    input = <<DOC
{
  "event": "On"
}
DOC
}

resource "aws_cloudwatch_event_target" "off_duty_start_instances" {
    rule = "${aws_cloudwatch_event_rule.off_duty.name}"
    target_id = "start_stop_sm"
    arn = "${aws_lambda_function.start_stop_sm.arn}"
    input = <<DOC
{
  "event": "Off"
}
DOC
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_On_duty" {
    statement_id = "AllowExecutionFromCloudWatchOn"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.start_stop_sm.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.on_duty.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_Off_duty" {
    statement_id = "AllowExecutionFromCloudWatchOff"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.start_stop_sm.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.off_duty.arn}"
}