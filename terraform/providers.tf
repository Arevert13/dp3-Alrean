terraform {
  required_version = ">= 1.0"

  backend "gcs" {
    bucket = "ordinal-thinker-452918-q2-terraform-state"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "aws" {
  region = var.aws_region
}

