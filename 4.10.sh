#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.10",
  "위험도": "중요도 중",
  "진단_항목": "감사 로그 기록 및 관리",
  "대응방안": {
    "설명": "Google Cloud의 감사 로그 기능을 사용하여 관리자 활동, 시스템 이벤트, 데이터 액세스, 정책 거부에 대한 상세한 정보를 로그로 기록하고 관리할 수 있습니다. 이를 통해 '누가, 언제, 어디서, 무엇을 했는지' 파악할 수 있으며, 보안 감사 및 준수 검증에 필수적인 자료를 제공합니다.",
    "설정방법": [
      "IAM 및 관리자 페이지 내 감사 로그 설정: [관리 콘솔] > [IAM 및 관리자] > [감사 로그]",
      "기본 설정된 감사 로그 확인 및 필요에 따라 변경",
      "변경 사항 저장 후 로그 탐색기를 통해 로그 확인: [관리 콘솔] > [로그 기록] > [로그 탐색기]"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Function to enable audit logs for a specified service
enable_audit_logs() {
  SERVICE=$1
  echo "Enabling audit logs for $SERVICE..."

  # Enable Data Access logs (if applicable)
  gcloud services enable $SERVICE.googleapis.com
  gcloud logging sinks create $SERVICE-audit-logs \
    storage.googleapis.com/${PROJECT_ID}-audit-logs \
    --log-filter='logName:"logs/cloudaudit.googleapis.com/data_access" AND resource.type="$SERVICE"' \
    --project=$PROJECT_ID

  echo "Audit logs enabled for $SERVICE."
}

# List all Google Cloud services in the project
echo "Fetching services..."
gcloud services list --available

# Example: Enable audit logs for Cloud SQL
echo "Configuring audit logs for Cloud SQL..."
enable_audit_logs "sqladmin"

# Check if audit logs are properly configured
echo "Checking audit log configuration..."
gcloud logging sinks list --project=$PROJECT_ID
