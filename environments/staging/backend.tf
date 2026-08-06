terraform {
  backend "s3" {
    bucket = "aneeta-staging-tfstate-421381591322"
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}
