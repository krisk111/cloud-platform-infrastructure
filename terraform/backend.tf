terraform {
  backend "s3" {
    bucket       = "cloud-platform-terraform-state-281459851067"
    key          = "cloud-platform/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}