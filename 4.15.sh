#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.15",
  "위험도": "중요도 중",
  "진단_항목": "Google 계정 사용자 이상징후 알림 설정",
  "대응방안": {
    "설명": "Cloud Monitoring을 사용하여 Google 계정 사용자의 활동을 모니터링하고 이상징후를 감지할 수 있습니다. BindPlane 등의 서비스를 이용하여 다양한 소스에서 데이터를 수집하고 이를 분석하여 사용자의 비정상적인 활동을 조기에 포착합니다. 이를 통해 보안 사고의 위험을 줄일 수 있습니다.",
    "설정방법": [
      "Cloud Monitoring으로 이동",
      "알림 정책을 생성",
      "필요한 메트릭과 조건을 설정",
      "알림을 받을 대상과 통지 방법을 설정",
      "알림 정책을 활성화하여 이상징후 발생 시 즉시 알림 받기"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Function to create a notification policy for detecting anomalies
create_notification_policy() {
  POLICY_NAME=$1
  CONDITION_METRIC=$2
  CONDITION_TYPE=$3
  NOTIFICATION_CHANNELS=$4  # Provide channel IDs in a comma-separated list

  echo "Creating notification policy: $POLICY_NAME..."
  gcloud alpha monitoring policies create \
    --policy-from-file="policy.yaml" \
    --notification-channels=$NOTIFICATION_CHANNELS
}

# Example policy file creation (Modify the contents of 'policy.yaml' as per your requirements)
echo "Creating policy file..."
cat <<EOF > policy.yaml
name: '$POLICY_NAME'
description: 'Detect anomalies in user activities'
conditions:
  - displayName: 'Anomaly Detected'
    conditionThreshold:
      filter: 'metric.type="$CONDITION_METRIC"'
      comparison: $CONDITION_TYPE
      thresholdValue: 1
      duration: '60s'
      trigger:
        count: 1
notificationChannels:
  - '$NOTIFICATION_CHANNELS'
EOF

# Example usage of the function
# Uncomment the following line to create the notification policy:
# create_notification_policy "User Anomaly Alert" "metric.type=\"compute.googleapis.com/instance/cpu/utilization\"" "COMPARISON_GT" "your-notification-channel-id"
