terraform {
  required_providers {
    huaweicloud = {
      source = "huaweicloud/huaweicloud"
      version = ">= 1.21.0"
   }
}
}


provider "huaweicloud" {
  region      = "${var.region}"
  shared_config_file = "C:/Users/Atif Ramzan/.hcloud/config.json"
  profile     = "default"
  
}
