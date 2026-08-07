module "networking" {
  source = "../../modules/networking"

  env_name    = "dev"
  name_prefix = "Aneeta"
  vpc_cidr    = "10.0.0.0/16"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  azs = ["us-east-1a", "us-east-1b"]
}

module "security_group" {
  source = "../../modules/security-group"

  env_name    = "dev"
  name_prefix = "Aneeta"
  vpc_id      = module.networking.vpc_id
}

module "storage" {
  source = "../../modules/storage"

  env_name        = "dev"
  name_prefix     = "Aneeta"
  image_file_path = "${path.module}/../../assets/site-image.webp"
}

module "launch_template" {
  source = "../../modules/launch-template"

  env_name    = "dev"
  name_prefix = "Aneeta"
  web_sg_id   = module.security_group.web_sg_id
  bucket_name = module.storage.bucket_name
  image_key   = module.storage.image_key
}