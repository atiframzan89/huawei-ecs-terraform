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
  shared_config_file = "<you config file location here>"
  profile     = "default"
  
}
