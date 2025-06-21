# dp3-Alrean
# Data Platform 3 - Architecture Overview

This repository documents a cloud-native analytics platform built on Google Cloud and AWS. It uses containerized services and serverless functions to move data from production systems into BigQuery and exposes curated data to business users through Looker.

## Google Cloud Run API

A RESTful API will be packaged as a Docker container and deployed to **Google Cloud Run**. Cloud Run provides autoscaling and a fully managed runtime environment. The API will offer endpoints that other services can call for operational tasks and data extraction.

## AWS Lambda Data Loaders

Several **AWS Lambda** functions will periodically fetch data from an Amazon RDS database and load it into **BigQuery**:

1. **Extract** – read from RDS using IAM database authentication.
2. **Transform** – apply lightweight conversions if necessary.
3. **Load** – write to BigQuery using the Cloud BigQuery API.

Each function will be triggered by an AWS CloudWatch schedule or other event source.

## Looker Integration

Business intelligence dashboards will be built in **Looker** on top of the BigQuery dataset. Looker will connect directly to BigQuery using service account credentials. Models and explores will be version controlled in this repository.

## Infrastructure Management

* **Terraform** will define all Google Cloud and AWS resources, including Cloud Run services, Lambda functions, IAM roles, and networking.
* **GitHub Actions** will run Terraform in CI/CD pipelines to provision and update infrastructure automatically on every pull request and merge to `main`.

## Credentials and Secrets

1. **Google Cloud**
   - Create a service account with permissions for Cloud Run and BigQuery.
   - Generate a JSON key and add it to GitHub repository secrets as `GCLOUD_KEY`.
   - Set the project ID in GitHub secrets as `GCLOUD_PROJECT`.

2. **AWS**
   - Generate an IAM user or role with access to Lambda, RDS, and any required services.
   - Store the access key ID and secret access key in GitHub secrets as `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

GitHub Actions workflows will use these secrets to authenticate to both clouds when running Terraform and deploying application code.

