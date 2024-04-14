#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.2",
  "위험도": "중요도 중",
  "진단_항목": "Compute Engine 이미지 암호화 설정",
  "대응방안": {
    "설명": "Compute Engine 이미지는 자동으로 Google의 암호화 키로 암호화됩니다. 사용자는 'Google 관리 키', '고객 관리 키', '고객 제공 키'를 선택하여 이미지를 암호화할 수 있습니다. 고객 제공 키와 고객 관리 키 사용 시, 주기적인 키 변경이 필요합니다.",
    "설정방법": [
      "이미지 암호화키 설정: Compute Engine에서 이미지 만들기 선택, 이미지 정보 및 암호화 키 타입 설정, KMS를 통한 고객 관리 키 선택 및 적용",
      "암호화키 생성 및 순환주기 설정: Key Management에서 키링 및 키 생성, 키 순환 주기 설정 및 적용"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set Google Cloud project
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Specify the disk and image names
DISK_NAME="source-disk"
IMAGE_NAME="encrypted-image"

# Create a disk from which the image will be created
echo "Creating a source disk..."
gcloud compute disks create $DISK_NAME --size 100GB --zone us-central1-a --type pd-standard

# Setup for Customer-Managed Encryption Keys (CMEK)
echo "Setting up Customer-Managed Encryption Keys..."
KMS_KEYRING="my-keyring"
KMS_KEY="my-image-encryption-key"
KMS_LOCATION="global"

# Create a Keyring and Key
gcloud kms keyrings create $KMS_KEYRING --location $KMS_LOCATION
gcloud kms keys create $KMS_KEY --keyring $KMS_KEYRING --location $KMS_LOCATION --purpose encryption

# Create an image using the Customer-Managed Key
echo "Creating an encrypted image from the disk..."
gcloud compute images create $IMAGE_NAME --source-disk $DISK_NAME --source-disk-zone us-central1-a --kms-key projects/$PROJECT_ID/locations/$KMS_LOCATION/keyRings/$KMS_KEYRING/cryptoKeys/$KMS_KEY

echo "Setup complete. Image created with specified encryption settings."
