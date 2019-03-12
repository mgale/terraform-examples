[
  {
    "name": "neo4j",
    "image": "${REPOSITORY_URL}",
    "networkMode": "awsvpc",
    "essential": true,
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/neo4j",
          "awslogs-region": "${AWS_REGION}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": 7474,
        "hostPort": 7474
      },
      {
        "containerPort": 7473,
        "hostPort": 7473
      },
      {
        "containerPort": 7687,
        "hostPort": 7687
      }
    ]

  }
]