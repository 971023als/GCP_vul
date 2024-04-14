#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.6",
  "위험도": "중요도 중",
  "진단_항목": "SQL SSL 정책 관리",
  "대응방안": {
    "설명": "Cloud SQL은 완전 관리형 데이터베이스 서비스로, SSL 설정을 통해 데이터베이스 서비스의 데이터 전송 시 보안을 강화합니다. 공개 IP 사용 시 SSL 인증서를 통한 연결을 구성하여 데이터 노출 위험을 줄입니다.",
    "설정방법": [
      "SQL 인스턴스에 공개 IP 또는 비공개 IP 설정",
      "SSL 인증서 생성 및 적용",
      "클라이언트 인증서를 통한 SSL 연결 설정",
      "SSL 연결만 허용 옵션 활성화",
      "웹 서비스를 통한 안전한 로그인 구현"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID and Cloud SQL instance ID
PROJECT_ID="your-project-id"
INSTANCE_ID="your-instance-id"
gcloud config set project $PROJECT_ID

echo "Generating SSL certificates for the Cloud SQL instance..."
# Create a new SSL certificate
gcloud sql ssl-certs create client-cert --instance=$INSTANCE_ID --common-name="client-cert"

# Retrieve the newly created certificate details
CERT_DETAILS=$(gcloud sql ssl-certs describe client-cert --instance=$INSTANCE_ID)
CERT_PATH=$(echo $CERT_DETAILS | grep 'certPath' | awk '{print $2}')
PRIVATE_KEY_PATH=$(echo $CERT_DETAILS | grep 'certPrivateKey' | awk '{print $2}')

echo "Certificate and private key paths:"
echo "Cert Path: $CERT_PATH"
echo "Private Key Path: $PRIVATE_KEY_PATH"

# Enforce SSL connections on the SQL instance
echo "Configuring the SQL instance to allow only SSL connections..."
gcloud sql instances patch $INSTANCE_ID --require-ssl

echo "SSL configuration completed. Only SSL connections are now allowed to the instance."
