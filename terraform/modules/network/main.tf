terraform {
  required_version = ">= 1.6, < 2.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

variable "environment" {
  type = string
}
resource "docker_network" "private" {
  name     = "iac-${var.environment}-private"
  internal = true
}
resource "docker_network" "edge" {
  name = "iac-${var.environment}-edge"
}
output "private_name" {
  value = docker_network.private.name
}
output "edge_name" {
  value = docker_network.edge.name
}
