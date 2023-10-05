# Specify Intra subnets ID if MWAA need to be in internal subnet without outbound internet access
#intra_subnet_ids   = []

# Specify private subnets ID if MWAA need to be in private subnetw with outbound internet access
private_subnet_ids = ["subnet-0ada0733bf079e63c", "subnet-0b897102f3b7728b8"]
#Intra subnet does not have NAT. In Philips env, there is no intra subnet. Hence using private subnets
intra_subnet_ids = ["subnet-0ada0733bf079e63c", "subnet-0b897102f3b7728b8"]

# KMS VPC Endpoint should be created. A SG around this EP should be provided below. 
# MWAA and EMR modules will make an inbound rule into this SG to allow MWAA or EMR to access KMS EP
vpc_sg_id = "sg-0b491bb9c3261f99b"

# Specify the VPC id for Lake House. Ensure all lake house resources are created in the same VPC
vpc_id = "vpc-0dd4ae3a8a4fb4826"

# Console login user should be added to lake formation administrator group in development environments. 
# else console user will not be able to view the glue db and tables managed by Lake Formation
administrator_users = ["arn:aws:iam::705158173663:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_AWSAdministratorAccess_e7674a7314c656b1"]


