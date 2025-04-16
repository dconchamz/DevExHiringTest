output "ecr_repo_urls" {
  description = "URL ECR"
  value = {
    for repo_name, repo in aws_ecr_repository.repos : repo_name => repo.repository_url
  }
}
