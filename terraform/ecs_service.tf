resource "aws_ecs_service" "api-service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.simple-app-cluster.name
  task_definition = aws_ecs_task_definition.api-service.arn

  depends_on = ["aws_ecs_cluster.simple-app-cluster", "aws_ecs_task_definition.api-service"]

  launch_type         = "FARGATE"
  platform_version    = "LATEST"
  propagate_tags      = "NONE"
  scheduling_strategy = "REPLICA"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  health_check_grace_period_seconds  = 0

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  network_configuration {
    assign_public_ip = true
    security_groups = [
      "${var.sg_localnet}"
    ]
    subnets = [
      "${var.subnet_a}",
      "${var.subnet_c}",
      "${var.subnet_d}"
    ]
  }

    service_registries {
      registry_arn   = "${aws_service_discovery_service.api-service-discovery.arn}"
    }
}


resource "aws_ecs_service" "client-service" {
  name            = "client-service"
  cluster         = aws_ecs_cluster.simple-app-cluster.name
  task_definition = aws_ecs_task_definition.client-service.arn

  depends_on = ["aws_ecs_cluster.simple-app-cluster", "aws_ecs_task_definition.client-service"]

  launch_type         = "FARGATE"
  platform_version    = "LATEST"
  propagate_tags      = "NONE"
  scheduling_strategy = "REPLICA"

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  enable_ecs_managed_tags            = true
  enable_execute_command             = false
  health_check_grace_period_seconds  = 0


  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }


  network_configuration {
    assign_public_ip = true
    security_groups = [
      "${var.sg_localnet}",
      "${var.sg_from_home}",
      "${var.sg_vpn}"
    ]
    subnets = [
      "${var.subnet_a}",
      "${var.subnet_c}",
      "${var.subnet_d}"
    ]
  }
}
