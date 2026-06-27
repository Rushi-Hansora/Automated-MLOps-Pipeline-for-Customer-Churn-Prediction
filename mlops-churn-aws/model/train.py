import pandas as pd
import joblib
import boto3
import os
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, classification_report

# 1. Load Data
print("Loading dataset...")
data_path = 'data/WA_Fn-UseC_-Telco-Customer-Churn.csv'

if not os.path.exists(data_path):
    raise FileNotFoundError(f"Dataset file not found at '{data_path}'. Please check Step 2.")

df = pd.read_csv(data_path)

# Clean missing values
df['TotalCharges'] = pd.to_numeric(df['TotalCharges'], errors='coerce')
df.dropna(inplace=True)

# Convert target variable to binary (1/0)
df['Churn'] = (df['Churn'] == 'Yes').astype(int)

# Detect exact column name for Payment Method
payment_col = 'PaymentMethod' if 'PaymentMethod' in df.columns else 'Payment Method'
print(f"Using payment column: '{payment_col}'")

# 2. Feature Engineering
print("Engineering features...")
cat_cols = ['gender', 'Partner', 'Dependents', 'PhoneService', 'InternetService', 'Contract', payment_col]

le = LabelEncoder()
for col in cat_cols:
    df[col] = le.fit_transform(df[col])

# Select specific features for training
features = ['tenure', 'MonthlyCharges', 'TotalCharges', 'Contract', 'InternetService', payment_col]
X = df[features]
y = df['Churn']

# 3. Split data and Train Model
print("Training model...")
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluate performance
acc = accuracy_score(y_test, model.predict(X_test))
print(f'\nAccuracy: {acc:.4f}')
print("\nClassification Report:")
print(classification_report(y_test, model.predict(X_test)))

# 4. Save Locally and Upload to AWS S3
print("\nSaving model artifact locally...")
os.makedirs('model', exist_ok=True)
joblib.dump(model, 'model/churn_model.pkl')

print("Uploading model artifact to AWS S3...")
s3 = boto3.client('s3')
# Pulls from environment variable or defaults to your standard portfolio bucket
bucket = os.environ.get('MODEL_BUCKET', 'mlops-churn-rushi')

try:
    s3.upload_file('model/churn_model.pkl', bucket, 'models/churn_model.pkl')
    print(f'Successfully uploaded to s3://{bucket}/models/churn_model.pkl')
except Exception as e:
    print(f"S3 upload failed: {e}")
    print("\n[NOTE]: The local model was saved successfully in 'model/churn_model.pkl'!")
    print("If the S3 upload failed, make sure you have configured your AWS CLI credentials using 'aws configure'.")