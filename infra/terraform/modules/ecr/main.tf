resource "aws_ecr_repository" "repos" {
  for_each = { for repo in local.repos : repo.name => repo }
  name = each.value.name
}
