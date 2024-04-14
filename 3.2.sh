#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.2",
  "위험도": "중요도 하",
  "진단_항목": "VM 인스턴스 관리 및 보안",
  "대응방안": {
    "설명": "VM 인스턴스 삭제 작업 부하 중에는 필수 애플리케이션 또는 서비스를 실행하는 특정 VM 인스턴스가 존재할 수 있습니다. 이러한 인스턴스는 지속적으로 실행되어야 하며, VM 삭제 보호(deletionProtection) 속성을 설정하여 실수로 삭제되지 않도록 보호할 수 있습니다. 또한, 보안 설정된 VM은 Compute Engine VM 인스턴스의 무결성을 보장하여 부팅 또는 커널 수준의 멀웨어로부터 보호합니다.",
    "설정방법": [
      "[메인] > [Compute Engine] > [VM인스턴스]",
      "인스턴스 만들기",
      "VM 인스턴스 옵션 및 정보 입력",
      "부팅 디스크 변경",
      "VM 이미지 설정",
      "[관리] > [삭제 보호 사용 설정]",
      "[보안] > [보안 VM] > [보안 부팅 설정], [vTPM 설정], [무결성 모니터링 사용 설정]",
      "인스턴스 생성 완료",
      "설정된 보안 VM 옵션 확인"
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

echo "Creating a VM instance with security settings..."
read -p "Enter the name for the new VM instance: " vm_name
read -p "Enter the zone for the VM (e.g., us-central1-a): " vm_zone

# Command to create a VM with security features enabled
gcloud compute instances create $vm_name \
    --zone $vm_zone \
    --machine-type "e2-medium" \
    --image-family "debian-10" \
    --image-project "debian-cloud" \
    --boot-disk-size "10GB" \
    --boot-disk-type "pd-standard" \
    --boot-disk-device-name $vm_name \
    --no-deletion-protection \
    --shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring

echo "$vm_name created with security settings enabled."

# Enable deletion protection
echo "Enabling deletion protection for $vm_name..."
gcloud compute instances update $vm_name --zone $vm_zone --deletion-protection

echo "Deletion protection enabled for $vm_name."

# Verify settings
echo "Verifying the settings for $vm_name..."
gcloud compute instances describe $vm_name --zone $vm_zone --format="value(name, shieldedVmConfig)"
