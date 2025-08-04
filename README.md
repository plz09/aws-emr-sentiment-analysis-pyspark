# aws-emr-sentiment-analysis-pyspark

Project for sentiment analysis using PySpark on an Amazon EMR cluster, with infrastructure as code (IaC) via Terraform.

## Overview

This project processes movie review data, applies NLP techniques, and trains Machine Learning models for sentiment analysis using a distributed Spark pipeline on EMR. All infrastructure is automatically provisioned via Terraform.

## Project Structure

- `IaC/`  
  - **config.tf, main.tf, variables.tf, terraform.tfvars**: Terraform definitions for provisioning EMR, S3, IAM, etc.
  - **modules/**: Reusable Terraform modules (EMR, IAM, S3).
  - **dados/dataset.csv**: Movie review dataset.
  - **pipeline/**: Python scripts for processing, ML, and uploading data/models.
  - **scripts/bootstrap.sh**: Bootstrap script to prepare the Python environment on EMR.

## Pipeline

1. **Provisioning:**  
   Use Terraform to create all infrastructure (EMR, S3, IAM).

2. **Uploading Data and Scripts:**  
   Python scripts and data are automatically uploaded to S3.

3. **Processing and Training:**  
   The main script [`emr_ml_pipeline.py`](IaC/pipeline/emr_ml_pipeline.py) executes:
   - Data cleaning and transformation ([`st_processamento.py`](IaC/pipeline/st_processamento.py))
   - ML model training and evaluation ([`st_ml.py`](IaC/pipeline/st_ml.py))
   - Log generation ([`st_log.py`](IaC/pipeline/st_log.py))
   - Uploading results and models to S3 ([`st_upload_s3.py`](IaC/pipeline/st_upload_s3.py))

## How to Run

1. **Prerequisites**  
   - AWS CLI configured  
   - Terraform installed  
   - AWS account with permissions for EMR, S3, and IAM

2. **Configuration**
   - Edit the files `IaC/config.tf` and `IaC/terraform.tfvars` with your AWS ID.
   - In the script [`emr_ml_pipeline.py`](IaC/pipeline/emr_ml_pipeline.py), add your AWS ID and keys where indicated.
   - Manually create the S3 bucket `plz-st-terraform-<aws-id>`.

3. **Provisioning**
   ```sh
   cd IaC
   terraform init
   terraform apply
   ```

4. **Execution**
   The pipeline will run automatically on the provisioned EMR cluster.

## Results

- Processed data, trained models, and logs are saved in the defined S3 bucket.
- The pipeline can be customized for other datasets or models.

## Main Script Structure

- [`emr_ml_pipeline.py`](IaC/pipeline/emr_ml_pipeline.py): Main orchestration script.
- [`st_processamento.py`](IaC/pipeline/st_processamento.py): Data cleaning and transformation.
- [`st_ml.py`](IaC/pipeline/st_ml.py): Model training and evaluation.
- [`st_upload_s3.py`](IaC/pipeline/st_upload_s3.py): Uploads data and models to S3.
- [`st_log.py`](IaC/pipeline/st_log.py): Log generation.

## Notes

- The project uses PySpark, boto3, scikit-learn, numpy, pendulum, among others.
- The Python environment is automatically prepared via [`bootstrap.sh`](IaC/scripts/bootstrap.sh) on EMR.

---

For details about each module, check the files inside [`IaC/`](IaC)