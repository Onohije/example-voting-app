variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "voting-app"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.37"
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 2
}
#
variable "github_repo" {
  description = "GitHub repo allowed to use the CI role"
  type        = string
  default     = "Onohije@116710916/example-voting-app@1422393920"
}