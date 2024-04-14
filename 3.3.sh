#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.3",
  "위험도": "중요도 중",
  "진단_항목": "애플리케이션 방화벽",
  "대응방안": {
    "설명": "App Engine 방화벽을 사용하여 지정된 IP 주소 범위에서 요청을 허용하거나 거부하는 규칙을 설정할 수 있습니다. 방화벽 규칙은 중요도에 따라 우선순위가 매겨지며, 이는 방화벽 내에서 다른 규칙에 대한 상대적 중요도를 결정합니다. default 규칙은 가장 낮은 우선순위를 가지고 모든 IP에 적용됩니다.",
    "설정방법": [
      "[App Engine] > [방화벽 규칙] > [규칙 만들기] - 방화벽 규칙 생성",
      "적용하고자 하는 서비스에 대한 방화벽 규칙 설정",
      "방화벽 규칙 생성 확인",
      "App Engine 방화벽 규칙 적용 확인",
      "[App Engine] > [방화벽 규칙] > [규칙 선택] > [삭제] - 방화벽 규칙 삭제",
      "방화벽 규칙 삭제 확인",
      "방화벽 규칙 적용 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the GCP project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a firewall rule in App Engine
echo "Creating a new firewall rule in App Engine..."
gcloud app firewall-rules create 1000 \
    --action allow \
    --source-range "192.168.1.0/24" \
    --description "Allow traffic from specific IP range"
echo "Firewall rule created."

# List all firewall rules in App Engine
echo "Listing all firewall rules..."
gcloud app firewall-rules list

# Delete a firewall rule in App Engine
read -p "Enter the priority of the firewall rule to delete: " rule_priority
gcloud app firewall-rules delete $rule_priority --quiet
echo "Firewall rule with priority $rule_priority deleted."

# Verify the rules after deletion
echo "Verifying firewall rules post-deletion..."
gcloud app firewall-rules list
