locals {
  zip_name = "${var.lambda_name}.zip"
  zip_path = "${path.module}/../../../${var.code_path}/${local.zip_name}"
}

resource "null_resource" "zip_lambda" {
  provisioner "local-exec" {
    command = "cd ${path.module}/../../../${var.code_path} && zip -r ../${local.zip_name} ."
  }

  triggers = {
    always_run = timestamp()
  }
}

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_name
  role             = var.lambda_role_arn
  handler          = var.handler
  runtime          = "python3.9"
  filename         = local.zip_path
  source_code_hash = filebase64sha256(local.zip_path)

  depends_on = [null_resource.zip_lambda]
}
