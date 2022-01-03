//task_definition
resource "aws_ecs_task_definition" "task_definition"{
    family                  = "worker"
    container_definitions   = data.template_file.task_definition_template.rendered
}
//ecs.service.tf
resource "aws_ecs_service" "worker"{
    name            = "worker"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.task_definition.arn 
    desired_count   = 2
}

data "aws_ecr_image" "worker" {
  repository_name = "worker"
  image_tag       = "latest"
}