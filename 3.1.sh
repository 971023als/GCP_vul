#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.1",
  "위험도": "중요도 상",
  "진단_항목": "ID 및 API 액세스",
  "대응방안": {
    "설명": "VM에서 실행되는 애플리케이션은 서비스 계정을 사용하여 Google Cloud API를 호출합니다. 이를 통해 필요한 서비스에 대한 적절한 액세스 권한을 관리하고, 필요 이상의 권한 부여를 방지하여 보안을 강화할 수 있습니다.",
    "설정방법": [
      "[메인] > [Compute Engine] > [VM인스턴스]",
      "인스턴스 만들기",
      "VM 인스턴스 옵션 및 정보 입력",
      "'기본 액세스 허용' 액세스 범위 설정",
      "'모든 Cloud API에 대한 전체 액세스 허용' 액세스 범위 설정",
      "'각 API에 액세스 설정' 액세스 범위 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


echo "Initializing Google Cloud SDK..."
gcloud init

echo "Select the project you want to manage:"
gcloud projects list
read -p "Enter Project ID: " project_id
gcloud config set project $project_id

echo "Listing current VM instances..."
gcloud compute instances list

echo "Enter the name of the VM instance to configure API access:"
read vm_name

# Displaying current API access scopes for the VM
current_scopes=$(gcloud compute instances describe $vm_name --format='value(serviceAccounts.scopes)')
echo "Current API access scopes for $vm_name: $current_scopes"

# Setting up new API access scopes
echo "Available scopes: https://www.googleapis.com/auth/cloud-platform, https://www.googleapis.com/auth/compute, etc."
read -p "Enter the scopes to set, separated by commas: " scopes

# Updating the VM instance with new API scopes
gcloud compute instances set-service-account $vm_name --scopes $scopes

echo "Updated $vm_name with new API access scopes."

# Verify the update
updated_scopes=$(gcloud compute instances describe $vm_name --format='value(serviceAccounts.scopes)')
echo "Updated API access scopes for $vm_name: $updated_scopes"
