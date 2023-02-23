# terraform-aws-to-typetalk
Notification from AWS EventBridge to TypeTalk

EventBridge API destinations で Typetalk へ投稿します。

## Usage
以下の手順で、ボットを作成して Typetalk トークンを取得します。
参考: [API 概要 \| Typetalk Developer API \| Nulab](https://developer.nulab.com/ja/docs/typetalk/#tttoken)

- "トピックメニュー" -> "トピック設定"
- "ボット" -> "新規追加"
  - "API スコープ" の "topic.post" を ON (チェックを付ける)

取得したトークンを変数に代入して Terraform を実行します。

- "Typetalk Token" -> var.typetalk\_api\_token
- "メッセージの取得と投稿の URL" -> var.typetalk\_endpoint

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.55 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.55 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_api_destination.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_api_destination) | resource |
| [aws_cloudwatch_event_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_connection) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_connection_api_value"></a> [connection\_api\_value](#input\_connection\_api\_value) | Header Value. Created and stored in AWS Secrets Manager. | `string` | n/a | yes |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | Controls if IAM Role should be created. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Enter a description for the connection. Maximum of 512 characters. | `string` | `"Send to Typetalk"` | no |
| <a name="input_invocation_endpoint"></a> [invocation\_endpoint](#input\_invocation\_endpoint) | URL endpoint to invoke as a target for posting messages. | `string` | n/a | yes |
| <a name="input_invocation_rate_limit_per_second"></a> [invocation\_rate\_limit\_per\_second](#input\_invocation\_rate\_limit\_per\_second) | Enter the maximum number of invocations per second to allow for this destination. | `number` | `300` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier. | `string` | `"send-to-typetalk"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_cloudwatch_event_api_destination"></a> [aws\_cloudwatch\_event\_api\_destination](#output\_aws\_cloudwatch\_event\_api\_destination) | n/a |
| <a name="output_aws_cloudwatch_event_connection"></a> [aws\_cloudwatch\_event\_connection](#output\_aws\_cloudwatch\_event\_connection) | n/a |
| <a name="output_aws_iam_role"></a> [aws\_iam\_role](#output\_aws\_iam\_role) | n/a |
