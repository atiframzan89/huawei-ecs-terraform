terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = ">= 1.21.0"
   }
}
}




# EVS
# resource "huaweicloud_evs_volume" "ecs-public-volume" {
#   name              = "${var.customer}-public-evs-${var.environment}"
#   availability_zone = "cn-north-4a"
#   volume_type       = "SAS"
#   size              = 10s
# }

# Security Group

resource "huaweicloud_networking_secgroup" "ecs-sg" {
  name        = "${var.customer}-ecs-sg-${var.environment}"
#   description = ""
}

resource "huaweicloud_networking_secgroup_rule" "ecs-sg-rule" {
  security_group_id        = huaweicloud_networking_secgroup.ecs-sg.id
  direction                = "ingress"
  ethertype                = "IPv4"
  protocol                 = "tcp"
  ports = "80,22"
  # port_range_min           = "22"
  # port_range_max           = "22"
  remote_ip_prefix         = "0.0.0.0/0"
}

# EIP

# resource "huaweicloud_vpc_eip" "myeip" {
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

# resource "huaweicloud_compute_eip_associate" "associated" {
#   public_ip   = huaweicloud_vpc_eip.myeip.address
#   instance_id = huaweicloud_compute_instance.public-ecs.id
# }

# ECS
resource "huaweicloud_compute_instance" "private-ecs" {
    name                    = "${var.customer}-private-ecs-${var.environment}"
    image_id                = var.image-id
    flavor_id               = "c6.large.2"
#   key_pair           = "my_key_pair_name"
    admin_pass              = "Deem@123"
    security_group_ids      = [ huaweicloud_networking_secgroup.ecs-sg.id ]
#   availability_zone     = "cn-north-4a"s
    # system_disk_type = "SAS"
    # system_disk_size = "40"

    # data_disks {
    #   type = "SAS"
    #   size = "40"
    # }

    delete_disks_on_termination = true

  network {
    uuid = var.private-subnet-1
  }
  user_data = file("${path.module}/templates/userdata.sh")
  tags          = {
      "Name"                            = "${var.customer}-private-ecs-${var.environment}"
      "Environment"                     = var.environment
      "Customer"                        = var.customer
      "Terraform"                       = "True"
    }
}

# Dedicated Elastic Load Balancer
# https://registry.terraform.io/providers/huaweicloud/huaweicloud/latest/docs/resources/elb_loadbalancer
# https://support.huaweicloud.com/intl/en-us/api-elb/ShowLoadBalancer.html

resource "huaweicloud_elb_loadbalancer" "elb-loadbalancer" {
  name              = "${var.customer}-elb-${var.environment}"
  # description       = "${var.customer}-elb"
  cross_vpc_backend = true 

  vpc_id            = var.vpc-id
  ipv4_subnet_id    = var.public-subnet-elb-1 # Frontend subnet

  # l4_flavor_id = var.l4_flavor_id
  # l7_flavor_id      = "L7_flavor.elb.s1.small" # Based on your traffic https://support.huaweicloud.com/intl/en-us/api-elb/ListFlavors.html
  # ipv4_eip_id       = "share_type" # For less cost
  # bandwidth_charge_mode = "traffic" # Based on traffic billing will be charged

  backend_subnets = [ var.private-subnet-1 ]

  availability_zone = var.az 
  ipv4_eip_id       = huaweicloud_vpc_eip.elb-eip.id
}


resource "huaweicloud_elb_listener" "elb-listener" {
  name            = "${var.customer}-elb-listener-${var.environment}"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb-loadbalancer.id

  idle_timeout     = 10
  request_timeout  = 10
  response_timeout = 10
  # forward_host     = true

  tags          = {
      "Name"                            = "${var.customer}-elb-listener-${var.environment}"
      "Environment"                     = var.environment
      "Customer"                        = var.customer
      "Terraform"                       = "True"
    }
}

# resource "huaweicloud_elb_member" "elb-member" {
#   address       = huaweicloud_compute_instance.private-ecs.access_ip_v4
#   protocol_port = 80
#   pool_id       = huaweicloud_elb_pool.elb-pool.id
#   # subnet_id     = var.private-subnet-1
# }

resource "huaweicloud_elb_pool" "elb-pool" {
  name            = "${var.customer}-elb-pool-${var.environment}"
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb-loadbalancer.id
  type            = "ip"
  listener_id     = huaweicloud_elb_listener.elb-listener.id
  # ip_version      = huaweicloud_compute_instance.private-ecs.access_ip_v4
}

# Backend Server HealthCheck

resource "huaweicloud_elb_monitor" "monitor_1" {
  pool_id     = huaweicloud_elb_pool.elb-pool.id
  protocol    = "HTTP"
  interval    = 5
  timeout     = 5
  max_retries = 3
  url_path    = "/"
  # domain_name = "www.bb.com"
  port        = 80
  status_code = "200"
}

# ELB Backend Server Member

resource "huaweicloud_elb_member" "backend_ip1" {
  pool_id       = huaweicloud_elb_pool.elb-pool.id
  address       = huaweicloud_compute_instance.private-ecs.access_ip_v4 # Replace with your backend server IP
  protocol_port = 80          # The port the backend server listens on
  weight        = 10          # Traffic distribution weight
  # subnet_id     = var.private-subnet-1 # Subnet ID where backend IP belongs
}

# Forwarding Policy

# resource "huaweicloud_elb_l7policy" "forward-policy" {
#   listener_id       = huaweicloud_elb_listener.elb-listener.id
#   name              = "${var.customer}-forward-policy-${var.environment}"
#   action            = "REDIRECT_TO_POOL" # Forward traffic to a backend pool
#   redirect_pool_id  = huaweicloud_elb_pool.elb-pool.id
#   # position          = 1 # Policy priority

# }


# ELB EIP
resource "huaweicloud_vpc_eip" "elb-eip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "test"
    size        = 5
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

