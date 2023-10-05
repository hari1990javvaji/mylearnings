resource "aws_kms_key" "key" {
  description              = var.description
  key_usage                = var.key_usage
  customer_master_key_spec = var.customer_master_key_spec
  policy                   = var.policy
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  tags = merge(
    {
      "Name" = var.alias
    },
  var.tags)
}

resource "aws_kms_alias" "alias" {
  name          = format("%s/%s-%s", "alias", var.resource_prefix, var.alias)
  target_key_id = aws_kms_key.key.key_id
}
