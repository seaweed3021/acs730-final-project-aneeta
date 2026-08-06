terraform {
  backend "s3" {
    bucket = "aneeta-dev-tfstate-421381591322"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
