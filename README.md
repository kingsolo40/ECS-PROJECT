# ECS-PROJECT
CREATING ECS (Ec2) USING TERRAFORM

Amazon ECS is a service for running and maintaining a specified number of tasks. It is a scalable, high-performing container management service that supports Docker containers.


#Components:

·       VPC with a public subnet as an isolated pool for my resources

·       Internet Gateway to contact the outer world

·       Security groups for RDS MySQL and for EC2s

·       Auto-scaling group for ECS cluster with launch configuration

·       RDS MySQL instance

·       ECR container registry

·       ECS cluster with task and service definition

