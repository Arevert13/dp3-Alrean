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
