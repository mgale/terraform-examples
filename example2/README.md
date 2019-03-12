# Simple Example 

    Builds a stack to host an application in Fargate

The following resources are managed:
* VPC
* Security Groups
* CloudWatch to hold logs
* IAM policy for CloudWatch log streams
* ECS / Fargate cluster setup
* Deploying a docker image in the Fargate cluster
* ALB setup to load balance external connections to the Docker app