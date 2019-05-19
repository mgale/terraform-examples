[
  {
    "name": "${CONTAINER_NAME}",
    "image": "${REPOSITORY_URL}",
    "networkMode": "awsvpc",
    "essential": true,
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${LOG_GROUP_NAME}",
          "awslogs-region": "${AWS_REGION}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${CONTAINER_PORT},
        "hostPort": ${HOST_PORT}
      }
    ],
    "environment": [
        { "name": "DB_SERVER", "value": "${DB_SERVER}" },
        { "name": "DB_PASSWORD", "value": "${DB_PASSWORD}" },
        { "name": "DB_USERNAME", "value": "${DB_USERNAME}" },
        { "name": "DB_NAME", "value": "${DB_NAME}" }
    ]
  }
]