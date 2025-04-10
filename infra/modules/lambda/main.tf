resource "aws_lambda_function" "upload_photo" {
  function_name    = var.function_name
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = var.zip_path
  source_code_hash = filebase64sha256(var.zip_path)
  role             = var.role_arn
  layers           = [var.layer_arn]

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }


  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
      DB_HOST     = var.db_host
      DB_PORT     = "5432"
      DB_NAME     = var.db_name
      DB_USER     = var.db_user
      DB_PASSWORD = var.db_password
    }
  }
}

