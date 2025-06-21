variable "service_name" {
  type        = string
  description = "Nombre del servicio Cloud Run"
}

variable "region" {
  type        = string
  description = "Región GCP"
}

variable "image" {
  type        = string
  description = "Imagen Docker para desplegar"
}

variable "repo_name" {
  type        = string
  description = "Nombre del repositorio de Artifact Registry"
}

