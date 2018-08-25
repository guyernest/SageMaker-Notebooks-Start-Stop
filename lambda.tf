provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "examlpe" {
  function_name = "StopStartSageMakerNotebookInstances"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "terraform-serverless-repository"
  s3_key    = "v1.0.0/lambda.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "lambda_function.lambda_handler"
  runtime = "Python3.6"

  role = "${aws_iam_role.lambda_exec.arn}"
}
# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogs0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:eu-west-1:217431963147:log-group:/aws/lambda/*NotebookInstance:*"
        },
        {
            "Sid": "InstanceControl",
            "Effect": "Allow",
            "Action": [
                "sagemaker:ListTags",
                "ec2:ModifyNetworkInterfaceAttribute",
                "sagemaker:DescribeNotebookInstance",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeAvailabilityZones",
                "sagemaker:StopNotebookInstance",
                "ec2:DescribeVpcs",
                "sagemaker:StartNotebookInstance",
                "ec2:AttachNetworkInterface",
                "ec2:DescribeSubnets",
                "sagemaker:ListNotebookInstances"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CloudWatchLogs1",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-west-1:217431963147:*"
        }
    ]
}
EOF
}