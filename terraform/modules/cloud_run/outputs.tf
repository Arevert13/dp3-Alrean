output "service_url" {
  value = google_cloud_run_service.default.status[0].url
}

output "repository" {
  value = google_artifact_registry_repository.default.name
}
