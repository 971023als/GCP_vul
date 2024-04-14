#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.17",
  "위험도": "중요도 중",
  "진단_항목": "가상 리소스 이상징후 알림 설정",
  "대응방안": {
    "설명": "Cloud Monitoring을 통해 Google Cloud의 가상 리소스(Compute, Cloud SQL, Storage, Networking)의 이상징후를 감지하고 알림을 설정합니다. 이를 통해 리소스의 상태 및 운영상의 비정상적인 행동을 모니터링하여 신속하게 대응할 수 있습니다.",
    "설정방법": [
      "Cloud Console의 [모니터링] - [알림] - [CREATE POLICY] 메뉴로 이동",
      "METRIC 설정 및 기타 세부 Condition 설정",
      "트리거 및 알림 수신자 설정",
      "알림 정책 이름 설정 및 생성",
      "설정된 알림 정책의 활성화 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Enable the Cloud Monitoring API
gcloud services enable monitoring.googleapis.com

# Function to create alert policies
create_alert_policy() {
  # Define a new alert policy configuration
  cat <<EOF > alert_policy.json
{
  "displayName": "Virtual Resources Anomaly Detection",
  "conditions": [
    {
      "displayName": "High CPU Utilization",
      "conditionThreshold": {
        "filter": "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" AND resource.type=\"gce_instance\"",
        "comparison": "COMPARISON_GT",
        "thresholdValue": 0.8,
        "duration": "300s",
        "aggregations": [{
            "alignmentPeriod": "60s",
            "perSeriesAligner": "ALIGN_MEAN"
        }]
      }
    }
  ],
  "combiner": "OR",
  "notificationChannels": [
    "$(gcloud monitoring channels list --format="value(name)" --filter="displayName='Email Channel')"
  ]
}
EOF

  # Create the alert policy using the gcloud CLI
  gcloud alpha monitoring policies create --policy-from-file=alert_policy.json
}

# Run the function to set up the alert policy
create_alert_policy
