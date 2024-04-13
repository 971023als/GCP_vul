#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.8",
  "위험도": "중요도 상",
  "진단_항목": "SQL 계정 관리",
  "대응방안": {
    "설명": "Cloud SQL은 Google Cloud에서 관리되는 관계형 데이터베이스 서비스로, MySQL과 PostgreSQL을 지원합니다. 이 서비스는 데이터베이스 인스턴스의 보안을 강화하기 위해 루트 비밀번호 설정과 비공개 서비스 액세스 구성을 요구합니다. 이를 통해 승인되지 않은 접근으로부터 데이터베이스를 보호할 수 있습니다.",
    "설정방법": [
      "Cloud SQL 인스턴스에 루트 패스워드 설정",
      "인스턴스 생성 시 데이터베이스 엔진 선택 및 비밀번호 정책 설정",
      "비공개 IP를 사용하여 비공개 서비스 액세스 구성",
      "패스워드 설정이 포함된 루트 계정을 통한 인스턴스 접근 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}

# Google Cloud SDK 확인 및 초기화
if ! command -v gcloud &> /dev/null
then
    echo "gcloud가 설치되어 있지 않습니다. Google Cloud SDK를 설치하세요."
    exit 1
fi

# 사용자 인증
echo "Google Cloud 사용자 인증을 시작합니다..."
gcloud auth login

# 프로젝트 설정
echo "작업할 Google Cloud 프로젝트 ID를 입력하세요:"
read project_id
gcloud config set project $project_id

# Cloud SQL 인스턴스 생성 및 구성
echo "새로운 Cloud SQL 인스턴스를 생성합니다."
echo "인스턴스 ID를 입력하세요:"
read instance_id
echo "데이터베이스 유형을 선택하세요 (mysql, postgresql):"
read db_type
echo "루트 패스워드를 입력하세요 (복잡도 요구 사항을 충족해야 함):"
read root_password

# Cloud SQL 인스턴스 생성
gcloud sql instances create $instance_id --database-version=$db_type --root-password=$root_password --region=us-central1

echo "Cloud SQL 인스턴스가 생성되었습니다."

# 비공개 서비스 액세스 활성화
echo "비공개 서비스 액세스를 구성합니다."
gcloud services vpc-peerings connect --service=servicenetworking.googleapis.com --ranges=my-range --network=default --project=$project_id

echo "비공개 서비스 액세스가 구성되었습니다."

# 인스턴스 정보 확인
echo "생성된 Cloud SQL 인스턴스 정보:"
gcloud sql instances describe $instance_id

# 스크립트 완료 메시지
echo "Cloud SQL 인스턴스 관리 스크립트 실행 완료."
