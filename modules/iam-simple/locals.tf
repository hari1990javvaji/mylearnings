locals {

  aws_partition = join("", data.aws_partition.current.*.partition)

}