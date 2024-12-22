data "huaweicloud_availability_zones" "zones" {}

# Ubuntu Image
data "huaweicloud_images_image" "ubuntu" {
    name              = "Ubuntu 22.04 server 64bit"
    visibility        = "public"
    most_recent       = true
}