variable "alumno_iniciales" {
  type        = string
  description = "Iniciales del alumno para personalizar el Resource Group y Storage Account (máx. 4 letras)"
  default     = "ua"
}

variable "location" {
  type        = string
  description = "Región de Azure para el despliegue de recursos"
  default     = "westeurope"
}
