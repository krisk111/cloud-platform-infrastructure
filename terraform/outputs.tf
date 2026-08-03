output "application_container_repository_url" {
  value       = aws_ecr_repository.application_container_repository.repository_url
  description = "URL to the ECR registry used to store application images"
}