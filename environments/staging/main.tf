module "networking" {
  source = "../../modules/networking"

  env_name    = "staging"
  name_prefix = "Aneeta"
  vpc_cidr    = "10.1.0.0/16"

  public_subnet_cidrs  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]

  azs = ["us-east-1a", "us-east-1b"]
}

module "security_group" {
  source = "../../modules/security-group"

  env_name    = "staging"
  name_prefix = "Aneeta"
  vpc_id      = module.networking.vpc_id
}

module "storage" {
  source = "../../modules/storage"

  env_name        = "staging"
  name_prefix     = "Aneeta"
  image_file_path = "${path.module}/../../assets/site-image.webp"
}

module "launch_template" {
  source = "../../modules/launch-template"

  env_name    = "staging"
  name_prefix = "Aneeta"
  web_sg_id   = module.security_group.web_sg_id
  bucket_name = module.storage.bucket_name
  image_key   = module.storage.image_key
}

module "alb" {
  source = "../../modules/alb"

  env_name          = "staging"
  name_prefix       = "Aneeta"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
}

module "asg" {
  source = "../../modules/asg"

  env_name                = "staging"
  name_prefix             = "Aneeta"
  private_subnet_ids      = module.networking.private_subnet_ids
  launch_template_id      = module.launch_template.launch_template_id
  launch_template_version = module.launch_template.latest_version
  target_group_arn        = module.alb.target_group_arn

  min_size         = 2
  max_size         = 4
  desired_capacity = 2
}