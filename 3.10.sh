#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.10",
  "위험도": "중요도 중",
  "진단_항목": "Storage 버킷 ACL 관리",
  "대응방안": {
    "설명": "Cloud Storage는 Cloud IAM 및 ACL을 통해 버킷과 객체에 대한 액세스 권한을 제어합니다. Cloud IAM은 프로젝트 및 버킷 수준에서 권한을 부여하는 반면, ACL은 객체 단위로 미세 조정된 권한을 제공합니다.",
    "설정방법": [
      "Cloud Storage에서 버킷 생성: 관리 콘솔 > Cloud Storage > 버킷 > 버킷 생성",
      "액세스 제어 모델 선택 및 버킷 생성",
      "버킷 권한 설정 및 IAM 역할 할당",
      "개별 객체에 대한 ACL 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your GCP project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a new storage bucket
BUCKET_NAME="my-storage-bucket"
echo "Creating a new storage bucket..."
gcloud storage buckets create $BUCKET_NAME --location US

# Set IAM policy for the bucket
echo "Setting IAM policy for the bucket..."
gcloud storage buckets add-iam-policy-binding $BUCKET_NAME \
    --member='user:example-user@gmail.com' \
    --role='roles/storage.objectViewer'

# List the current ACLs for the bucket
echo "Current ACLs for the bucket:"
gsutil acl get gs://$BUCKET_NAME

# Update ACL to give a user access
echo "Updating ACL to give a user read access..."
gsutil acl ch -u example-user@gmail.com:R gs://$BUCKET_NAME

# Verify updated ACL settings
echo "Verifying updated ACL settings..."
gsutil acl get gs://$BUCKET_NAME

# Remember to replace 'your-project-id', 'my-storage-bucket', and 'example-user@gmail.com' with your actual project ID, desired bucket name, and user email.
