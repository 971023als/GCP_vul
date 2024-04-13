#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.1",
  "위험도": "중요도 상",
  "진단_항목": "사용자 계정 관리",
  "대응방안": {
    "설명": "GCP에서는 다양한 유형의 계정을 사용하여 인증과 허가를 관리합니다. 이들 계정에 적절한 권한 관리와 보안 설정이 중요합니다.",
    "설정방법": [
      "IAM 내 사용자 추가",
      "Google 계정 사용자 추가 (역할 부여: 소유자)",
      "신규 사용자 추가 및 Google 계정에 최고 권한(소유자) 부여 확인",
      "Google 계정 사용자 최고 권한(소유자) 획득을 위한 이메일 인증",
      "프로젝트 내 최고 권한(소유자) 인증을 위한 초대 수락 버튼 클릭",
      "추가된 신규 Google 계정 사용자 최종 권한 여부 확인"
    ]
  },
  "현황": [],
  "진단_결과": ""
}


# GCP CLI 사용을 위한 gcloud 명령어 초기화 및 설정
echo "Setting up GCP CLI and authenticating..."
gcloud init --quiet

# IAM 사용자 추가
echo "Adding IAM users..."
gcloud iam service-accounts create service-account-name \
    --description="Service account for managing project resources" \
    --display-name="Project Manager Account"

# IAM 역할 부여
echo "Assigning roles to new IAM user..."
gcloud projects add-iam-policy-binding project-id \
    --member='user:user@example.com' \
    --role='roles/owner'

# 프로젝트 내 최고 권한(소유자) 인증을 위한 초대 수락
echo "Accepting invitation for the highest privilege..."
# Note: This step typically involves manual action via email or GCP console.

# 권한 확인
echo "Checking final permissions..."
gcloud projects get-iam-policy project-id

echo "IAM configuration completed. Check JSON for detailed output."
