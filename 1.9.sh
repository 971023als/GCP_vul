#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.9",
  "위험도": "중요도 중",
  "진단_항목": "MFA (Multi-Factor Authentication) 설정",
  "대응방안": {
    "설명": "GCP는 계정 보안을 강화하기 위해 MFA를 사용합니다. 사용자가 계정에 접근하기 위해서는 비밀번호와 함께 추가 인증 수단을 제공해야 합니다. MFA 방식에는 Google 메시지, 보안 키, OTP 앱, SMS/전화 인증, 백업 코드 등이 있습니다. 각 사용자는 자신에게 적합한 인증 수단을 선택하여 설정할 수 있습니다.",
    "설정방법": [
      "Google 계정으로 로그인 후 보안 설정으로 이동",
      "2단계 인증 탭에서 MFA 설정",
      "선택한 인증 수단으로 휴대전화를 설정",
      "인증 번호를 입력하여 인증 수단을 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}

# Google Cloud SDK 초기화 및 인증
if ! command -v gcloud &> /dev/null
then
    echo "gcloud가 설치되어 있지 않습니다. Google Cloud SDK를 설치하세요."
    exit 1
fi

echo "Google Cloud에 로그인합니다..."
gcloud auth login

# 프로젝트 설정
echo "작업할 Google Cloud 프로젝트 ID를 입력하세요:"
read project_id
gcloud config set project $project_id

# 사용자 인증 상태 확인
echo "현재 MFA 상태를 확인합니다..."
users=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")

for user in $users
do
  echo "확인 중: $user"
  mfa_status=$(gcloud beta identity groups memberships check-access --member=$user --role="roles/mfa.enforced" --format="value(state)")
  echo "MFA 상태: $mfa_status"
done

# MFA 설정 권장 안내
echo "모든 사용자에게 MFA 설정을 권장합니다. Google 계정 보안 설정을 확인하세요."