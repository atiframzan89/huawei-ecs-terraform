# VPC ID

output "vpc-id" {
  value = huaweicloud_vpc.vpc.id
}

# Private Subnet

output "private-subnet-1" {
  value = huaweicloud_vpc_subnet.private-subnet[0].id
}

output "private-subnet-2" {
  value = huaweicloud_vpc_subnet.private-subnet[1].id
}

output "private-subnet-3" {
  value = huaweicloud_vpc_subnet.private-subnet[2].id
}

# Public Subnet
output "public-subnet-1" {
  value = huaweicloud_vpc_subnet.public-subnet[0].id
}

output "public-subnet-2" {
  value = huaweicloud_vpc_subnet.public-subnet[1].id
}

output "public-subnet-3" {
  value = huaweicloud_vpc_subnet.public-subnet[2].id
}


# Public Subnet for ELB Dedicated

output "public-subnet-elb-1" {
  value = huaweicloud_vpc_subnet.public-subnet[0].ipv4_subnet_id
}

# Private Subnet for ELB Dedicated
output "private-subnet-elb-1" {
  value = huaweicloud_vpc_subnet.private-subnet[0].ipv4_subnet_id
}

output "private-subnet-elb-2" {
  value = huaweicloud_vpc_subnet.private-subnet[1].ipv4_subnet_id
}

output "private-subnet-elb-3" {
  value = huaweicloud_vpc_subnet.private-subnet[2].ipv4_subnet_id
}