# --- root/backend.tf ---

terraform {
  backend "s3" {
    // bucket = "thestig-tfsate-bucket"
    // key    = "fpremote.tfstate"
    encrypt = true
    region = "eu-central-1"
  }
}