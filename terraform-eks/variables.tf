variable "kubernetes_version" {
  default     = 1.27
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "172.31.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default = "ca-central-1"
  description = "aws region"
}

