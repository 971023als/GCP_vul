#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.20",
  "위험도": "중요도 중",
  "진단_항목": "애플리케이션 레이어 보안 비밀 암호화 설정",
  "대응방안": {
    "설명": "GKE는 사용자 데이터를 자동으로 암호화하지만, etcd에 저장되는 보안 비밀과 같은 민감한 정보에 대해 추가적인 암호화를 제공합니다. 이는 Cloud KMS를 사용하여 이루어지며, 해당 설정은 데이터의 무단 접근으로부터 보호하는 데 중요합니다.",
    "설정방법": [
      "Cloud KMS 키 생성",
      "GKE 서비스 계정에 KMS 키 사용 권한 부여",
      "Kubernetes Engine에서 애플리케이션 레이어 암호화 설정",
      "설정된 암호화의 적용 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your GCP Project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Enable Kubernetes Engine and KMS API
gcloud services enable container.googleapis.com cloudkms.googleapis.com

# Function to manage application-layer secret encryption in GKE
manage_app_layer_encryption() {
  # Create a KMS key ring and key if not already created
  KEY_RING="gke-key-ring"
  KEY_NAME="gke-app-layer-key"
  LOCATION="global"  # Or the specific region where your cluster resides

  echo "Creating KMS Key Ring and Key for GKE secrets:"
  gcloud kms keyrings create $KEY_RING --location $LOCATION --quiet
  gcloud kms keys create $KEY_NAME --location $LOCATION --keyring $KEY_RING --purpose "encryption" --quiet

  # Assuming you have the cluster name, set it here
  CLUSTER_NAME="your-cluster-name"
  ZONE="your-cluster-zone"

  # Grant the GKE service account access to the KMS key
  SA_EMAIL=$(gcloud container clusters describe $CLUSTER_NAME --zone $ZONE --format='value(nodeConfig.serviceAccount)')
  gcloud kms keys add-iam-policy-binding $KEY_NAME --location $LOCATION --keyring $KEY_RING --member serviceAccount:$SA_EMAIL --role roles/cloudkms.cryptoKeyEncrypterDecrypter

  # Enable application-layer encryption using the created key
  echo "Enabling application-layer encryption for cluster $CLUSTER_NAME:"
  gcloud container clusters update $CLUSTER_NAME --zone $ZONE --database-encryption-key projects/$PROJECT_ID/locations/$LOCATION/keyRings/$KEY_RING/cryptoKeys/$KEY_NAME

  # Verify settings
  echo "Verifying the encryption settings:"
  gcloud container clusters describe $CLUSTER_NAME --zone $ZONE --format="value(databaseEncryption)"
}

# Call the function to manage encryption
manage_app_layer_encryption
