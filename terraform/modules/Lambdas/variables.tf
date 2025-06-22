variable "lambda_name" {
  description = "Nombre de la función Lambda"
  type        = string
}

variable "code_path" {
  description = "Ruta al código fuente de la Lambda"
  type        = string
}

variable "handler" {
  description = "Handler que Lambda ejecuta"
  type        = string
}


variable "lambda_role_arn" {
  description = "ARN del rol IAM que puede asumir la Lambda"
  type        = string
}

