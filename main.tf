#-- root/main.tf -- # 

module "vpc_a" {
  source           = "./networking"
  vpc_cidr         = var.vpc_cidr_a #"10.10.0.0/16"
  private_sn_count = 2
  public_sn_count  = 2
  name = "VPC-A"
  public_cidrs     = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr_a, 8, i)]
  private_cidrs    = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr_a, 8, i)]
}

module "vpc_b" {
  source           = "./networking"
  vpc_cidr         = var.vpc_cidr_b #"10.20.0.0/16"
  private_sn_count = 2
  public_sn_count  = 2
  name             = "VPC-B"
  public_cidrs     = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr_b, 8, i)]
  private_cidrs    = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr_b, 8, i)]
}


module "vpc_peering" {
  source = "./vpc_peering"
  peer_vpc_id = module.vpc_b.vpc_id
  origin_vpc_id = module.vpc_a.vpc_id
  vpc_peering_name = "VPC Peering"
}

module "peering_routes_vpc_a" {
  source = "./peering_rts"
  vpc_id = module.vpc_a.vpc_id
  destination_cidr_block = var.vpc_cidr_b
  vpc_peering_connection_id = module.vpc_peering.vpc_peering_id
}
module "peering_routes_vpc_b" {
  source = "./peering_rts"
  vpc_id = module.vpc_b.vpc_id
  destination_cidr_block = var.vpc_cidr_a
  vpc_peering_connection_id = module.vpc_peering.vpc_peering_id

}


module "vpc_a_ec2_public_host" {
  source    = "./compute"
  vpc_id    = module.vpc_a.vpc_id
  subnet_id = module.vpc_a.public_subnet_id[0]
  ec2_name  = "VPC-A-Public-host"
  
}

module "vpc_b_ec2_private_host" {
  source    = "./compute"
  vpc_id    = module.vpc_b.vpc_id
  subnet_id = module.vpc_b.private_subnet_id[0]
  vpc_a_subnet_id = module.vpc_a.public_subnet_id[0]
  ec2_name  = "VPC-B-Private-host"
}