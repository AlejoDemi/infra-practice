variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Lista de subnets privadas"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "Bloques CIDR permitidos para acceder a la DB"
  type        = list(string)
  default     = ["0.0.0.0/0"] # ⚠️ ajustalo a tu IP para mayor seguridad
}

variable "db_username" {
  description = "Usuario de la base de datos"
  type        = string
}

variable "db_password" {
  description = "Contraseña de la base de datos"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "tag_env" {
  description = "Ambiente para tags y nombres"
  type        = string
}
