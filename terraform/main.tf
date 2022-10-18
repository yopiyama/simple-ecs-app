provider "aws" { region = "ap-northeast-1" }

variable "account_id" {}

variable "vpc_id" {}

variable "subnet_a" {}
variable "subnet_c" {}
variable "subnet_d" {}

variable "sg_from_home" {}
variable "sg_localnet" {}

variable "api_service_image_ver" {}
variable "client_service_image_ver" {}

resource "aws_service_discovery_private_dns_namespace" "simple-app-local-internal" {
  name        = "simple-app.local"
  description = "(Internal) Simple app domain"
  vpc         = "${var.vpc_id}"
}


resource "aws_service_discovery_service" "api-service-discovery" {
  name = "api-service"

  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.simple-app-local-internal.id}"

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
