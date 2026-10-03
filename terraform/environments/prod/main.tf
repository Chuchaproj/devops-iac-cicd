terraform {
  required_version = ">= 1.6, < 2.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {}
variable "image" {
  type        = string
  default     = "iac-backend:local"
  description = "Use an immutable release tag; build/load the image before apply."
}
module "network" {
  source      = "../../modules/network"
  environment = "prod"
}
module "compute" {
  source          = "../../modules/compute"
  environment     = "prod"
  image           = var.image
  http_port       = 8083
  private_network = module.network.private_name
  edge_network    = module.network.edge_name
  nginx_config    = file("${path.module}/../../../nginx/nginx.conf")
}
output "service_url" { value = module.compute.url }
