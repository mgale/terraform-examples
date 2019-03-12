resource "aws_cloudwatch_log_group" "neo4j" {
  name              = "/ecs/neo4j"
  retention_in_days = 30
  tags {
    Name = "neo4j"
  }
}