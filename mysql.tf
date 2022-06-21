resource "aws_db_instance" "mysql" {
  allocated_storage         = 5
  multi_az                  = true
  engine                    = "mysql"
  engine_version            = "8.0.28"
  instance_class            = "db.t3.micro"
  username                  = "admin1234"
  password                  = "Sunday=1123"
  port                      = "3306" 
  db_subnet_group_name      = aws_db_subnet_group.mysql-subnet-group.name
  vpc_security_group_ids    = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
  skip_final_snapshot       = true
  publicly_accessible       = true 
} 

 # creating DB instance subnet */
resource "aws_db_subnet_group" "mysql-subnet-group" {
  name       = "mysql-subnet-group"
  subnet_ids = [aws_subnet.pub_subnet.id, aws_subnet.pub2_subnet.id]
} 

# creating ecs.tf
resource "aws_ecs_cluster" "ecs_cluster" {
name = "my-cluster"
}

# creating ecr.tf
resource "aws_ecr_repository" "admin" {
  name = "admin"
}

# data template file
data "template_file" "task_definition_template" {
   template = file("task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = replace(aws_ecr_repository.admin.repository_url, "https://", "")
  } 
}

/* data "template_file" "task_definition_template" {
  template = file("task_definition.json.tpl")
  vars = {
    REPOSITORY_URL = replace(aws_ecr_repository.worker.repository_url, "https://", "")
  }
} */

# task definition.tf
resource "aws_ecs_task_definition" "task_definition" {
  family                = "worker"
  container_definitions = data.template_file.task_definition_template.rendered
}
   
# ecs service.tf
resource "aws_ecs_service" "worker" {
  name            = "worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
}