#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.8",
  "위험도": "중요도 상",
  "진단_항목": "App Engine SSL 정책 관리",
  "대응방안": {
    "설명": "App Engine은 전 세계 SSL 엔드포인트를 통해 높은 수준의 SSL 지원을 제공합니다. 기본적으로 HTTPS 로드 균형 조정과 SSL 프록시 로드 균형 조정을 사용하여 보안과 호환성을 보장합니다. App Engine에서 SSL 정책을 정의하여 SSL 기능을 제어할 수 있습니다.",
    "설정방법": [
      "App Engine 대시보드에서 SSL 인증서 확인",
      "App Engine에 커스텀 도메인 추가 및 Google 관리형 SSL 인증서 적용",
      "SSL 인증서와 Cloud DNS 설정을 통한 도메인 등록 및 관리"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

echo "Configuring App Engine with a custom domain and SSL..."
# Verify App Engine service
gcloud app describe

# Add a custom domain to App Engine
DOMAIN="your-custom-domain.com"
gcloud app domain-mappings create $DOMAIN --project=$PROJECT_ID

# Confirm domain mapping
gcloud app domain-mappings list --project=$PROJECT_ID

# Create a new DNS zone in Cloud DNS for the custom domain
DNS_NAME="app-engine-zone"
gcloud dns managed-zones create $DNS_NAME --dns-name=$DOMAIN --description="DNS zone for App Engine"

# Set DNS records for the custom domain
gcloud dns record-sets transaction start --zone=$DNS_NAME
gcloud dns record-sets transaction add --name=$DOMAIN. --type=CNAME --ttl=300 "ghs.googlehosted.com." --zone=$DNS_NAME
gcloud dns record-sets transaction execute --zone=$DNS_NAME

echo "SSL configuration for App Engine custom domain is now in progress."
echo "Please configure your domain registrar to point to the nameservers provided by Cloud DNS."
