# ==============================================================================
# ORDERS - AWS SQS Queue
# ==============================================================================

resource "aws_sqs_queue" "orders_sqs_queue" {

  name = "${var.environment}-orders-queue"

  # ----------------------------------------------------------------------------
  # DELIVERY SETTINGS
  # ----------------------------------------------------------------------------
  visibility_timeout_seconds = 30
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 345600
  delay_seconds              = 0
  max_message_size           = 262144

  # ----------------------------------------------------------------------------
  # ENCRYPTION
  # ----------------------------------------------------------------------------
  sqs_managed_sse_enabled = true

  # ----------------------------------------------------------------------------
  # TAGS
  # ----------------------------------------------------------------------------
  tags = {
    Name        = "${var.environment}-orders-queue"
    Component   = "Orders"
    Environment = var.environment_name
  }
}

output "orders_sqs_queue_name" {
  description = "Orders SQS Queue Name"
  value       = aws_sqs_queue.orders_sqs_queue.name
}

output "orders_sqs_queue_url" {
  description = "Orders SQS Queue URL"
  value       = aws_sqs_queue.orders_sqs_queue.url
}

output "orders_sqs_queue_arn" {
  description = "Orders SQS Queue ARN"
  value       = aws_sqs_queue.orders_sqs_queue.arn
}