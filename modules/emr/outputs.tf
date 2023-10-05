output "cluster_id" {
  value       = join("", aws_emr_cluster.default.*.id)
  description = "EMR cluster ID"
}

output "cluster_name" {
  value       = join("", aws_emr_cluster.default.*.name)
  description = "EMR cluster name"
}

output "master_security_group_id" {
  value       = join("", aws_security_group.master.*.id)
  description = "Master security group ID"
}

output "slave_security_group_id" {
  value       = join("", aws_security_group.slave.*.id)
  description = "Slave security group ID"
}

output "managed_master_security_group_id" {
  value       = join("", aws_security_group.managed_master.*.id)
  description = "Managed Master security group ID"
}

output "managed_slave_security_group_id" {
  value       = join("", aws_security_group.managed_slave.*.id)
  description = "Managed Slave security group ID"
}


output "ec2_role" {
  value       = var.ec2_role_enabled ? join("", aws_iam_role.ec2.*.name) : null
  description = "Role name of EMR EC2 instances so users can attach more policies"
}

output "emr_service_role_arn" {
  value = join("", aws_iam_role.emr.*.arn)
}

output "emr_ec2_role_arn" {
  value = join("", aws_iam_role.ec2.*.arn)
}
