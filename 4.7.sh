#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.7",
  "위험도": "중요도 상",
  "진단_항목": "Load Balancing SSL 정책 관리",
  "대응방안": {
    "설명": "Compute Engine 내 SSL 설정을 통해 로드 밸런서가 클라이언트와 SSL을 협상하는 방식을 제어하며, SSL/TLS 버전 및 암호화의 세밀한 제어를 위해 정책을 만들고 이를 HTTPS 및 SSL 부하 분산기에 적용합니다. 이는 데이터 전송의 보안을 강화합니다.",
    "설정방법": [
      "부하 분산기 생성 및 공개 IP 설정",
      "HTTPS 및 SSL 프록시 부하 분산 설정",
      "Google 관리형 SSL 인증서 생성 및 적용",
      "SSL 연결만 허용 옵션 활성화",
      "SSL 인증서 상태 확인 및 로그 기록"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

echo "Creating a managed SSL certificate..."
# Create a managed SSL certificate
gcloud compute ssl-certificates create my-ssl-cert --domains "your-domain.com"

echo "Creating target HTTP proxy..."
# Create a target HTTPS proxy to use the SSL certificate
gcloud compute target-https-proxies create https-lb-proxy --ssl-certificates=my-ssl-cert --url-map=your-url-map

echo "Creating global forwarding rule..."
# Create a global forwarding rule
gcloud compute forwarding-rules create https-content-rule --address=your-reserved-ip --global \
  --target-https-proxy=https-lb-proxy --ports=443

echo "SSL configuration for load balancing is now complete."
