#!/bin/bash


{
  "분류": "가상 리소스 관리",
  "코드": "3.4",
  "위험도": "중요도 상",
  "진단_항목": "네트워크 방화벽 인/아웃바운드 ANY 설정 관리",
  "대응방안": {
    "설명": "VPC 방화벽 규칙은 인스턴스와 다른 네트워크 사이, 그리고 동일 네트워크 내의 인스턴스 간 통신을 허용하거나 거부할 수 있도록 도와줍니다. 이 규칙들은 인스턴스의 구성이나 운영 체제와 관계없이 작동하며, 네트워크 수준에서 정의되어 인스턴스별로 연결을 관리합니다.",
    "설정방법": [
      "[메인] > [VPC 네트워크] > [방화벽] - 방화벽 규칙 설정",
      "방화벽 규칙(송/수신) 내 프로토콜/포트 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the GCP project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# List all firewall rules in the VPC network
echo "Listing all VPC firewall rules..."
gcloud compute firewall-rules list

# Create a firewall rule in VPC
echo "Creating a new VPC firewall rule..."
gcloud compute firewall-rules create example-firewall-rule \
    --direction=INGRESS \
    --priority=1000 \
    --network=default \
    --action=ALLOW \
    --rules=tcp:22,tcp:80 \
    --source-ranges="192.168.1.0/24"
echo "Firewall rule created."

# Update a firewall rule in VPC
echo "Updating a VPC firewall rule..."
gcloud compute firewall-rules update example-firewall-rule \
    --priority=900 \
    --rules=tcp:443,tcp:80
echo "Firewall rule updated."

# Delete a firewall rule in VPC
read -p "Enter the name of the firewall rule to delete: " rule_name
gcloud compute firewall-rules delete $rule_name --quiet
echo "Firewall rule $rule_name deleted."
