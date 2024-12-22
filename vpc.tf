# # module "vpc" {
# #   source        = "./modules/vpc"
# #   customer      = var.customer
# #   environment   = var.environment
# #   providers = {
# #     huaweicloud = huaweicloud.huaweicloud
# #   }
# # }
# locals {
#   az    = data.huaweicloud_availability_zones.zones.names
# }


# resource "huaweicloud_vpc" "vpc" {
#     name = "${var.customer}-vpc-${var.environment}"
#     cidr = "10.0.0.0/16"
# }


# resource "huaweicloud_vpc_subnet" "public-subnet" {
#     count               = length(var.vpc.public_subnet)
#     name                = "${var.customer}-public-subnet-${var.environment}-${count.index}"
#     cidr                = element(var.vpc.public_subnet, count.index)
#     # gateway_ip        = var.subnet_gateway_ip
#     gateway_ip          = replace(element(var.vpc.public_subnet, count.index), "0/24", "1")
#     vpc_id              = huaweicloud_vpc.vpc.id
#     availability_zone   = element(local.az, count.index)
#     tags = {
#       "Name"                            = "${var.customer}-public-subnet-${var.environment}-${count.index}"
#       "Environment"                     = var.environment
#       "Customer"                        = var.customer
#       "Terraform"                       = "True"
#     }
# }

# resource "huaweicloud_vpc_subnet" "private-subnet" {
#     count               = length(var.vpc.private_subnet)
#     name                = "${var.customer}-private-subnet-${var.environment}-${count.index}"
#     cidr                = element(var.vpc.private_subnet, count.index)
#     # gateway_ip        = var.subnet_gateway_ip
#     gateway_ip          = replace(element(var.vpc.private_subnet, count.index), "0/24", "1")
#     vpc_id              = huaweicloud_vpc.vpc.id
#     availability_zone   = element(local.az, count.index)
#     tags = {
#       "Name"                            = "${var.customer}-private-subnet-${var.environment}-${count.index}"
#       "Environment"                     = var.environment
#       "Customer"                        = var.customer
#       "Terraform"                       = "True"
#     }
# }

# # Private Route Table
# resource "huaweicloud_vpc_route_table" "private-rt" {
#     # count               = length(var.vpc.private_subnet)
#     name                = "${var.customer}-private-rt-${var.environment}"
#     vpc_id              = huaweicloud_vpc.vpc.id
#     # subnets             = [ element(var.vpc.private_subnet, count.index) ]
#     subnets             = [ huaweicloud_vpc_subnet.private-subnet[0].id,
#                             huaweicloud_vpc_subnet.private-subnet[1].id,
#                             huaweicloud_vpc_subnet.private-subnet[2].id ]
    
#     route {
#       destination       = "0.0.0.0/0"
#       type              = "nat"
#       nexthop           = huaweicloud_nat_gateway.nat-gateway.id
#     }
    
# }

# # Public Route Table
# resource "huaweicloud_vpc_route_table" "public-rt" {
#     # count               = length(var.vpc.private_subnet)
#     name                = "${var.customer}-public-rt-${var.environment}"
#     vpc_id              = huaweicloud_vpc.vpc.id
#     # subnets             = [ element(var.vpc.private_subnet, count.index) ]
#     subnets             = [ huaweicloud_vpc_subnet.public-subnet[0].id,
#                             huaweicloud_vpc_subnet.public-subnet[1].id,
#                             huaweicloud_vpc_subnet.public-subnet[2].id ]
    
#     # route {
#     #   destination       = "0.0.0.0/0"
#     #   type              = "egw"
#     #   nexthop           = huaweicloud_vpc_internet_gateway.internet-gateway.id
#     # }
    
# }

# # Internet Gateway

# resource "huaweicloud_vpc_internet_gateway" "internet-gateway" {
#   name              = "${var.customer}-igw-${var.environment}"
#   vpc_id            = huaweicloud_vpc.vpc.id
# #   add_route         = true
# }

# # Nat Gateway

# # EIP

# resource "huaweicloud_vpc_eip" "nat-gw-snat-eip" {
#   publicip {
#     type = "5_bgp"
#   }
#   bandwidth {
#     name        = "test"
#     size        = 5
#     share_type  = "PER"
#     charge_mode = "traffic"
#   }
# }

# # resource "huaweicloud_compute_eip_associate" "associated" {
# #   public_ip   = huaweicloud_vpc_eip.myeip.address
# #   instance_id = huaweicloud_compute_instance.public-ecs.id
# # }

# resource "huaweicloud_nat_snat_rule" "nat-gw-snat-rule" {
#   nat_gateway_id = huaweicloud_nat_gateway.nat-gateway.id
#   floating_ip_id = huaweicloud_vpc_eip.nat-gw-snat-eip.id
#   subnet_id      = huaweicloud_vpc_subnet.private-subnet[0].id
# }


# resource "huaweicloud_nat_gateway" "nat-gateway" {
#   name          = "${var.customer}-nat-gw-${var.environment}"
# #   description = "test for terraform"
#   spec          = "1"
#   vpc_id        = huaweicloud_vpc.vpc.id
#   subnet_id     = huaweicloud_vpc_subnet.public-subnet[0].id
#   tags          = {
#       "Name"                            = "${var.customer}-nat-gateway-${var.environment}"
#       "Environment"                     = var.environment
#       "Customer"                        = var.customer
#       "Terraform"                       = "True"
#     }
# }

# # Nat Gateway SNAT Rules


# # EIP with Shared Bandwidth
# # resource "huaweicloud_vpc_bandwidth" "eip-bandwidth" {
# #   name = "${var.customer}-bandwidth-eip-${var.environment}"
# #   size = 5
# # }

# # resource "huaweicloud_vpc_eip" "shared" {
# #   publicip {
# #     type = "5_bgp"
# #   }

# #   bandwidth {
# #     share_type = "WHOLE"
# #     id         = huaweicloud_vpc_bandwidth.eip-bandwidth.id
# #   }
# # }
