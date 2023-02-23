/**
 * # terraform-aws-to-typetalk
 * Notification from AWS EventBridge to TypeTalk
 *
 * EventBridge API destinations で Typetalk へ投稿します。
 *
 * ## Usage
 *
 * 以下の手順で、ボットを作成して Typetalk トークンを取得します。
 * 参考: [API 概要 \| Typetalk Developer API \| Nulab](https://developer.nulab.com/ja/docs/typetalk/#tttoken)
 *
 * - "トピックメニュー" -> "トピック設定"
 * - "ボット" -> "新規追加"
 *   - "API スコープ" の "topic.post" を ON (チェックを付ける)
 *
 * 取得した値をそれぞれ変数に指定して Terraform を実行します。
 *
 * - "Typetalk Token" -> var.typetalk_api_token
 * - "メッセージの取得と投稿の URL" -> var.typetalk_endpoint
 */

resource "aws_iam_role" "this" {
  count = var.create_iam_role ? 1 : 0

  name        = var.name
  path        = "/"
  description = var.description
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "events.amazonaws.com",
        },
        Effect = "Allow",
      },
    ],
  })
}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllowInvokeApiDestination"
    effect = "Allow"
    actions = [
      "events:InvokeApiDestination",
    ]
    resources = [aws_cloudwatch_event_api_destination.this.arn]
  }
}

resource "aws_iam_role_policy" "this" {
  count = var.create_iam_role ? 1 : 0

  name   = aws_iam_role.this.0.id
  role   = aws_iam_role.this.0.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_cloudwatch_event_connection" "this" {
  name               = var.name
  description        = var.description
  authorization_type = "API_KEY"

  auth_parameters {
    api_key {
      key   = "X-Typetalk-Token"
      value = var.connection_api_value
    }
  }
}

resource "aws_cloudwatch_event_api_destination" "this" {
  name                             = var.name
  description                      = var.description
  invocation_endpoint              = var.invocation_endpoint
  http_method                      = "POST"
  invocation_rate_limit_per_second = var.invocation_rate_limit_per_second
  connection_arn                   = aws_cloudwatch_event_connection.this.arn
}
