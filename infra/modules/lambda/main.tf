resource "aws_lambda_function" "upload_photo" {
  function_name    = var.function_name
  runtime          = "nodejs18.x"
  handler          = "index.handler"
  filename         = var.zip_path
  source_code_hash = filebase64sha256(var.zip_path)
  role             = var.role_arn
  layers           = [var.layer_arn]

  environment {
    variables = {
      BUCKET_NAME = var.bucket_name
    }
  }
}
