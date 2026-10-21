resource "aws_ecr_repository" "ecr_repo" {
  for_each = toset(["vote", "result", "worker"])
  name     = "${var.project_name}-${each.key}"

  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}