output "add_product_function_name" {
  value = module.add_product_lambda.lambda_function_name
}

output "get_products_function_name" {
  value = module.get_products_lambda.lambda_function_name
}

output "buy_product_function_name" {
  value = module.buy_product_lambda.lambda_function_name
}
