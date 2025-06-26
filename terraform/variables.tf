variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "account_id" {
  description = "ID de la cuenta AWS"
  type        = string
}

variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "eu-west-1"
}

variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "europe-west1"
}

variable "vpc_cidr" {
  description = "CIDR para la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  description = "Lista de CIDRs para subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  description = "Lista de CIDRs para subnets privadas"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "aws_availability_zones" {
  description = "Zonas de disponibilidad para AWS"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "common_tags" {
  description = "Etiquetas comunes"
  type        = map(string)
  default     = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "ecommerce_db"
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

variable "db_instance_class" {
  description = "Clase de instancia de RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "datastream_username" {
  description = "Usuario específico para Datastream"
  type        = string
}

variable "datastream_password" {
  description = "Contraseña del usuario de Datastream"
  type        = string
  sensitive   = true
}

variable "flask_app_image" {
  description = "Ruta completa a la imagen del contenedor Flask"
  type        = string
}

variable "flask_app_port" {
  description = "Puerto en el que corre Flask"
  type        = number
  default     = 8080
}

variable "bigquery_dataset_id" {
  description = "ID del dataset de BigQuery"
  type        = string
  default     = "ecommerce_dataset"
}

variable "bigquery_dataset_location" {
  description = "Ubicación del dataset de BigQuery"
  type        = string
  default     = "europe-west1"
}

variable "datastream_display_name" {
  description = "Nombre a mostrar del stream de Datastream"
  type        = string
  default     = "Postgres to BigQuery"
}
variable "latest_revision" {
  description = "Indica si se debe usar la última revisión del servicio Cloud Run"
  type        = bool
  default     = true
  
}

variable "publication" {
  description = "Nombre de la tabla de publicaciones en BigQuery"
  type        = string
  default     = "publicaciones"
  
}

variable "replication_slot" {
  description = "Nombre del slot de replicación en RDS"
  type        = string
  default     = "datastream_slot"
  
}

variable "datastream_user" {
  description = "Usuario para Datastream"
  type        = string
  default     = "datastream_user" 
 }

variable "rds_endpoint" {
  description = "Endpoint de la instancia RDS"
  type        = string
  
}