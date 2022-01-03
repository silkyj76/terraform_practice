/*Elastic Container Service
Amazon ECS provides a complete container management system supporting Docker containers and windows server containers 
which allows us to use third-party plug-ins and customizations from Kubernetes community.
ECS allows you to setup a cluster of EC2 instances running docker in a selected VPC.
We will use ECR to push the images and use them while launching the EC2 instances within our cluster.

ecr.tf*/
resource "aws_ecr_repository" "worker"{
    name    = "worker"
}

//ecs.tf
resource "aws_ecs_cluster" "ecs_cluster"{
    name = "dylan-cluster"
}/*Containers are launched using a task definition. which is a set of simple instructions understood by the ECS cluster. 
Its a JSON file that is kept separately.*/

//template_file.tf
data "template_file" "task_definition_template"{
    template = "${file("${path.module}/task_definition.json.tpl")}" 
    vars = {
        REPOSITORY_URL = replace(aws_ecr_repository.worker.repository_url, "https://992567842996.dkr.ecr.us-east-1.amazonaws.com/worker", "")
    }
}
//We are defining what image will be used using a template variable in the template_file data resource as repository_url.