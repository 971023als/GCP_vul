#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.10",
  "위험도": "중요도 상",
  "진단_항목": "GKE 사용자 관리",
  "대응방안": {
    "설명": "GCP에서 GKE 클러스터 접근을 통제하기 위해 Kubernetes RBAC 설정을 활용하여 세분화된 권한을 부여합니다. IAM은 프로젝트 수준에서 작동하며, RBAC은 클러스터 및 네임스페이스 수준에서 접근 제어를 제공합니다. 적절한 접근 권한 관리를 통해 리소스에 대한 최소 권한을 부여해야 합니다.",
    "설정방법": [
      "IAM 사용자 역할 확인 및 접근 권한 설정",
      "ClusterRole 및 ClusterRoleBinding을 생성하여 GKE 리소스에 대한 접근을 허용",
      "접근 권한이 부여되지 않은 계정의 접근 시도 확인",
      "RBAC 적용 유무 및 효과적인 관리를 통한 리소스 보안 유지"
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

# GKE 클러스터와 RBAC 설정 확인
echo "GKE 클러스터의 이름을 입력하세요:"
read cluster_name
gcloud container clusters get-credentials $cluster_name

# RBAC 권한 확인
echo "현재 RBAC 설정을 확인합니다..."
kubectl get clusterroles
kubectl get clusterrolebindings

# 특정 사용자의 권한 확인
echo "권한을 확인할 사용자 이메일을 입력하세요:"
read user_email
echo "사용자의 ClusterRoleBindings:"
kubectl get clusterrolebindings -o json | jq -r '.items[] | select(.subjects[]? | .kind == "User" and .name == "'$user_email'")'

# 사용자 권한 추가 또는 수정
echo "사용자에게 권한을 추가하거나 수정할 필요가 있습니까? (yes/no)"
read modify_permission
if [[ $modify_permission == "yes" ]]; then
    echo "수행할 작업을 선택하세요: (1) 권한 추가, (2) 권한 수정"
    read action
    case $action in
        1)
            echo "추가할 ClusterRole의 이름을 입력하세요:"
            read role_name
            kubectl create clusterrolebinding custom-role-binding --clusterrole=$role_name --user=$user_email
            ;;
        2)
            echo "수정할 ClusterRoleBinding의 이름을 입력하세요:"
            read binding_name
            kubectl edit clusterrolebinding $binding_name
            ;;
        *)
            echo "잘못된 입력입니다."
            ;;
    esac
fi

echo "작업 완료."
