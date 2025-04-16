variable "region" {
  description = "AWS region"
  type        = string
}
#ver si lo borro de acá
variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_cidr_igw" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "namespaces" {
  description = "Lista de namespaces a crear en el cluster"
  type        = list(string)
  default     = []
}

variable "node_group_name" {
  description = "Node Group Name"
  type        = string
}