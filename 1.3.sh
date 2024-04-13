#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.3",
  "위험도": "중요도 중",
  "진단_항목": "Cloud ID 사용자 패스워드 정책 관리",
  "대응방안": {
    "설명": "Cloud ID 사용자 계정을 통한 서비스 접근 시 강력한 패스워드 정책 적용으로 보안을 강화해야 합니다. 패스워드는 다양한 문자 유형을 조합하여 설정하고, 예측 가능한 정보를 기반으로 한 패스워드 사용을 금지합니다.",
    "설정방법": [
      "G Suite 계정의 패스워드 복잡도 설정",
      "패스워드 만료 기간 및 재사용 제한 설정",
      "비밀번호 정책의 정기적인 검토 및 업데이트",
      "사용자 교육을 통한 보안 인식 강화"
    ]
  },
  "현황": [],
  "진단_결과": ""
}


# Ensure gcloud is installed and PATH is set
if ! command -v gcloud &> /dev/null
then
    echo "gcloud could not be found, please install and retry."
    exit 1
fi

# Authenticate the user in the GCP environment
echo "Authenticating user..."
gcloud auth login --brief

# Set the project
echo "Enter your project ID:"
read project_id
gcloud config set project "$project_id"

# List all service accounts
echo "Listing all service accounts..."
gcloud iam service-accounts list

# Create a new service account
echo "Enter a new service account name:"
read service_account_name
gcloud iam service-accounts create "$service_account_name" --description "New service account for managing GCP resources."

# Assign roles to the new service account
echo "Assigning roles..."
gcloud projects add-iam-policy-binding "$project_id" --member "serviceAccount:${service_account_name}@${project_id}.iam.gserviceaccount.com" --role "roles/owner"

# Check if the service account has the expected roles
echo "Verifying roles assigned to ${service_account_name}..."
gcloud projects get-iam-policy "$project_id" --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:${service_account_name}@${project_id}.iam.gserviceaccount.com"

echo "GCP CLI setup and service account configuration complete."
