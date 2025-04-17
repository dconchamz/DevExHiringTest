variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "eks_cluster_role" {
  description = "EKS Cluster Role"
  type        = string
}

variable "eks_node_role" {
  description = "EKS Node Role"
  type        = string
}