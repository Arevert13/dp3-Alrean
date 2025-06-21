variable "aws_region"      { type = string }


variable "gcp_project"     { type = string }
variable "gcp_region"      { type = string }

variable "lambda_role_arn" { type = string }

variable "rds_host"        { type = string }
variable "rds_port"        { type = string }
variable "rds_user"        { type = string }
variable "rds_password"    { type = string }
variable "rds_dbname"      { type = string }

variable "db_username"       { type = string }
variable "db_password"       { type = string }

variable "cloud_run_service_name" {
  type = string
}

variable "cloud_run_image" {
  type = string
}

variable "artifact_repo_name" {
  type = string
}

