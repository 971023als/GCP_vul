#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.7",
  "위험도": "중요도 중",
  "진단_항목": "VPC 네트워크 서브넷 비공개 구글 액세스 설정",
  "대응방안": {
    "설명": "비공개 Google 액세스를 사용하면 내부 IP 주소만 있는 VM 인스턴스가 Google API 및 서비스의 공개 IP 주소에 연결할 수 있습니다. 이 설정은 서브넷 수준에서 활성화할 수 있으며, 해당 기능을 활성화하면 인터넷 게이트웨이를 통해 Google API로 트래픽을 전송할 수 있습니다.",
    "설정방법": [
      "VPC 네트워크 생성: [VPC 네트워크] > [VPC 네트워크 만들기]",
      "비공개 Google 액세스 사용 설정: [VPC 네트워크 만들기] > [서브넷] > [새 서브넷] - 비공개 Google 액세스 사용 설정",
      "VPC 네트워크 및 서브넷 검토: 생성된 VPC 네트워크 및 서브넷 내용 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the GCP project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a VPC network with custom mode
echo "Creating a VPC network..."
gcloud compute networks create custom-vpc --subnet-mode=custom --bgp-routing-mode=regional

# Add a custom subnet and enable Private Google Access
echo "Adding a custom subnet with Private Google Access..."
gcloud compute networks subnets create custom-subnet --network=custom-vpc \
    --range=192.168.1.0/24 --region=us-central1 --enable-private-ip-google-access

# List all subnets to confirm settings
echo "Listing all subnets..."
gcloud compute networks subnets list --filter="enablePrivateIpGoogleAccess:true"

# Optionally, disable Private Google Access if needed
# read -p "Enter the subnet name to disable Private Google Access: " subnet_name
# gcloud compute networks subnets update $subnet_name --no-enable-private-ip-google-access

# Confirm the changes
echo "Configuration completed. Review the settings above."

# Additional VPC and subnet management tasks can be added here as needed.
