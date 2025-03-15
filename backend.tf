terraform {
  backend "s3" {
    bucket         = var.bucket
    key            = "s3/terraform.tfstate"
    region         = var.region
    encrypt        = true
  }
}
