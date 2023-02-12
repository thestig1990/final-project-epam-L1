# --- root/backend.tf ---

terraform {
  backend "s3" {
    // bucket = "thestig.deploy-aws-resourses"
    // key    = "remote.tfstate"
    encrypt = true
    region = "eu-central-1"
  }
}