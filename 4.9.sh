#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.9",
  "위험도": "중요도 중",
  "진단_항목": "통신 구간 암호화 설정",
  "대응방안": {
    "설명": "클라우드 리소스를 이용해 데이터를 송수신할 때 중간에서 공격자에 의해 정보가 가로채지 않도록 통신 구간을 암호화해야 합니다. 이는 중요 정보의 안전한 전송을 보장하고 데이터 유출 위험을 최소화합니다.",
    "설정방법": [
      "중요 정보 전송 시 이동 구간 암호화: VPN, SSH 등을 사용한 서버 원격 접근",
      "응용 프로그램과 클라이언트 간 전송에는 SSL 방식 사용",
      "DBMS와 연결하는 데이터 전송에는 SSL 방식 또는 SSH 방식 사용",
      "운영체제 수준에서의 디스크 암호화",
      "문서 및 보조 저장 매체에 대한 암호화 적용"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Enabling SSL on a Cloud SQL instance
INSTANCE_ID="your-instance-id"
echo "Configuring SSL for Cloud SQL instance..."

# List current SSL certs for the instance
echo "Existing SSL certs:"
gcloud sql ssl-certs list --instance $INSTANCE_ID

# Create a new SSL cert
CERT_NAME="new-ssl-cert"
gcloud sql ssl-certs create $CERT_NAME $CERT_NAME.pem --instance=$INSTANCE_ID

# Retrieve and configure the instance to only allow SSL connections
gcloud sql instances patch $INSTANCE_ID --require-ssl

echo "SSL configuration has been applied. New cert details:"
gcloud sql ssl-certs describe $CERT_NAME --instance=$INSTANCE_ID

echo "Make sure to configure your database clients to use SSL with the provided cert."
