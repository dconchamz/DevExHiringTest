module "vpc" {
  source        = "./modules/vpc"
  vpc_cidr      = var.vpc_cidr
  vpc_cidr_igw  =var.vpc_cidr_igw
}

module "eks" {
  source            = "./modules/eks"
  cluster_name      = var.cluster_name
  eks_cluster_role  = var.eks_cluster_role
  eks_node_role     = var.eks_node_role
  subnet_ids        = module.vpc.subnet_ids
  vpc_id            = module.vpc.vpc_id
}

module "node_group" {
  source       = "./modules/node-group"
  cluster_name = module.eks.cluster_name
  subnet_ids   = module.vpc.subnet_ids
  node_role_arn = module.eks.node_role_arn
  node_group_name = var.node_group_name
}

module "ecr" {
  source = "./modules/ecr"
}

terraform {
  backend "s3" {
    bucket         = "tf-state-blue-dcm"      
    key            = "terraform.tfstate"              
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"                 
    encrypt        = true                             
  }
}


resource "kubernetes_namespace" "this" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
  }
   depends_on = [module.eks]
}
