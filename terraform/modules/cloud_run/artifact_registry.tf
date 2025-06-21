resource "google_artifact_registry_repository" "docker_repo" {
  provider = google

  location      = var.region
  repository_id = var.repo_name
  format        = "DOCKER"
  description   = "Repositorio para imágenes Docker de Flask"
}
