#!/bin/bash

{
  "분류": "계정 관리",
  "코드": "1.6",
  "위험도": "중요도 상",
  "진단_항목": "SSH 키 사용 관리",
  "대응방안": {
    "설명": "SSH 키는 Linux VM 인스턴스에 안전한 접속을 제공하기 위해 필요합니다. 이 키는 고유한 개인 및 공용 키 파일로 구성되어 있으며, 특히 타사 도구를 사용하여 연결할 경우 공용 SSH 키를 인스턴스에 제공해야 합니다.",
    "설정방법": [
      "Putty-Key Generator 또는 ssh-keygen 명령어를 사용하여 RSA 키 페어 생성",
      "생성된 키 페어 파일을 안전한 저장공간에 보관",
      "GCP 또는 다른 플랫폼의 메타데이터 설정에서 공개 키 등록",
      "SSH 클라이언트(예: Putty)를 사용하여 SSH 키와 함께 VM 인스턴스에 접속 시도",
      "SSH 접근이 성공적으로 이루어진 경우 보안 접속 확인"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Ensure the gcloud and gsutil commands are available
if ! command -v gcloud &> /dev/null
then
    echo "gcloud is not installed. Please install the Google Cloud SDK."
    exit 1
fi

# Authenticate and initialize the GCP environment
echo "Authenticating the user with Google Cloud..."
gcloud auth login

# Set and configure the project
echo "Please enter your Google Cloud project ID:"
read project_id
gcloud config set project $project_id

# List all Compute Engine instances
echo "Listing all Compute Engine instances..."
gcloud compute instances list

# Generate a new SSH key pair
echo "Generating a new SSH key pair..."
ssh-keygen -t rsa -b 2048 -f ~/.ssh/gcp-ssh-key -N ""
public_key=$(cat ~/.ssh/gcp-ssh-key.pub)

# Add the SSH public key to the project's metadata
echo "Adding the SSH public key to the project's metadata..."
gcloud compute project-info add-metadata --metadata "ssh-keys=$(whoami):$public_key"

# Retrieve instance details to SSH
echo "Please enter the name of the instance you want to SSH into:"
read instance_name
echo "Please enter the zone of the instance:"
read zone

# Attempt to SSH into the instance
echo "Attempting to SSH into the instance..."
gcloud compute ssh $instance_name --zone $zone --strict-host-key-checking=no

# Completion message
echo "SSH key management and usage script is configured and ready for use."
