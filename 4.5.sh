#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.5",
  "위험도": "중요도 중",
  "진단_항목": "Storage 데이터 보존 정책 관리",
  "대응방안": {
    "설명": "Cloud Storage를 사용하여 데이터 보관, 재해 복구 및 다양한 콘텐츠 배포에 활용합니다. 모든 데이터는 기본적으로 암호화되어 저장됩니다. 데이터 보존 정책을 설정하여 중요 데이터의 무단 삭제나 수정을 방지하고, 필요에 따라 고객 관리 키를 사용하여 보다 강력한 보안을 제공합니다.",
    "설정방법": [
      "관리 콘솔에서 Storage 버킷 생성",
      "버킷에 데이터 보존 정책 설정",
      "고객 관리 키 사용 시 순환 주기 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a storage bucket with a retention policy
BUCKET_NAME="your-bucket-name"
REGION="us-central1"  # Choose the appropriate region
RETENTION_PERIOD="3650d"  # 10 years retention period

echo "Creating a Cloud Storage bucket with a retention policy..."
gsutil mb -p $PROJECT_ID -l $REGION -b on gs://$BUCKET_NAME

echo "Setting the retention policy..."
gsutil retention set $RETENTION_PERIOD gs://$BUCKET_NAME

echo "Bucket and retention policy setup complete."
