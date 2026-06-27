from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import boto3
import os
import numpy as np

app = FastAPI(title="Churn Prediction API")


# Load model from S3 on startup
def load_model():
    s3 = boto3.client("s3")

    bucket = os.getenv("MODEL_BUCKET", "mlops-churn-rushi")
    model_key = "models/churn_model.pkl"
    local_model_path = "/tmp/churn_model.pkl"

    try:
        print(f"Downloading model from s3://{bucket}/{model_key}...")
        s3.download_file(bucket, model_key, local_model_path)
        print("Model downloaded successfully.")
    except Exception as e:
        raise RuntimeError(f"Failed to download model from S3: {e}")

    return joblib.load(local_model_path)


# Load the model once during application startup
model = load_model()


class PredictRequest(BaseModel):
    tenure: float
    monthly_charges: float
    total_charges: float
    contract: int              # 0=Month-to-Month, 1=One Year, 2=Two Year
    internet_service: int
    payment_method: int


@app.get("/health")
def health():
    return {"status": "healthy"}


@app.post("/predict")
def predict(req: PredictRequest):
    features = np.array([[
        req.tenure,
        req.monthly_charges,
        req.total_charges,
        req.contract,
        req.internet_service,
        req.payment_method
    ]])

    prediction = model.predict(features)[0]
    probability = model.predict_proba(features)[0][1]

    return {
        "churn_prediction": int(prediction),
        "churn_probability": round(float(probability), 4),
        "label": "Will Churn" if prediction == 1 else "Will Stay"
    }

from mangum import Mangum

handler = Mangum(app)
