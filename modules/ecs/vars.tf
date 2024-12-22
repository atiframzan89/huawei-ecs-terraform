variable "customer" {}
variable "environment" {}
variable "private-subnet-1" {}
variable "public-subnet-1" {}
variable "public-subnet-elb-1" {
  
}
variable "vpc-id" {}
variable "image-id" {}
variable "az" {
  type        = list(string)
}

# Private ELB Dedicated
variable "private-subnet-elb-1"{}
variable "private-subnet-elb-2"{}
variable "private-subnet-elb-3"{}