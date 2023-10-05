locals {

  aws_partition = join("", data.aws_partition.current.*.partition)

  bucket_resources = setunion(var.buckets_nonsensitive_arns, formatlist("%s/*", var.buckets_nonsensitive_arns))
}