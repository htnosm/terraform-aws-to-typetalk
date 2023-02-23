output "aws_iam_role" {
  value = var.create_iam_role ? aws_iam_role.this.0 : null
}

output "aws_cloudwatch_event_connection" {
  value = aws_cloudwatch_event_connection.this
}

output "aws_cloudwatch_event_api_destination" {
  value = aws_cloudwatch_event_api_destination.this
}
