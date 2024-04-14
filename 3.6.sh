#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.6",
  "위험도": "중요도 상",
  "진단_항목": "VPC 네트워크 서브넷 관리",
  "대응방안": {
    "설명": "VPC 네트워크는 Compute Engine 가상 머신(VM) 인스턴스, Kubernetes Engine Cluster, App Engine 가변형 인스턴스, 프로젝트의 다른 리소스를 위한 연결을 제공합니다. 하위 네트워크 또는 서브넷을 통해 효율적인 IP 범위 관리가 가능합니다.",
    "설정방법": [
      "VPC 네트워크 생성: [VPC 네트워크] > [VPC 네트워크 만들기]",
      "서브넷 추가: [VPC 네트워크 만들기] > [서브넷] > [새 서브넷] - 맞춤 설정을 통한 커스텀 서브넷 및 흐름로그 사용 설정",
      "VPC 네트워크 및 서브넷 검토: 생성된 VPC 네트워크 및 서브넷 내용 확인",
      "VPC 네트워크 삭제: [VPC 네트워크] > [VPC 네트워크] - 삭제 하고자 하는 VPC 네트워크 선택 후 삭제 시도"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the GCP project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a VPC network
echo "Creating a VPC network..."
gcloud compute networks create custom-vpc --subnet-mode=custom

# Add a custom subnet to the VPC
echo "Adding a custom subnet..."
gcloud compute networks subnets create custom-subnet \
    --network=custom-vpc \
    --range=192.168.1.0/24 \
    --region=us-central1

# List all VPC networks and their subnets
echo "Listing all VPC networks and subnets..."
gcloud compute networks list
gcloud compute networks subnets list --network=custom-vpc

# Delete a VPC network
read -p "Enter the name of the VPC network to delete: " vpc_name
gcloud compute networks delete $vpc_name --quiet
echo "VPC network $vpc_name deleted."

# Additional VPC management tasks can be included here based on specific needs
