#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.8",
  "위험도": "중요도 중",
  "진단_항목": "공유 VPC 관리",
  "대응방안": {
    "설명": "공유 VPC를 통해 조직 내 여러 프로젝트 간에 네트워크 리소스를 중앙에서 관리할 수 있습니다. 이를 통해 조직은 네트워크 리소스의 보안과 효율성을 향상시키면서 비용을 절감할 수 있습니다. 공유 VPC는 호스트 프로젝트와 여러 서비스 프로젝트 간에 IP 주소 범위, 서브넷, 방화벽 규칙을 공유할 수 있게 해줍니다.",
    "설정방법": [
      "공유 VPC 설정: [VPC 네트워크] > [공유 VPC] > [공유 VPC 설정]",
      "서브넷 공유 설정: 조직 내 타 프로젝트와 공유할 서브넷 설정",
      "프로젝트 연결 설정: 연결할 프로젝트 설정",
      "공유된 VPC 정보 확인: 설정된 공유 VPC 정보 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the GCP project ID for the host project
HOST_PROJECT_ID="your-host-project-id"
gcloud config set project $HOST_PROJECT_ID

# Enable Shared VPC on a host project
echo "Enabling Shared VPC on the host project..."
gcloud compute shared-vpc enable $HOST_PROJECT_ID

# Associate service projects with the Shared VPC
SERVICE_PROJECT_ID="your-service-project-id"
echo "Associating service project with the Shared VPC..."
gcloud compute shared-vpc associated-projects add $SERVICE_PROJECT_ID --host-project $HOST_PROJECT_ID

# Create a new subnet in the Shared VPC
REGION="your-region"
echo "Creating a new subnet in the Shared VPC..."
gcloud compute networks subnets create shared-subnet --network=default --range=10.128.0.0/20 --region=$REGION --project=$HOST_PROJECT_ID

# List all Shared VPC settings to confirm
echo "Listing all Shared VPC settings..."
gcloud compute shared-vpc get-host-project $SERVICE_PROJECT_ID

# Optionally, if you need to disassociate a service project
# echo "Disassociating service project from the Shared VPC..."
# gcloud compute shared-vpc associated-projects remove $SERVICE_PROJECT_ID --host-project $HOST_PROJECT_ID

# Confirm the changes
echo "Shared VPC configuration completed. Review the settings above."

# Additional VPC and subnet management tasks can be added here as needed.
