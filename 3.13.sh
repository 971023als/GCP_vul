#!/bin/bash

{
  "분류": "가상 리소스 관리",
  "코드": "3.13",
  "위험도": "중요도 상",
  "진단_항목": "GKE Pod 보안 정책 관리",
  "대응방안": {
    "설명": "GKE 클러스터에서 PodSecurity 표준을 적용하여 포드 보안을 관리합니다. 이는 Kubernetes 포드의 보안 구성을 검사하여 규칙을 준수하지 않는 포드를 거부할 수 있는 기능을 제공합니다.",
    "설정방법": [
      "네임스페이스 내 PSS/PSA 설정 및 확인: 네임스페이스 생성 후 PSS/PSA 적용, 네임스페이스 라벨에 PSS/PSA 적용 (enforce=restricted), 네임스페이스 내 파드 생성 시도를 통한 PSS/PSA 적용 확인 (파드 생성 실패), 로그 탐색기 내 PSS/PSA 적용 로그 확인 (파드 생성 실패)"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set Google Cloud project and GKE cluster
PROJECT_ID="your-project-id"
CLUSTER_NAME="your-cluster-name"
gcloud config set project $PROJECT_ID
gcloud container clusters get-credentials $CLUSTER_NAME

# Create a new namespace for applying PSS and PSA
echo "Creating namespace with PSS and PSA settings..."
kubectl create namespace secure-namespace
kubectl label namespace secure-namespace pod-security.kubernetes.io/enforce=restricted

# Apply a Pod Security Policy that enforces restrictions
echo "Applying Pod Security Admission..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: secure-namespace
  labels:
    pod-security.kubernetes.io/enforce: restricted
EOF

# Try creating a Pod to test the security settings
echo "Testing Pod creation under enforced security settings..."
cat <<EOF | kubectl apply -f - || echo "Pod creation failed as expected due to security settings."
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: secure-namespace
spec:
  containers:
  - name: test-container
    image: nginx
EOF

# Output current Pod Security Admission settings
echo "Current Pod Security Admission settings:"
kubectl get pods -n secure-namespace
