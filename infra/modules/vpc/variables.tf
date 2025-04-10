variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_cidr_b" {
  type    = string
  default = "10.0.3.0/24"
}

variable "tag_env" {
  type = string
  description = "Nombre del entorno (dev, prod, etc.) para taggear recursos"
}
