# output "az" {
#   value = data.huaweicloud_availability_zones.zones.names
# }

output "elb-eip-output" {
  value = module.ecs.elb-eip
}