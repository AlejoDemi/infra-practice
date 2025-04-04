variable "function_name" {
  description = "Nombre de la Lambda"
  type        = string
}

variable "zip_path" {
  description = "Ruta al archivo .zip"
  type        = string
}

variable "role_arn" {
  description = "ARN del rol de ejecución"
  type        = string
}

variable "layer_arn" {
  description = "ARN de la capa de Lambda"
  type        = string
}

variable "bucket_name" {
  description = "Nombre del bucket S3 donde se suben las imágenes"
  type        = string
}
