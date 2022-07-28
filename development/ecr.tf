resource "aws_ecr_repository" "syslog" {
  name = "syslog-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}