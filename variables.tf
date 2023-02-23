variable "create_iam_role" {
  description = "Controls if IAM Role should be created."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier."
  type        = string
  default     = "send-to-typetalk"
}

variable "description" {
  description = "Enter a description for the connection. Maximum of 512 characters."
  type        = string
  default     = "Send to Typetalk"
}

variable "connection_api_value" {
  description = "Header Value. Created and stored in AWS Secrets Manager."
  type        = string
}

variable "invocation_endpoint" {
  description = "URL endpoint to invoke as a target for posting messages."
  type        = string
}

variable "invocation_rate_limit_per_second" {
  description = "Enter the maximum number of invocations per second to allow for this destination."
  type        = number
  default     = 300
}
