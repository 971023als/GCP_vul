#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.13",
  "위험도": "중요도 중",
  "진단_항목": "방화벽 로그 관리",
  "대응방안": {
    "설명": "VPC 방화벽 규칙은 가상 머신(VM) 인스턴스 간의 연결을 제어합니다. 방화벽 규칙을 사용하여 특정 트래픽을 허용하거나 거부할 수 있으며, 방화벽 로그를 통해 네트워크 트래픽과 관련된 이벤트를 모니터링 할 수 있습니다. 이는 보안 감시와 문제 해결에 필수적입니다.",
    "설정방법": [
      "Google Cloud Console에서 VPC 네트워크 섹션으로 이동",
      "방화벽 규칙 선택 및 검토",
      "각 방화벽 규칙에 대한 로그 활성화",
      "로깅 설정이 적용된 방화벽 규칙 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Function to enable logging for a specific firewall rule
enable_firewall_logging() {
  FIREWALL_RULE_NAME=$1
  echo "Enabling logging for the firewall rule: $FIREWALL_RULE_NAME..."
  gcloud compute firewall-rules update $FIREWALL_RULE_NAME --enable-logging
}

# Function to disable logging for a specific firewall rule
disable_firewall_logging() {
  FIREWALL_RULE_NAME=$1
  echo "Disabling logging for the firewall rule: $FIREWALL_RULE_NAME..."
  gcloud compute firewall-rules update $FIREWALL_RULE_NAME --no-enable-logging
}

# Example usage of the functions
# Uncomment the following lines to enable or disable logging as needed:

# Enable logging for a specific firewall rule
# enable_firewall_logging "your-firewall-rule-name"

# Disable logging for a specific firewall rule
# disable_firewall_logging "your-firewall-rule-name"
