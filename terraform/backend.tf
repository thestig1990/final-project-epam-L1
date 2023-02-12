# --- root/backend.tf ---

terraform {
  backend "s3" {
    // bucket = "thestig-tfsate-bucket"
    // key    = "fp-mysite.tfstate"
    encrypt = true
    region = "eu-central-1"
  }
}