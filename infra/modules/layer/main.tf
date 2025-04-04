resource "aws_lambda_layer_version" "aws_sdk" {
  filename          = var.layer_zip_file
  layer_name        = var.layer_name
  compatible_runtimes = ["nodejs18.x"]
  source_code_hash  = filebase64sha256(var.layer_zip_file)
}