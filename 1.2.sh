#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.2",
  "위험도": "중요도 중",
  "진단_항목": "Cloud ID 사용자 정책 관리",
  "대응방안": {
    "설명": "Google Workspace를 이용한 Cloud ID 사용자에게 적절한 관리자 역할 할당을 통해 권한 오남용을 방지하고, 필요한 역할과 권한을 사용자 직무에 맞추어 설정합니다.",
    "설정방법": [
      "Google Admin에서 사용자 추가 및 역할 할당",
      "사용자 관련 정보 입력 후 저장",
      "관리자 역할 및 권한을 특정 사용자에게 지정",
      "사용자 프로필 및 조직 구조 조회",
      "Cloud ID 사용자 정보를 최신 상태로 유지"
    ]
  },
  "현황": [],
  "진단_결과": ""
}


# Initialize GCP CLI and authenticate the user
echo "Initializing GCP CLI..."
gcloud init --quiet

# Check and set project
echo "Setting up the GCP project..."
gcloud config set project YOUR_PROJECT_ID

# List all IAM roles in the project
echo "Listing all IAM roles..."
gcloud iam roles list --project YOUR_PROJECT_ID

# Add a new IAM user and assign roles
echo "Adding new IAM user and assigning roles..."
gcloud iam service-accounts create new-service-account --display-name "New Service Account"
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member='serviceAccount:new-service-account@YOUR_PROJECT_ID.iam.gserviceaccount.com' --role='roles/editor'

# Verify the IAM roles assigned to the user
echo "Verifying IAM roles assigned to the new user..."
gcloud iam service-accounts get-iam-policy new-service-account@YOUR_PROJECT_ID.iam.gserviceaccount.com

echo "Setup complete. Please check your GCP console for further verification."
