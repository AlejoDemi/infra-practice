# main.tf test cicd
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet_cidr_b = "10.0.3.0/24"
  tag_env             = var.env
}

module "rds" {
  source              = "../../modules/rds"
  tag_env             = var.env
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  allowed_cidr_blocks = ["0.0.0.0/0"] 
  db_username         = "postgres"
  db_password         = "clave-segura123"
  db_name             = "photo_metadata"
}

module "layer" {
  source      = "../../modules/layer"
  layer_zip_file = "../../../artifacts/dev/aws_sdk_layer.zip"
  layer_name = "aws-sdk-layer-${var.env}"
}

module "lambda" {
  source = "../../modules/lambda"
  function_name = "uploadPhotoFunction-${var.env}"
  zip_path      = "../../../artifacts/dev/lambda_function.zip"
  role_arn      = module.iam.lambda_exec_role_arn
  layer_arn     = module.layer.layer_arn
  bucket_name   = module.s3.bucket_name
  db_host = module.rds.rds_endpoint
  db_name             = "photo_metadata"
  db_user             = "postgres"
  db_password         = "clave-segura123"

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.lambda_sg_id]
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "alejo-photo-storage-${var.env}"
}

module "iam" {
  source      = "../../modules/iam"
  role_name   = "lambda_exec_role-${var.env}"
}

module "apigateway" {
  source                = "../../modules/apigateway"
  api_name              = "photo-api-${var.env}"
  lambda_invoke_arn     = module.lambda.function_arn
  lambda_function_name  = module.lambda.function_name
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-alejo-dev"
    key            = "photo-uploader/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

