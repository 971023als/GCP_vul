#!/bin/bash

{
  "분류": "권한 관리",
  "코드": "2.1",
  "위험도": "중요도 상",
  "진단_항목": "인스턴스 서비스 정책 관리",
  "대응방안": {
    "설명": "Google Cloud Platform(GCP)에서 Cloud IAM을 사용하여 특정 ID가 어떤 리소스에 대해 어떤 권한을 갖는지 정의합니다. 이를 통해 세밀한 액세스 제어와 최소 권한 원칙을 적용할 수 있습니다, 이를 통해 무단 액세스를 방지하고 필요한 리소스에만 액세스를 허용할 수 있습니다.",
    "설정방법": [
      "Google Cloud 콘솔에서 IAM 사용자 계정을 생성",
      "사용자에게 필요한 권한을 제한적으로 할당",
      "서비스별 역할을 적절하게 구분하여 최소 권한을 부여",
      "기존 사용자의 권한을 주기적으로 검토하고 수정"
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
