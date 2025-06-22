terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  profile = "default"
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

module "add_product_lambda" {
  source          = "./modules/lambdas"
  lambda_name     = "add_product_lambda"
  code_path       = "lambdas/add_product"
  handler         = "lambda_function.lambda_handler"
  lambda_role_arn = var.lambda_role_arn
}


module "get_products_lambda" {
  source          = "./modules/lambdas"
  lambda_name     = "get_products_lambda"
  code_path       = "lambdas/get_products"
  handler         = "lambda_function.lambda_handler"
  lambda_role_arn = var.lambda_role_arn
}

module "buy_product_lambda" {
  source          = "./modules/lambdas"
  lambda_name     = "buy_product_lambda"
  code_path       = "lambdas/buy_product"
  handler         = "lambda_function.lambda_handler"
  lambda_role_arn = var.lambda_role_arn
}

module "rds" {
  source            = "./modules/rds"
  db_identifier     = "dp3-rds"
  db_instance_class = "db.t3.micro"
  db_username       = var.db_username
  db_password       = var.db_password
  aws_region        = var.aws_region
}

module "cloud_run" {
  source       = "./modules/cloud_run"
  service_name = var.cloud_run_service_name
  region       = var.gcp_region
  image        = var.cloud_run_image
  repo_name    = var.artifact_repo_name
}

module "lambda_role" {
  source = "./modules/iam_lambda_role"
}





