variable "sysdig_api_token" {}
variable "sysdig_access_key" {}
variable "orchestrator_host" {}
variable "orchestrator_port" {}

terraform {
  required_providers {
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 0.5.39"
    }
  }
}


provider "sysdig" {
  sysdig_secure_api_token = "${var.sysdig_api_token}"
}


data "sysdig_fargate_workload_agent" "api-service-instrumented" {
  container_definitions = jsonencode(
    [
      {
        image = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/api-service:1"
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
        ],
        entryPoint = [
          "/usr/local/bin/python", "/src/api_server.py"
        ]
      },
    ]
  )
  workload_agent_image  = "quay.io/sysdig/workload-agent:latest"
  sysdig_access_key = "${var.sysdig_access_key}"
  orchestrator_host = "${var.orchestrator_host}"
  orchestrator_port = "${var.orchestrator_port}"
}

resource "aws_ecs_task_definition" "api-service" {
  container_definitions    = "${data.sysdig_fargate_workload_agent.api-service-instrumented.output_container_definitions}"
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

data "sysdig_fargate_workload_agent" "client-service-instrumented" {
  container_definitions = jsonencode(
    [
      {
        cpu   = 0
        image = "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/simple-app/client-service:1"
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
        ],
        entryPoint = [
          "/usr/local/bin/streamlit", "run", "/src/client.py"
        ]
      },
    ]
  )
  workload_agent_image  = "quay.io/sysdig/workload-agent:latest"
  sysdig_access_key = "${var.sysdig_access_key}"
  orchestrator_host = "${var.orchestrator_host}"
  orchestrator_port = "${var.orchestrator_port}"

}


resource "aws_ecs_task_definition" "client-service" {
  container_definitions    = "${data.sysdig_fargate_workload_agent.client-service-instrumented.output_container_definitions}"

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
