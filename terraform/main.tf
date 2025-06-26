provider "aws" {
  region = "eu-west-1"
}

provider "google" {
  project = "ordinal-thinker-452918-q2"
  region  = "europe-west1"
}

resource "aws_vpc" "vpc_ord_thinker" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ordinal-thinker-vpc"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.vpc_ord_thinker.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "ordinal-thinker-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.vpc_ord_thinker.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "ordinal-thinker-private-subnet-2"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "ordinal-thinker-rds-sg"
  vpc_id = aws_vpc.vpc_ord_thinker.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Cambiar si se requiere más seguridad
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnets" {
  name       = "ordinal-thinker-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_db_instance" "postgres" {
  identifier              = "ordinal-thinker-postgres"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "products_db"
  username                = "postgres_user"
  password                = "postgres_pass123!"
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = true
  parameter_group_name    = "default.postgres15"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "ordinal-thinker-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "archive_file" "get_products_zip" {
  type        = "zip"
  source_dir  = "../app/lambdas/get_products"
  output_path = "${path.module}/get_products.zip"
}

data "archive_file" "add_product_zip" {
  type        = "zip"
  source_dir  = "../app/lambdas/add_product"
  output_path = "${path.module}/add_product.zip"
}

data "archive_file" "buy_product_zip" {
  type        = "zip"
  source_dir  = "../app/lambdas/buy_product"
  output_path = "${path.module}/buy_product.zip"
}

locals {
  lambda_env = {
    DB_HOST     = aws_db_instance.postgres.address
    DB_NAME     = aws_db_instance.postgres.db_name
    DB_USER     = aws_db_instance.postgres.username
    DB_PASSWORD = aws_db_instance.postgres.password
  }

  subnets = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_lambda_function" "get_products" {
  function_name    = "get-products-fn"
  filename         = data.archive_file.get_products_zip.output_path
  source_code_hash = data.archive_file.get_products_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  timeout          = 15

  vpc_config {
    subnet_ids         = local.subnets
    security_group_ids = [aws_security_group.rds_sg.id]
  }

  environment {
    variables = local.lambda_env
  }
}

resource "aws_lambda_function" "add_product" {
  function_name    = "add-product-fn"
  filename         = data.archive_file.add_product_zip.output_path
  source_code_hash = data.archive_file.add_product_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  timeout          = 15

  vpc_config {
    subnet_ids         = local.subnets
    security_group_ids = [aws_security_group.rds_sg.id]
  }

  environment {
    variables = local.lambda_env
  }
}

resource "aws_lambda_function" "buy_product" {
  function_name    = "buy-product-fn"
  filename         = data.archive_file.buy_product_zip.output_path
  source_code_hash = data.archive_file.buy_product_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.11"
  timeout          = 15

  vpc_config {
    subnet_ids         = local.subnets
    security_group_ids = [aws_security_group.rds_sg.id]
  }

  environment {
    variables = local.lambda_env
  }
}

resource "google_artifact_registry_repository" "flask_repo" {
  location      = var.region
  repository_id = "flask-repo"
  description   = "Repo Docker para Flask frontend"
  format        = "DOCKER"
  project       = var.project_id
}

resource "null_resource" "build_flask_image" {
  provisioner "local-exec" {
    command = <<EOT
      gcloud builds submit ../app/flask-app \
        --tag=${var.region}-docker.pkg.dev/${var.project_id}/flask-repo/flask-app:latest \
        --project=${var.project_id}
    EOT
  }

  triggers = {
    dockerfile_hash = filemd5("../app/flask-app/Dockerfile")
  }

  depends_on = [google_artifact_registry_repository.flask_repo]
}

resource "google_service_account" "cloud_run_sa" {
  account_id   = "flask-cloud-run-sa"
  display_name = "SA para Cloud Run Flask"
  project      = var.project_id
}

resource "google_cloud_run_v2_service" "flask_app" {
  name     = "flask-app"
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.cloud_run_sa.email

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/flask-repo/flask-app:latest"

      ports {
        container_port = 8501
      }

      env {
        name  = "GET_PRODUCTS_URL"
        value = aws_lambda_function.get_products.invoke_arn
      }

      env {
        name  = "ADD_PRODUCT_URL"
        value = aws_lambda_function.add_product.invoke_arn
      }

      env {
        name  = "BUY_PRODUCT_URL"
        value = aws_lambda_function.buy_product.invoke_arn
      }
    }
  }

  traffic {
    percent         = 100
  }

  depends_on = [null_resource.build_flask_image]
}

resource "google_cloud_run_service_iam_member" "allow_all" {
  location = google_cloud_run_v2_service.flask_app.location
  service  = google_cloud_run_v2_service.flask_app.name
  project  = var.project_id
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_bigquery_dataset" "ecommerce_analytics" {
  dataset_id  = "ecommerce_analytics"
  location    = var.region
  project     = var.project_id
  description = "Dataset para replicación RDS y análisis en Looker"

  labels = {
    proyecto = var.project_name
  }
}

resource "google_datastream_connection_profile" "rds_source" {
  connection_profile_id = "rds-source"
  location              = var.region
  project               = var.project_id
  display_name          = "AWS RDS PostgreSQL Source"

  postgresql_profile {
    hostname = split(":", aws_db_instance.main.endpoint)[0]
    port     = 5432
    username = var.datastream_user
    password = var.datastream_password
    database = var.db_name
  }
}
resource "google_datastream_connection_profile" "bq_sink" {
  connection_profile_id = "bq-sink"
  location              = var.region
  project               = var.project_id
  display_name          = "BigQuery Sink"

  bigquery_profile {}
}
resource "google_datastream_stream" "rds_to_bq" {
  stream_id = "rds-to-bq"
  location  = var.region
  project   = var.project_id
  display_name = "Replicación RDS a BigQuery"

  source_config {
    source_connection_profile = google_datastream_connection_profile.rds_source.id

    postgresql_source_config {
      include_objects {
        postgresql_schemas {
          schema = "public"
          postgresql_tables {
            table = "products"
          }
        }
      }
      publication                   = var.publication
      replication_slot              = var.replication_slot
      max_concurrent_backfill_tasks = 4
    }
  }

  destination_config {
    destination_connection_profile = google_datastream_connection_profile.bq_sink.id
    bigquery_destination_config {
      single_target_dataset {
        dataset_id = google_bigquery_dataset.ecommerce_analytics.dataset_id
      }
    }
  }

  backfill_all {}

  depends_on = [
    google_datastream_connection_profile.rds_source,
    google_datastream_connection_profile.bq_sink
  ]
}
resource "google_bigquery_table" "products_analytics" {
  dataset_id = google_bigquery_dataset.ecommerce_analytics.dataset_id
  table_id   = "products_analytics"
  project    = var.project_id

  deletion_protection = false

  view {
    query = <<EOF
SELECT 
  id,
  name,
  price,
  description,
  available,
  created_at,
  CASE 
    WHEN available = true THEN 'Disponible'
    ELSE 'Agotado'
  END as estado,
  CASE
    WHEN price < 20 THEN 'Barato'
    WHEN price < 50 THEN 'Medio'
    ELSE 'Caro'
  END as categoria_precio
FROM `${var.project_id}.${google_bigquery_dataset.ecommerce_analytics.dataset_id}.public_products`
EOF

    use_legacy_sql = false
  }
}
