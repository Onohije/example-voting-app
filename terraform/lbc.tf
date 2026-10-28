resource "aws_iam_policy" "lbc" {
  name = "${var.project_name}-lbc-policy"
  policy = file("${path.module}/lbc-iam-policy.json")
}

resource "aws_iam_role" "lbc_role" {
  name = "${var.project_name}-lbc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession", "pods.eks.amazonaws.com"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
          
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lbc_policy_attachment" {
  role       = aws_iam_role.lbc_role.name
  policy_arn = aws_iam_policy.lbc.arn
}

resource "aws_eks_pod_identity_association" "eks_pod_identity" {
  cluster_name = aws_eks_cluster.main.name
  role_arn     = aws_iam_role.lbc_role.arn
  namespace = "kube-system"
  service_account = "aws-load-balancer-controller"
}

resource "aws_ec2_tag" "ec2_lbc" {
  for_each = toset(data.aws_subnets.default.ids)
  resource_id = each.value
  key = "kubernetes.io/role/elb"
    value = "1"

}