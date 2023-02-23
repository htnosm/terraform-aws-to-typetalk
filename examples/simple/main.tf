variable "typetalk_api_token" {
  type = string
}

variable "typetalk_endpoint" {
  type = string
}

module "eventbridge_api_destination_typetalk" {
  source = "../../"

  create_iam_role      = true
  name                 = "example-send-to-typetalk"
  connection_api_value = var.typetalk_api_token
  invocation_endpoint  = var.typetalk_endpoint
}

resource "aws_cloudwatch_event_rule" "securityhub" {
  name        = "example-send-to-typetalk-capture-securityhub"
  description = "Capture each Security Hub Events"
  is_enabled  = true

  event_pattern = jsonencode({
    "detail" : {
      "findings" : {
        "Compliance" = {
          "Status" = [{ "anything-but" : "PASSED" }]
        }
        "Severity" = {
          "Label" = ["HIGH", "CRITICAL"]
        }
        "Workflow" = {
          "Status" = ["NEW"]
        }
      }
    }
    "source"      = ["aws.securityhub"]
    "detail-type" = ["Security Hub Findings - Imported"]
  })
}

resource "aws_cloudwatch_event_target" "securityhub" {
  rule      = aws_cloudwatch_event_rule.securityhub.name
  target_id = module.eventbridge_api_destination_typetalk.aws_cloudwatch_event_api_destination.name
  arn       = module.eventbridge_api_destination_typetalk.aws_cloudwatch_event_api_destination.arn
  role_arn  = module.eventbridge_api_destination_typetalk.aws_iam_role.arn

  input_transformer {
    input_paths = {
      "Account"        = "$.account"
      "Description"    = "$.detail.findings[0].Description"
      "DetailType"     = "$.detail-type"
      "FirstSeen"      = "$.detail.findings[0].FirstObservedAt"
      "LastSeen"       = "$.detail.findings[0].LastObservedAt"
      "Recommendation" = "$.detail.findings[0].ProductFields.RecommendationUrl"
      "Region"         = "$.region"
      "Resource"       = "$.detail.findings[0].Resources[0].Id"
      "Severity"       = "$.detail.findings[0].Severity.Label"
      "Summary"        = "$.detail.findings[0].Title"
    }
    input_template = <<-EOT
    {
        "message": ":warning: [<Severity>] <DetailType> | <Region> | Account: <Account>\n\n<Summary>\n> <Description>\n```\nFirst Seen: <FirstSeen>\nLast Seen: <LastSeen>\nAffected Resource: <Resource>\nSeverity: <Severity>\nRecommendation: <Recommendation>\n```"
    }
    EOT
  }

  dead_letter_config {
    arn = aws_sqs_queue.securityhub_dlq.arn
  }
}

resource "aws_sqs_queue" "securityhub_dlq" {
  name                       = "${aws_cloudwatch_event_rule.securityhub.name}-EventDLQ"
  visibility_timeout_seconds = 30
  delay_seconds              = 0
  receive_wait_time_seconds  = 0
  max_message_size           = 262144 # 256 KB
  message_retention_seconds  = 345600 # 4 Days
}

resource "aws_sqs_queue_policy" "securityhub_dlq" {
  queue_url = aws_sqs_queue.securityhub_dlq.id
  policy = jsonencode({
    "Version" : "2008-10-17"
    "Statement" = [
      {
        "Sid"    = "Dead-letter queue permissions"
        "Effect" = "Allow"
        "Principal" = {
          "Service" = "events.amazonaws.com"
        }
        "Action"   = "sqs:SendMessage"
        "Resource" = aws_sqs_queue.securityhub_dlq.arn
        "Condition" = {
          "ArnEquals" = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.securityhub.arn
          }
        }
      }
    ]
  })
}
