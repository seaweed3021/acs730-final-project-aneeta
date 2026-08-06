terraform {
  backend "s3" {
    bucket = "aneeta-prod-tfstate-421381591322"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
