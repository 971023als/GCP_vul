#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.19",
  "위험도": "중요도 중",
  "진단_항목": "보안 GKE 노드 설정",
  "대응방안": {
    "설명": "GKE 노드는 고도의 보안 설정을 필요로 합니다. 이는 Compute Engine 보안 VM을 기반으로 구축되며, 적절한 보안 조치가 없으면 Pod의 취약점을 통해 중요 인증 정보가 유출될 위험이 있습니다. GKE 버전 1.13.6-gke.0 이상에서 보안 노드를 활성화할 수 있으며, Autopilot 클러스터의 경우 기본적으로 활성화되어 있습니다.",
    "설정방법": [
      "GKE 클러스터에서 보안 노드 설정 확인",
      "필요한 경우 보안 노드 활성화",
      "클러스터 업데이트 및 보안 설정 적용",
      "보안 설정이 정상적으로 적용되었는지 검증"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your GCP Project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Enable Kubernetes Engine API
gcloud services enable container.googleapis.com

# Function to check and enable security features on GKE nodes
enable_security_on_gke_nodes() {
  # List all clusters
  echo "Listing all GKE clusters in the project:"
  gcloud container clusters list

  # Assuming you have the cluster name, set it here
  CLUSTER_NAME="your-cluster-name"
  ZONE="your-cluster-zone"

  # Get the current setting of the security features
  echo "Checking security settings for the cluster ${CLUSTER_NAME}:"
  gcloud container clusters describe ${CLUSTER_NAME} --zone ${ZONE} --format="value(shieldedNodes.enabled)"

  # Enable Shielded GKE Nodes if not already enabled
  echo "Enabling Shielded GKE Nodes for ${CLUSTER_NAME}:"
  gcloud container clusters update ${CLUSTER_NAME} --zone ${ZONE} --enable-shielded-nodes

  # Verify settings
  echo "Verifying the security settings are now enabled:"
  gcloud container clusters describe ${CLUSTER_NAME} --zone ${ZONE} --format="value(shieldedNodes.enabled)"
}

# Call the function to enable security on GKE nodes
enable_security_on_gke_nodes
