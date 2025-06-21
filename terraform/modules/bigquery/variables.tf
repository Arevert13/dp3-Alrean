variable "dataset_id" {
  description = "BigQuery dataset ID"
  type        = string
}

variable "location" {
  description = "Dataset location"
  type        = string
}

variable "table_id" {
  description = "Table ID"
  type        = string
}

variable "schema" {
  description = "Table schema JSON"
  type        = string
}