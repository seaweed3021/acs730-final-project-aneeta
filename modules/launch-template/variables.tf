variable "env_name" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "web_sg_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "image_key" {
  type = string
}