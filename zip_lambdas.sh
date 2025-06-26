#!/bin/bash

echo "📦 Empaquetando funciones Lambda..."

cd lambdas || exit 1

# Get Products
if [ -f "get_products/lambda_function.py" ]; then
  zip -j get_products/get_products_lambda.zip get_products/lambda_function.py
  echo "✅ Empaquetado: get_products_lambda.zip"
else
  echo "⚠️  No encontrado: get_products/lambda_function.py"
fi

# Add Product
if [ -f "add_product/lambda_function.py" ]; then
  zip -j add_product/add_product_lambda.zip add_product/lambda_function.py
  echo "✅ Empaquetado: add_product_lambda.zip"
else
  echo "⚠️  No encontrado: add_product/lambda_function.py"
fi

# Buy Product
if [ -f "buy_product/lambda_function.py" ]; then
  zip -j buy_product/buy_product_lambda.zip buy_product/lambda_function.py
  echo "✅ Empaquetado: buy_product_lambda.zip"
else
  echo "⚠️  No encontrado: buy_product/lambda_function.py"
fi

cd ..
