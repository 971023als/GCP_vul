#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.11",
  "위험도": "중요도 중",
  "진단_항목": "GKE 서비스 어카운트 관리",
  "대응방안": {
    "설명": "GKE에서 서비스 어카운트는 파드에 쿠버네티스 RBAC 역할을 할당할 수 있는 특수 유형의 개체입니다. 네임스페이스 별로 기본 서비스 어카운트가 자동 생성되며, 파드에 JWT 토큰이 자동으로 마운트됩니다. 애플리케이션이 Kubernetes API 호출이 필요 없는 경우, automountServiceAccountToken을 false로 설정하여 자동 마운트를 비활성화해야 합니다.",
    "설정방법": [
      "kubectl 명령어를 사용하여 서비스 어카운트의 automountServiceAccountToken 설정 확인",
      "특정 서비스 어카운트 또는 네임스페이스의 기본 서비스 어카운트에서 토큰 자동 마운트를 비활성화",
      "설정 변경 후 Kubernetes API 접근이 필요한 파드에서 수동으로 토큰을 관리"
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

# GKE 클러스터와 서비스 어카운트 설정 확인
echo "GKE 클러스터의 이름을 입력하세요:"
read cluster_name
gcloud container clusters get-credentials $cluster_name

# 서비스 어카운트의 자동 토큰 마운트 설정 확인 및 변경
echo "자동 토큰 마운트 설정을 확인하고 변경할 네임스페이스 이름을 입력하세요:"
read namespace
echo "현재 설정 확인:"
kubectl get serviceaccount default -n $namespace -o jsonpath='{.automountServiceAccountToken}'

# 설정 변경
echo "automountServiceAccountToken을 비활성화하시겠습니까? (yes/no)"
read response
if [[ $response == "yes" ]]; then
    kubectl patch serviceaccount default -p '{"automountServiceAccountToken":false}' -n $namespace
    echo "서비스 어카운트의 토큰 자동 마운트가 비활성화되었습니다."
else
    echo "설정 변경을 취소하였습니다."
fi
