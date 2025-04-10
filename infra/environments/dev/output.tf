output "api_endpoint" {
  value = module.apigateway.api_endpoint
}

output "database_endpoint" {
  value = module.rds.rds_endpoint
}