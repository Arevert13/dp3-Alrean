# dp3-Alrean

This repository contains a sample AWS Lambda function that reads from an RDS
instance and writes to BigQuery. See [lambda/](lambda/README.md) for build
instructions.

# Lambda Function

This directory contains a simple AWS Lambda function that reads data from an
Amazon RDS PostgreSQL database and writes it to BigQuery.

## Environment Variables

- `DB_HOST` – RDS endpoint
- `DB_NAME` – database name
- `DB_USER` – username for the database
- `DB_PASSWORD` – password for the database
- `BQ_TABLE` – BigQuery table in the form `project.dataset.table`
- `GOOGLE_APPLICATION_CREDENTIALS` – path to a service account key file with
  permissions to write to BigQuery (mounted in the container)

## Building the Container Image

1. Build the image:

   ```sh
   docker build -t my-lambda-image .
   ```

2. Tag and push to Amazon ECR (replace placeholders):

   ```sh
   aws ecr get-login-password --region <region> | \
     docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com

   docker tag my-lambda-image:latest <account_id>.dkr.ecr.<region>.amazonaws.com/my-lambda-image:latest
   docker push <account_id>.dkr.ecr.<region>.amazonaws.com/my-lambda-image:latest
   ```

The pushed image can then be referenced when creating the Lambda function.