variable "api_service_image_ver" {
  type = string
  default = "1"
}
variable "client_service_image_ver" {
  type = string
  default = "1"
}

resource "aws_ecs_task_definition" "api-service" {
  container_definitions = jsonencode(
    [
      {
        image = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/api-service:${var.api_service_image_ver}"
        cpu   = 0
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-create-group  = "true"
            awslogs-group         = "/ecs/api-service"
            awslogs-region        = "ap-northeast-1"
            awslogs-stream-prefix = "ecs"
          }
        }
        name = "api-service"
        portMappings = [
          {
            containerPort = 3000
            hostPort      = 3000
            protocol      = "tcp"
          },
        ]
      },
    ]
  )
  family                   = "api-service"
  execution_role_arn       = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}


resource "aws_ecs_task_definition" "client-service" {
  container_definitions = jsonencode(
    [
      {
        cpu   = 0
        image = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/client-service:${var.client_service_image_ver}"
        environment = [
          {
            name  = "backend_service_port"
            value = "3000"
          },
          {
            name  = "backend_service_url"
            value = "http://api-service.simple-app.local"
          },
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-create-group  = "true"
            awslogs-group         = "/ecs/client-service"
            awslogs-region        = "ap-northeast-1"
            awslogs-stream-prefix = "ecs"
          }
          secretOptions = []
        }
        name = "client-service"
        portMappings = [
          {
            containerPort = 8501
            hostPort      = 8501
            protocol      = "tcp"
          },
        ]
      },
    ]
  )
  family                   = "client-service"
  execution_role_arn       = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}
