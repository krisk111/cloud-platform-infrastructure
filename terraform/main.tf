resource "aws_ecr_repository" "application_container_repository" {
  name                 = "cloud-platform-application"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project   = "cloud-platform"
    ManagedBy = "terraform"
  }
}