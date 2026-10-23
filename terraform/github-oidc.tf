data "aws_iam_openid_connect_provider" "oidc" {
  url = "https://token.actions.githubusercontent.com"
}

resource "aws_iam_role" "oidc_role" {
  name = "${var.project_name}-github-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.oidc.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:ref:refs/heads/main"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "oidc_policy" {
  name = "${var.project_name}-github-oidc-policy"
  role = aws_iam_role.oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ecr:GetAuthorizationToken"] # log in to ECR
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchGetImage"
        ] # push images to all ECR repos
        Effect   = "Allow"
        Resource = [for repo in aws_ecr_repository.ecr_repo : repo.arn] # all arn from the for_each loop in ecr.tf
      },

    ]
  })
}
