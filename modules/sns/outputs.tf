output "sns_topics_arn" {
  value = [
    for key, value in aws_sns_topic.sns_topics : value.arn
  ]
}