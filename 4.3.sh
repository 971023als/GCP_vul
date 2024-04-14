#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.3",
  "위험도": "중요도 중",
  "진단_항목": "SQL 암호화 설정",
  "대응방안": {
    "설명": "Cloud SQL 인스턴스는 모든 데이터를 자동으로 암호화합니다. 사용 가능한 암호화 키로는 'Google 관리 키'와 '고객 관리 키'가 있습니다. '고객 관리 키'를 사용할 경우, CKMS를 통해 키 순환 주기를 설정하여 보안 위협을 방지합니다.",
    "설정방법": [
      "CKMS를 통한 암호화 키 생성 및 설정",
      "Cloud SQL 인스턴스에서 암호화 키 선택 및 적용",
      "암호화키 순환주기 확인 및 설정"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set Google Cloud project
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Create a KeyRing
KEY_RING="sql-encryption-key-ring"
REGION="global"
echo "Creating Key Ring..."
gcloud kms keyrings create $KEY_RING --location $REGION

# Create an encryption key
KEY_NAME="sql-encryption-key"
echo "Creating Encryption Key..."
gcloud kms keys create $KEY_NAME --location $REGION --keyring $KEY_RING --purpose encryption

# Set up a Cloud SQL instance with the customer-managed encryption key
INSTANCE_NAME="secure-sql-instance"
echo "Creating Cloud SQL Instance with Customer-Managed Encryption Key..."
gcloud sql instances create $INSTANCE_NAME --database-version POSTGRES_12 --region $REGION --root-password="your-strong-password" --disk-encryption-key projects/$PROJECT_ID/locations/$REGION/keyRings/$KEY_RING/cryptoKeys/$KEY_NAME

echo "Setup complete. SQL instance created with specified encryption settings."
