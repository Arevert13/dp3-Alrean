output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "flask_app_url" {
  value = google_cloud_run_v2_service.flask_app.uri
}

output "lambda_get_products_url" {
  value = aws_lambda_function_url.get_products.function_url
}

output "lambda_get_item_url" {
  value = aws_lambda_function_url.get_item.function_url
}

output "lambda_add_product_url" {
  value = aws_lambda_function_url.add_product.function_url
}

output "bigquery_dataset_id" {
  value = google_bigquery_dataset.ecommerce_analytics.dataset_id
}

