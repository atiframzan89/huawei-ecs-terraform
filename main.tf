

module "vpc" {
    source          = "./modules/vpc"
    environment     = var.environment
    customer        = var.customer
    az              = data.huaweicloud_availability_zones.zones.names
    vpc             = var.vpc
    
   
}

module "ecs" {
    source              = "./modules/ecs"
    environment         = var.environment
    customer            = var.customer
    private-subnet-1    = module.vpc.private-subnet-1
    public-subnet-1     = module.vpc.public-subnet-1
    public-subnet-elb-1 = module.vpc.public-subnet-elb-1
    private-subnet-elb-1 = module.vpc.private-subnet-elb-1
    private-subnet-elb-2 = module.vpc.private-subnet-elb-2
    private-subnet-elb-3 = module.vpc.private-subnet-elb-3
    az                  = data.huaweicloud_availability_zones.zones.names
    vpc-id              = module.vpc.vpc-id
    image-id            = data.huaweicloud_images_image.ubuntu.id
   
}