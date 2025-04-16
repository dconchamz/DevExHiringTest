output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}

output "node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.cluster.token
}