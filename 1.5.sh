#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.5",
  "위험도": "중요도 중",
  "진단_항목": "API 활성화 및 사용 주기 관리",
  "대응방안": {
    "설명": "Google Cloud API는 다양한 서비스에 쉽게 접근할 수 있도록 지원합니다. API 키는 프로젝트의 보안을 유지하는 데 중요한 역할을 하며, 이를 안전하게 관리하고 사용 주기를 통제해야 합니다. 키 노출로 인한 보안 침해를 방지하기 위해 API 키에 제한을 두고, 사용 주기를 설정하는 것이 필요합니다.",
    "설정방법": [
      "API 키 생성 및 관리를 위해 Google Cloud Console의 'API 및 서비스' 섹션 접근",
      "API 키 생성 후 필요한 제한사항(리퍼러, IP 주소, Android 앱, iOS 앱, 웹사이트) 설정",
      "API 키의 사용 주기를 관리하고, 주기적으로 키를 갱신하거나 필요에 따라 키를 재발급"
    ]
  },
  "현황": [],
  "진단_결과": ""
}

# Ensure the gcloud and gsutil commands are available
if ! command -v gcloud &> /dev/null || ! command -v gsutil &> /dev/null
then
    echo "gcloud or gsutil is not installed. Please install the Google Cloud SDK."
    exit 1
fi

# Authenticate and initialize the GCP environment
echo "Authenticating the user with Google Cloud..."
gcloud auth login

# Set and configure the project
echo "Please enter your Google Cloud project ID:"
read project_id
gcloud config set project $project_id

# List all APIs and services enabled on the current project
echo "Listing all enabled APIs and services..."
gcloud services list --enabled

# Creating API credentials (API key)
echo "Creating a new API key. Please specify a name for the key:"
read key_name
gcloud alpha services api-keys create --display-name "$key_name"

# List existing API keys and their details
echo "Listing all API keys..."
gcloud alpha services api-keys list

# Optional: Setting restrictions on the API key
echo "To set restrictions on the API key, please enter the key ID:"
read key_id
echo "Adding HTTP referrer restriction. Please enter the HTTP referrer:"
read http_referrer
gcloud alpha services api-keys update $key_id --add-restrictions http-referrers=$http_referrer

# Verify the API key details
echo "Verifying API key details..."
gcloud alpha services api-keys describe $key_id

# Completion message
echo "GCP CLI for managing APIs is configured and ready for use."