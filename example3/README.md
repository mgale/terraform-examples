# Simple Example 

    Builds a stack to host an application in an ECS cluster backed by 3 EC2 instances

The following resources are managed:
* VPC
* Security Groups
* ECS cluster setup
* Deploying a docker image in the ECS cluster
* Route53 setup for DNS
* Bastion host for remote access to the environment.

This stack was initially built using https://github.com/segmentio/stack modules. However those modules
do not appear to be update to date. Instead they are not using a forked branch located here: https://github.com/mgale/stack

This is still a work in progress.