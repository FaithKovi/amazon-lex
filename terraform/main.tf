provider "aws" {
  region = "us-east-1"  # Update with your desired region
}

resource "aws_lex_bot" "example" {
  name                   = "LexBot"
  description            = "A bot that responds to chat"
  intents                = ["intent_1", "intent_2"]  # List of intent names
  clarification_prompt    = "Sorry, can you please repeat that?"
  abort_statement         = "Sorry, I am unable to assist you at the moment."
  idle_session_ttl_in_seconds = 300
}

resource "aws_lex_intent" "intent_1" {
  name         = "Intent1"
  description  = "Intent 1 description"

  sample_utterances = [
    "Example utterance 1",
    "Example utterance 2"
  ]

  fulfillment_activity {
    type = "CodeHook"
    code_hook {
      uri     = "YourLambdaFunctionARN"
      message_version = "1.0"
    }
  }
}

# DYNAMODB TABLE
resource "aws_dynamodb_table" "lex_table" {
  name           = "lex_table"
  billing_mode   = "PAY_PER_REQUEST"   # Sets the billing mode to "PAY_PER_REQUEST" for on-demand capacity
  hash_key       = "id"   # Specifies the attribute to use as the hash (partition) key
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "age"
    type = "N"
  }

  ttl {
    attribute_name = "expiration_time"
    enabled        = true
  }

  tags = {
    Environment = "Production"
  }
}

# LAMBDA FUNCTION
resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  filename      = "example_lambda.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "example_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_policy" "lambda_policy" {
  name        = "example_lambda_policy"
  description = "Allows Lambda function to access necessary resources"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}