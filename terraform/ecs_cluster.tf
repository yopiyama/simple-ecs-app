
resource "aws_ecs_cluster" "simple-app-cluster" {
  name = "simple-app-cluster"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster-capacity" {
  capacity_providers = ["FARGATE"]
  cluster_name = aws_ecs_cluster.simple-app-cluster.name
}
