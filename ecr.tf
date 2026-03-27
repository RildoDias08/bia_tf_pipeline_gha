resource "aws_ecr_repository" "bia_repo" {
  name                 = "bia-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}