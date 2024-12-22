# # Ubuntu Image

# data "huaweicloud_images_image" "ubuntu" {
#     name              = "Ubuntu 22.04 server 64bit"
#     visibility        = "public"
#     most_recent       = true
# }

# # EVS
# # resource "huaweicloud_evs_volume" "ecs-public-volume" {
# #   name              = "${var.customer}-public-evs-${var.environment}"
# #   availability_zone = "cn-north-4a"
# #   volume_type       = "SAS"
# #   size              = 10
# # }

# # Security Group

# resource "huaweicloud_networking_secgroup" "ecs-sg" {
#   name        = "${var.customer}-ecs-sg-${var.environment}"
# #   description = ""
# }

# resource "huaweicloud_networking_secgroup_rule" "ecs-sg-rule" {
#   security_group_id        = huaweicloud_networking_secgroup.ecs-sg.id
#   direction                = "ingress"
#   ethertype                = "IPv4"
#   protocol                 = "tcp"
#   port_range_min           = 22
#   port_range_max           = 22
#   remote_ip_prefix         = "0.0.0.0/0"
# }

# # EIP

# # resource "huaweicloud_vpc_eip" "myeip" {
# #   publicip {
# #     type = "5_bgp"
# #   }
# #   bandwidth {
# #     name        = "test"
# #     size        = 5
# #     share_type  = "PER"
# #     charge_mode = "traffic"
# #   }
# # }

# # resource "huaweicloud_compute_eip_associate" "associated" {
# #   public_ip   = huaweicloud_vpc_eip.myeip.address
# #   instance_id = huaweicloud_compute_instance.public-ecs.id
# # }

# # ECS
# resource "huaweicloud_compute_instance" "public-ecs" {
#     name                  = "${var.customer}-public-ecs-${var.environment}"
#     image_id              = data.huaweicloud_images_image.ubuntu.id
#     flavor_id             = "c6.large.2"
# #   key_pair           = "my_key_pair_name"
#     admin_pass          = "Deem@123"
#     security_group_ids    = [ huaweicloud_networking_secgroup.ecs-sg.id ]
# #   availability_zone     = "cn-north-4a"
#     # system_disk_type = "SAS"
#     # system_disk_size = "40"

#     # data_disks {
#     #   type = "SAS"
#     #   size = "40"
#     # }

#     delete_disks_on_termination = true

#   network {
#     uuid = huaweicloud_vpc_subnet.private-subnet[0].id
#   }
# }

# # resource "huaweicloud_compute_volume_attach" "attached" {
# #   instance_id = huaweicloud_compute_instance.myinstance.id
# #   volume_id   = huaweicloud_evs_volume.myvolume.id
# # }