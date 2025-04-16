variable "cluster_name" {
  description = "Cluster Name EKS"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets IDs"
  type        = list(string)
}

variable "node_role_arn" {
  description = "ARN Rol for EKS nodes"
  type        = string
}

variable "node_group_name" {
  description = "Node Group Name"
  type        = string
}
