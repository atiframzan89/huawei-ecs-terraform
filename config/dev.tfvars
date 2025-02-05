profile                     = "hcs"
region                      = "ap-southeast-1"
customer                    = "huawei"
environment                 = "dev"
vpc = {
    #name = "vpc"
    cidr                    = "10.0.0.0/16"
    public_subnet           = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
    private_subnet          = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24" ]
}
ecs-admin-password          = "password"