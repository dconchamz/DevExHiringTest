region           = "us-east-1"
cluster_name     = "app-blue-eks"
vpc_cidr         = "10.0.0.0/16"
vpc_cidr_igw     = "0.0.0.0/0"
node_group_name  = "eks-backend-nodes"
eks_cluster_role = "eks-cluster-role"
eks_node_role    = "eks-node-role"
#Kubernetes configuration
namespaces      = ["backend", "frontend"]