#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.11",
  "위험도": "중요도 중",
  "진단_항목": "감사 로그 면제 사용자 존재 여부",
  "대응방안": {
    "설명": "Cloud 감사 로그를 통해 관리자 활동, 시스템 이벤트, 데이터 액세스, 정책 거부 등의 로그를 관리할 수 있으며, 필요에 따라 특정 사용자에 대해 로그 생성을 면제할 수 있습니다. 면제 사용자 설정은 보안 요건에 따라 조정될 수 있으며, 불필요한 면제 사용자의 존재는 보안 취약점을 야기할 수 있습니다.",
    "설정방법": [
      "Google Cloud Console을 통해 면제 사용자 설정 확인 및 관리: [IAM 및 관리자] > [액세스] > [감사 로그] > [면제 사용자]",
      "불필요한 면제 사용자를 주기적으로 검토 및 제거"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set the project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Function to list exempt users for audit logs
list_exempt_users() {
  echo "Listing all exempt users in the project:"
  gcloud logging organizations exempt-users list --organization=YOUR_ORGANIZATION_ID
}

# Function to add an exempt user
add_exempt_user() {
  USER_EMAIL=$1
  echo "Adding $USER_EMAIL as an exempt user..."
  gcloud logging organizations exempt-users add --organization=YOUR_ORGANIZATION_ID --member=user:$USER_EMAIL
}

# Function to remove an exempt user
remove_exempt_user() {
  USER_EMAIL=$1
  echo "Removing $USER_EMAIL from exempt users..."
  gcloud logging organizations exempt-users remove --organization=YOUR_ORGANIZATION_ID --member=user:$USER_EMAIL
}

# Example usage
echo "Checking current exempt users..."
list_exempt_users

# Uncomment the lines below to add or remove an exempt user
# add_exempt_user "user@example.com"
# remove_exempt_user "user@example.com"
