#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.4",
  "위험도": "중요도 중",
  "진단_항목": "Cloud Storage 암호화 설정",
  "대응방안": {
    "설명": "Cloud Storage는 모든 데이터를 자동으로 암호화합니다. 사용 가능한 암호화 키는 'Google 관리 키'와 '고객 관리 키'입니다. '고객 관리 키'를 사용할 경우, 키에 대한 순환 주기 설정을 통해 보안을 강화할 수 있습니다.",
    "설정방법": [
      "Cloud Storage에서 버킷 생성 및 암호화 키 설정",
      "고객 관리 키를 위한 순환 주기 설정",
      "암호화키 생성 및 순환주기 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set Google Cloud project
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a KeyRing
KEY_RING="storage-encryption-key-ring"
REGION="global"
echo "Creating Key Ring..."
gcloud kms keyrings create $KEY_RING --location $REGION

# Create an encryption key
KEY_NAME="storage-encryption-key"
echo "Creating Encryption Key..."
gcloud kms keys create $KEY_NAME --location $REGION --keyring $KEY_RING --purpose encryption

# Create a storage bucket with the customer-managed encryption key
BUCKET_NAME="secure-storage-bucket"
echo "Creating Cloud Storage Bucket with Customer-Managed Encryption Key..."
gsutil mb -p $PROJECT_ID -l $REGION -b on gs://$BUCKET_NAME
gsutil kms encryption -k projects/$PROJECT_ID/locations/$REGION/keyRings/$KEY_RING/cryptoKeys/$KEY_NAME gs://$BUCKET_NAME

echo "Setup complete. Storage bucket created with specified encryption settings."
