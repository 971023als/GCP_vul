#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.5",
  "위험도": "중요도 상",
  "진단_항목": "네트워크 방화벽 인/아웃바운드 불필요 정책 관리",
  "대응방안": {
    "설명": "VPC 방화벽 규칙은 특정 프로젝트 및 네트워크에 적용되며, 지정한 구성을 기준으로 가상 머신(VM) 인스턴스 간의 연결을 허용하거나 거부할 수 있습니다. 이 규칙들은 인스턴스의 구성이나 운영 체제와 관계없이 작동하며, 트래픽의 소스와 목적지를 기준으로 특정 트래픽 유형을 대상으로 할 수 있습니다.",
    "설정방법": [
      "[메인] > [VPC 네트워크] > [방화벽] - 방화벽 규칙 설정",
      "방화벽 규칙의 소스 및 목적지 기준으로 불필요한 정책 식별 및 수정"
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

# Review specific firewall rule
echo "Reviewing specific firewall rule..."
read -p "Enter the firewall rule name to review: " firewall_rule_name
gcloud compute firewall-rules describe $firewall_rule_name

# Update a firewall rule in VPC
echo "Updating a VPC firewall rule..."
gcloud compute firewall-rules update $firewall_rule_name \
    --description="Updated to eliminate unnecessary open ports" \
    --rules=tcp:443,tcp:80
echo "Firewall rule updated."

# Delete unnecessary or risky firewall rule in VPC
read -p "Enter the name of the firewall rule to delete if found unnecessary: " rule_name
gcloud compute firewall-rules delete $rule_name --quiet
echo "Firewall rule $rule_name deleted."
