# -- networking/main.tf -- #

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {

    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        "Name" = "${var.name}"
    }
    lifecycle {
      create_before_destroy = true
    }
}


resource "aws_subnet" "private_subnet" {
  count = var.private_sn_count
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = false # This makes private subnet
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "private_${count.index + 1}"
  }
}

resource "aws_subnet" "public_subnet" {
  count = var.public_sn_count
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true # This makes public subnet
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    "Name" = "public_${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_association" {
  count = var.public_sn_count
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw_${var.name}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    "Name" = "Public Route"
  }
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet_gateway.id
}

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "eip_${var.name}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "nat_${var.name}"
  }

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    "Name" = "Private Route"
  }
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}





