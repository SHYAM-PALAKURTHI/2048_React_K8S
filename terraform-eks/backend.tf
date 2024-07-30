terraform {
  backend "s3" {
    bucket = "palakuwsawsbucket"
    key    = "eks/terraform.tfstate"
    region = "ca-central-1"
  }
}
