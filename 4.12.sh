#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.12",
  "위험도": "중요도 중",
  "진단_항목": "VPC 네트워크 흐름 로그 설정 관리",
  "대응방안": {
    "설명": "VPC 흐름 로그는 VM 인스턴스에서 전송되거나 수신되는 네트워크 흐름의 샘플을 기록합니다. 이는 VPC 네트워크에서 작동하며, 서브넷별로 활성화 또는 비활성화 할 수 있습니다. 이 기능은 네트워크 보안 및 감사를 위해 중요하며, 인바운드 및 아웃바운드 네트워크 트래픽을 모니터링하는 데 사용됩니다.",
    "설정방법": [
      "VPC 네트워크에서 새 서브넷을 생성하고, 흐름 로그를 활성화 설정",
      "기존 서브넷에 대해 흐름 로그 활성화",
      "Google Cloud Console 또는 gcloud 명령어를 사용하여 흐름 로그 설정 관리"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Function to enable flow logs for a specific subnet
enable_flow_logs() {
  VPC_NAME=$1
  SUBNET_NAME=$2
  echo "Enabling flow logs for subnet $SUBNET_NAME in VPC $VPC_NAME..."
  gcloud compute networks subnets update $SUBNET_NAME --region YOUR_REGION --enable-flow-logs
}

# Function to disable flow logs for a specific subnet
disable_flow_logs() {
  VPC_NAME=$1
  SUBNET_NAME=$2
  echo "Disabling flow logs for subnet $SUBNET_NAME in VPC $VPC_NAME..."
  gcloud compute networks subnets update $SUBNET_NAME --region YOUR_REGION --no-enable-flow-logs
}

# Example usage of the functions
# Uncomment the following lines to enable or disable flow logs as needed:

# Enable flow logs for a specific subnet
# enable_flow_logs "your-vpc-name" "your-subnet-name"

# Disable flow logs for a specific subnet
# disable_flow_logs "your-vpc-name" "your-subnet-name"
