#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.1",
  "위험도": "중요도 중",
  "진단_항목": "Compute Engine 디스크 암호화 설정",
  "대응방안": {
    "설명": "Compute Engine은 인스턴스 외부에서 영구 디스크 저장소 공간으로 이동하기 전에 데이터를 자동으로 암호화합니다. 사용자는 시스템 정의 키, 고객 제공 키, 고객 관리 키 중 하나를 사용하여 데이터를 암호화할 수 있습니다.",
    "설정방법": [
      "디스크 암호화키 설정: Compute Engine에서 디스크 만들기 선택, 디스크 정보 및 암호화 키 타입 설정, KMS를 통한 고객 관리 키 선택 및 적용",
      "암호화키 생성 및 순환주기 설정: Key Management에서 키링 및 키 생성, 키 순환 주기 설정 및 적용"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set Google Cloud project
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a disk with Google-managed encryption keys
echo "Creating a disk with Google-managed encryption keys..."
gcloud compute disks create encrypted-disk --size 100GB --zone us-central1-a --type pd-standard --encryption-key-type google-managed

# Setup for Customer-Managed Encryption Keys (CMEK)
echo "Setting up Customer-Managed Encryption Keys..."
KMS_KEYRING="my-keyring"
KMS_KEY="my-encryption-key"
KMS_LOCATION="global"

# Create a Keyring and Key
gcloud kms keyrings create $KMS_KEYRING --location $KMS_LOCATION
gcloud kms keys create $KMS_KEY --keyring $KMS_KEYRING --location $KMS_LOCATION --purpose encryption

# Create a disk with the Customer-Managed Key
echo "Creating a disk with a Customer-Managed Key..."
gcloud compute disks create cmek-disk --size 100GB --zone us-central1-a --type pd-standard --encryption-key projects/$PROJECT_ID/locations/$KMS_LOCATION/keyRings/$KMS_KEYRING/cryptoKeys/$KMS_KEY

echo "Setup complete. Disks created with specified encryption settings."
