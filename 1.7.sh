#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.7",
  "위험도": "중요도 상",
  "진단_항목": "메타데이터 관리",
  "대응방안": {
    "설명": "VM(가상 머신) 인스턴스는 메타데이터 서버에 주요 정보를 저장합니다. 이 메타데이터는 key:value 형태로 저장되며, VM은 승인 없이도 메타데이터 서버 API에 접근할 수 있습니다. 이는 메타데이터 서버에 저장된 민감하거나 중요한 정보를 보호해야 하는 필요성을 증가시킵니다.",
    "설정방법": [
      "커스텀 메타데이터를 VM 인스턴스에 추가",
      "GCP 콘솔이나 CLI를 통해 메타데이터를 등록하고 저장",
      "메타데이터가 VM 인스턴스에 적용되었는지 확인",
      "VM 인스턴스의 중지 및 시작을 통해 메타데이터 값 적용 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Google Cloud SDK가 설치되어 있는지 확인
if ! command -v gcloud &> /dev/null
then
    echo "gcloud가 설치되어 있지 않습니다. Google Cloud SDK를 설치하세요."
    exit 1
fi

# 사용자 인증 및 GCP 환경 초기화
echo "Google Cloud 사용자 인증 중..."
gcloud auth login

# 프로젝트 설정
echo "Google Cloud 프로젝트 ID를 입력하세요:"
read project_id
gcloud config set project $project_id

# 모든 Compute Engine 인스턴스 목록 표시
echo "모든 Compute Engine 인스턴스를 나열합니다..."
gcloud compute instances list

# 메타데이터 조회 스크립트
echo "메타데이터를 확인할 인스턴스 이름을 입력하세요:"
read instance_name
echo "인스턴스의 존(zone)을 입력하세요:"
read zone

# 메타데이터 조회
echo "메타데이터 조회를 시도합니다..."
gcloud compute instances describe $instance_name --zone $zone --format='value(metadata.items)'

# 메타데이터 추가 또는 수정
echo "추가하거나 수정할 메타데이터의 키를 입력하세요:"
read metadata_key
echo "메타데이터 값 입력:"
read metadata_value

# 메타데이터 설정
gcloud compute instances add-metadata $instance_name --zone $zone --metadata $metadata_key=$metadata_value

# 완료 메시지
echo "메타데이터 관리 스크립트가 설정되었으며 사용 준비가 완료되었습니다."
