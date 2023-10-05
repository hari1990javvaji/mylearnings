resource "aws_security_group" "glue_connector_sg" {
  name = format("%s-%s", var.resource_prefix, "glue-connector-sg")
  #checkov:skip=CKV2_AWS_5: This SG is associated with Glue Connector. Looks like a bug in checkov when associating the SG with serverless system like Glue
  description = "Glue Conector Secutiy Group"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "All egress traffic allowed"
  }

  tags = merge(
    {
      "Description" = "Glue Connector Security Group"
    },
  var.tags)
}

resource "aws_security_group_rule" "glue_connector_sg_rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.glue_connector_sg.id
  source_security_group_id = aws_security_group.glue_connector_sg.id
  description              = "All traffic within sg"
}

resource "aws_glue_connection" "glue_network_connector" {
  connection_type = "NETWORK"
  description     = "network mode glue connector"

  name = format("%s-%s", var.resource_prefix, var.name)

  physical_connection_requirements {
    availability_zone      = format("%s%s", var.aws_region, "a")
    security_group_id_list = [aws_security_group.glue_connector_sg.id]
    subnet_id              = var.subnet_id
  }
  tags = merge(
    {
      "Description" = "Network connector for datalake glue jobs"
    },
  var.tags)
}
