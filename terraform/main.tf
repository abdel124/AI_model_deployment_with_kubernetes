provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "gpu_cluster" {
  name     = "ai--dep-cluster"
  role_arn = aws_iam_role.eks.arn
  vpc_config {
    subnet_ids = aws_subnet.public.*.id
  }
}

resource "aws_eks_node_group" "gpu_nodes" {
  cluster_name  = aws_eks_cluster.gpu_cluster.name
  node_group_name = "gpu-nodes"
  node_role_arn = aws_iam_role.node.arn
  instance_types = ["p3.2xlarge"] # GPU-enabled EC2 instances
  scaling_config {
    min_size = 1
    max_size = 3
    desired_size = 2
  }
}