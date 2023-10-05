resource "aws_sns_topic" "sns_topics" {
  for_each          = var.sns_topics
  name              = format("%s-%s", var.resource_prefix, each.key)
  kms_master_key_id = var.encrypt_key_sns
  tags = merge(
    {
      "Description" = "SNS topic for ${each.key}"
    },
  var.tags)

}

