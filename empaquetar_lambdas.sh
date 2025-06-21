#!/bin/bash

echo "📦 Empaquetando Lambdas..."

# Función para empaquetar cada lambda
zip_lambda() {
  LAMBDA_NAME=$1
  cd "Lambdas/$LAMBDA_NAME" || exit
  echo "→ Empaquetando $LAMBDA_NAME"
  zip "${LAMBDA_NAME}_lambda.zip" lambda_function.py requirements.txt > /dev/null
  cd - > /dev/null
}

zip_lambda "add_product"
zip_lambda "get_products"
zip_lambda "buy_product"

echo "✅ Empaquetado completado. ZIPs generados en sus respectivas carpetas."

