#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.11",
  "위험도": "중요도 중",
  "진단_항목": "Storage 제어 관리",
  "대응방안": {
    "설명": "Cloud Storage의 서명된 URL을 사용하여 제한된 시간 동안 리소스에 대한 읽기, 쓰기, 삭제 권한을 부여합니다. 이 URL은 쿼리 문자열에 인증 정보를 포함하여 인증받지 않은 사용자도 특정 작업을 수행할 수 있습니다.",
    "설정방법": [
      "서비스 계정 생성 및 필요한 키 만들기: IAM 및 관리자 > 서비스 계정 > 키 만들기",
      "서명된 URL 생성 도구 설치 및 설정",
      "객체 URI 확인 후 서명된 URL 생성",
      "서명된 URL을 안전하게 관리하고 사용시간을 최소화"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your GCP project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a service account for generating signed URLs
SERVICE_ACCOUNT_NAME="signed-url-generator"
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
    --description="Service account for signed URL generation" \
    --display-name="Signed URL Generator"

# Create a key for the service account
echo "Creating a key for the service account..."
gcloud iam service-accounts keys create ~/key.json \
    --iam-account $SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com

# Install necessary tools for generating signed URLs (assuming gsutil is already installed with gcloud)
echo "Installing required tools..."
# Normally, gsutil is sufficient which comes with gcloud

# Specify the bucket and object
BUCKET_NAME="your-bucket-name"
OBJECT_NAME="your-object-name"
DURATION="3600" # duration the signed URL will be valid, in seconds

# Generate the signed URL
echo "Generating signed URL..."
gsutil signurl -d $DURATION"s" ~/key.json gs://$BUCKET_NAME/$OBJECT_NAME

# Clean up: Remove the generated key file
rm ~/key.json

# Remember to replace 'your-project-id', 'your-bucket-name', and 'your-object-name' with your actual GCP project ID, bucket name, and object name.
