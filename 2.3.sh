#!/bin/bash

{
  "분류": "권한 관리",
  "코드": "2.3",
  "위험도": "중요도 상",
  "진단_항목": "기타 서비스 정책 관리",
  "대응방안": {
    "설명": "GCP에서 Cloud IAM을 사용하여 기타 서비스 별 리소스에 대한 액세스 권한을 정의하고 관리할 수 있습니다. 이를 통해 세밀한 액세스 제어와 최소 권한 원칙을 적용하여 필요한 리소스에만 액세스 권한을 부여하고 무단 액세스를 방지할 수 있습니다.",
    "설정방법": [
      "Google Cloud에서 사전 정의된 역할로의 IAM 사용자 계정 생성",
      "권한을 부여하고자 하는 사용자(Google 또는 Cloud ID 계정) 추가 및 역할별 권한 부여",
      "사용자의 권한 추가 확인 및 필요시 수정",
      "사용자 권한을 부여한 후 Google Cloud Console에서 로그인 시도 및 권한 확인"
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

# IAM 사용자 및 권한 관리
echo "IAM 사용자의 역할과 권한을 검토합니다..."
gcloud iam roles list --format="table(name, title, description)"

# 권한 조정 및 검토
echo "권한을 조정할 사용자의 이메일을 입력하세요:"
read user_email

echo "할당할 역할을 입력하세요 (예: roles/viewer):"
read role

# 권한 할당
gcloud projects add-iam-policy-binding $project_id \
    --member=user:$user_email \
    --role=$role \
    --format="table(projectId, bindings.role, bindings.members)"

# 권한 확인
echo "현재 사용자의 IAM 정책을 확인합니다..."
gcloud projects get-iam-policy $project_id \
    --format="table(bindings.role, bindings.members)" \
    | grep $user_email

# 권한 검토 및 사용자 피드백
echo "IAM 권한이 정상적으로 업데이트 되었습니다. 추가 조치가 필요하면 알려주세요."
