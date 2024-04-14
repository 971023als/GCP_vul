#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.12",
  "위험도": "중요도 상",
  "진단_항목": "Storage 리소스 퍼블릭 Access 관리",
  "대응방안": {
    "설명": "Storage 버킷의 퍼블릭 액세스는 allUsers 또는 allAuthenticatedUsers에게 버킷이나 데이터에 대한 액세스 권한을 부여합니다. 이는 객체 및 버킷이 외부에 노출될 수 있으므로, 안전한 접근을 위해 적절한 접근 설정이 필요합니다.",
    "설정방법": [
      "Storage 내에서 퍼블릭 액세스 권한을 삭제: '작업 더 보기' 클릭 → '버킷 권한 수정' → 퍼블릭 액세스 권한 확인 후 삭제",
      "Firebase Storage를 사용하여 객체 접근 규칙 설정: Firebase 프로젝트 추가 → Storage 추가 → 세부적인 규칙 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the Google Cloud Project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# List all buckets in the project
echo "Listing all buckets in the project..."
gcloud storage buckets list

# Prompt user to specify the bucket for modifying access
read -p "Enter the bucket name to modify public access settings: " BUCKET_NAME

# Checking public access status
echo "Checking current public access settings for $BUCKET_NAME..."
gsutil iam get gs://$BUCKET_NAME

# Command to remove allUsers or allAuthenticatedUsers from the bucket ACL (if set)
echo "Removing public access from $BUCKET_NAME..."
gsutil acl ch -d allUsers gs://$BUCKET_NAME
gsutil acl ch -d allAuthenticatedUsers gs://$BUCKET_NAME

# Confirm public access settings after update
echo "Confirming public access settings for $BUCKET_NAME after update..."
gsutil iam get gs://$BUCKET_NAME

# Reminder to replace 'your-project-id' with your actual project ID.
