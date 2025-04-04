# main.tf test cicd
provider "aws" {
  region = "us-east-1"
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

