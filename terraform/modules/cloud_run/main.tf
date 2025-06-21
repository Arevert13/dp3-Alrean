resource "google_artifact_registry_repository" "default" {
  provider = google

  location      = var.region
  repository_id = var.repo_name
  description   = "Repo para imágenes Docker"
  format        = "DOCKER"
}
  
resource "google_cloud_run_service" "default" {
  provider = google

  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "default" {
  provider = google

  service  = google_cloud_run_service.default.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}


