variable "region" {
  type        = string
  description = "Región de Azure para el despliegue de recursos"
  default     = "francecentral"
}

variable "resource_group_name" {
  type        = string
  description = "Nombre base del Resource Group"
}

variable "env_prefix" {
  type        = string
  description = "Prefijo del entorno (ej. dev, pre, prod)"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "El espacio de direcciones CIDR para la VNET (ej. ['10.0.0.0/16'])"
}

variable "subnet_names" {
  type        = list(string)
  description = "Lista de nombres para las subnets"
}
