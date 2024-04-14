#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.16",
  "위험도": "중요도 하",
  "진단_항목": "Cloud ID 계정 사용자 이상징후 알림 설정",
  "대응방안": {
    "설명": "Cloud ID 계정 사용을 보다 안전하게 관리하기 위해 관리자 관리 콘솔에서 사용자 이상징후에 대한 알림을 설정합니다. 이는 비밀번호 유출, 사용중지된 사용자의 활성화, 의심스러운 로그인, 사용자에게 부여된 관리자 권한 등의 이상징후에 대해 관리자가 신속하게 대응할 수 있도록 돕습니다.",
    "설정방법": [
      "관리 콘솔(https://admin.google.com) 접속",
      "보안 → 보안규칙 메뉴 이동",
      "알림 설정할 이상징후 선택",
      "이메일 알림 보내기 옵션 활성화",
      "이메일 수신자 설정",
      "알림 규칙 저장 및 활성화"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Function to set up anomaly detection alerts in Google Admin
setup_anomaly_alerts() {
  # Ensure the Google Admin API is enabled
  gcloud services enable admin.googleapis.com

  # Configuring alerts for Cloud ID users
  echo "Setting up anomaly detection alerts for Cloud ID users..."
  gcloud alpha monitoring policies create \
    --policy-from-file="alert_policy.yaml"
}

# Example policy file creation (Modify 'alert_policy.yaml' as per your requirements)
echo "Creating alert policy file..."
cat <<EOF > alert_policy.yaml
description: 'Anomaly detection for Cloud ID users'
conditions:
  - displayName: 'Admin Privileges Granted'
    conditionThreshold:
      filter: 'metadata.user="admin_activity"'
      comparison: 'COMPARISON_GT'
      thresholdValue: 1
      duration: '60s'
      trigger:
        count: 1
notificationChannels:
  - 'email'
EOF

# Example usage of the function
# Uncomment the following line to execute the setup function:
# setup_anomaly_alerts
