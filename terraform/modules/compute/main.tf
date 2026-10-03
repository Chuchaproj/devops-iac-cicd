terraform {
  required_version = ">= 1.6, < 2.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

variable "environment" { type = string }
variable "image" { type = string }
variable "http_port" { type = number }
variable "private_network" { type = string }
variable "edge_network" { type = string }
variable "nginx_config" { type = string }
resource "docker_image" "nginx" {
  name         = "nginx:1.28.0-alpine"
  keep_locally = true
}
resource "docker_container" "backend" {
  name        = "iac-${var.environment}-backend"
  image       = var.image
  env         = ["APP_ENV=${var.environment}", "RELEASE=${var.image}"]
  read_only   = true
  memory      = 128
  memory_swap = 256
  networks_advanced {
    name    = var.private_network
    aliases = ["backend"]
  }
  capabilities { drop = ["ALL"] }
  security_opts = ["no-new-privileges:true"]
}
resource "docker_container" "nginx" {
  name        = "iac-${var.environment}-nginx"
  image       = docker_image.nginx.image_id
  memory      = 128
  memory_swap = 256
  networks_advanced { name = var.private_network }
  networks_advanced { name = var.edge_network }
  ports {
    internal = 8080
    external = var.http_port
    ip       = "127.0.0.1"
  }
  upload {
    content = var.nginx_config
    file    = "/etc/nginx/nginx.conf"
  }
  depends_on = [docker_container.backend]
}
output "url" {
  value = "http://127.0.0.1:${var.http_port}"
}
