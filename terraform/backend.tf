# --- root/backend.tf ---

terraform {
  backend "s3" {
    bucket = "thestig.deploy-aws-resourses"
    key    = "remote.tfstate"
    region = "eu-central-1"
  }
}