#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.12",
  "위험도": "중요도 상",
  "진단_항목": "GKE 불필요한 익명 접근 관리",
  "대응방안": {
    "설명": "쿠버네티스 클러스터 내에서 익명 사용자의 접근을 비활성화해야 합니다. 기본 제공 사용자 'system:anonymous'에 대한 액세스를 제한하고, 필요한 경우에만 'system:public-info-viewer' 권한을 제외하고 익명 액세스를 허용해야 합니다. 익명 사용자에게 주어진 권한을 철저히 검토하고, 필요한 경우 승인을 받아 API 접근을 허용합니다.",
    "설정방법": [
      "kubectl을 사용하여 'system:anonymous'와 'system:unauthenticated' 사용자에게 할당된 권한을 확인",
      "불필요한 익명 접근 권한이 있다면 즉시 삭제",
      "ClusterRole에서 'system:anonymous'와 'system:unauthenticated' 그룹이 바인딩되지 않도록 설정"
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

# GKE 클러스터의 설정 가져오기
echo "GKE 클러스터의 이름을 입력하세요:"
read cluster_name
gcloud container clusters get-credentials $cluster_name

# 익명 접근을 확인 및 제거
echo "익명 접근을 확인하고 있습니다..."
kubectl get clusterrolebinding,rolebinding -o json | jq '.items[] | select(.subjects[]? | select(.name=="system:anonymous" or .name=="system:unauthenticated")) | .metadata.name'

# 익명 접근 제거
echo "익명 접근을 제거하려면 'yes'를 입력하세요 (yes/no):"
read remove_anon_access
if [[ $remove_anon_access == "yes" ]]; then
    kubectl get clusterrolebinding,rolebinding -o json | jq -r '.items[] | select(.subjects[]? | select(.name=="system:anonymous" or .name=="system:unauthenticated")) | .metadata.name' | xargs kubectl delete clusterrolebinding,rolebinding
    echo "익명 접근 권한이 제거되었습니다."
else
    echo "익명 접근 제거 작업이 취소되었습니다."
fi
