#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.14",
  "위험도": "중요도 중",
  "진단_항목": "로그 보관 설정",
  "대응방안": {
    "설명": "Cloud Logging은 GCP에서 활용되는 로그를 효과적으로 관리하고 분석합니다. 로그 버킷을 통해 데이터를 지역적으로 분리하여 보관할 수 있으며, 설정된 기간 동안 보안 로그를 안전하게 유지합니다. 로그 보관 정책을 통해 필요한 기간 동안 데이터를 보존함으로써 컴플라이언스와 보안 표준을 유지할 수 있습니다.",
    "설정방법": [
      "Google Cloud Console에 로그인 후 Cloud Logging으로 이동",
      "로그 버킷 만들기를 선택하고, 필요한 정보와 리전을 설정",
      "보관 기간 설정 후 로그 버킷을 생성",
      "생성된 로그 버킷의 보관 기간을 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Function to create a log bucket with specified retention days
create_log_bucket() {
  BUCKET_NAME=$1
  LOCATION=$2
  RETENTION_DAYS=$3
  echo "Creating log bucket: $BUCKET_NAME in location: $LOCATION with retention days: $RETENTION_DAYS..."
  gcloud logging buckets create $BUCKET_NAME \
    --location=$LOCATION \
    --retention-days=$RETENTION_DAYS
}

# Function to update log bucket retention days
update_log_bucket_retention() {
  BUCKET_NAME=$1
  RETENTION_DAYS=$2
  echo "Updating log bucket: $BUCKET_NAME with new retention days: $RETENTION_DAYS..."
  gcloud logging buckets update $BUCKET_NAME \
    --retention-days=$RETENTION_DAYS
}

# Example usage of the functions
# Uncomment the following lines to create or update log buckets as needed:

# Create a new log bucket
# create_log_bucket "your-log-bucket-name" "global" 365

# Update an existing log bucket retention days
# update_log_bucket_retention "your-log-bucket-name" 365
