# dp3-Alrean
# dp3-Alrean

This repository contains a simple Flask backend with three endpoints:

- `GET /products` – list all products.
- `POST /products` – add a new product.
- `POST /buy` – purchase a product and update its stock.

## Running locally

Install the dependencies and start the server:

```bash
pip install -r requirements.txt
python app.py
```

The service will listen on port `8080` by default.

## Cloud Run

The included `Dockerfile` can be used to build a container image for
[Cloud Run](https://cloud.google.com/run). Build and deploy with:

```bash
gcloud builds submit --tag gcr.io/<PROJECT_ID>/dp3-alrean
gcloud run deploy dp3-alrean --image gcr.io/<PROJECT_ID>/dp3-alrean --platform managed
```

Replace `<PROJECT_ID>` with your Google Cloud project.