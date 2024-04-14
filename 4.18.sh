#!/bin/bash

{
  "분류": "운영 관리",
  "코드": "4.18",
  "위험도": "중요도 중",
  "진단_항목": "백업 사용 여부",
  "대응방안": {
    "설명": "클라우드 리소스에 대한 백업 정책을 구축하여 데이터 손실 위험을 감소시키고, 시스템 장애 또는 재해 발생 시 빠른 복구를 지원합니다. 이는 데이터의 무결성 및 가용성을 보장하는 핵심 요소입니다.",
    "설정방법": [
      "클라우드 리소스에 대한 백업 및 복구 절차 수립",
      "백업 대상, 주기 및 보존 기간 정의",
      "백업 담당자 및 책임자 지정",
      "백업 방법 및 절차 정립",
      "백업 이력 관리 및 백업 매체의 물리적, 지역적 보안 고려"
    ]
  },
  "현황": [],
  "진단_결과": "양호"
}


# Set your GCP Project ID
PROJECT_ID="your-project-id"
gcloud config set project $PROJECT_ID

# Enable necessary APIs
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com

# Function to create snapshot schedules for Compute Engine VMs
create_snapshot_schedule() {
  gcloud compute resource-policies create snapshot-schedule "vm-snapshot-policy" \
    --region "your-region" \
    --description "Daily snapshots" \
    --max-retention-days "30" \
    --start-time "04:00" \
    --daily-schedule
}

# Function to configure backup for Cloud SQL instances
configure_sql_backup() {
  gcloud sql instances patch "your-sql-instance-id" \
    --backup-start-time "05:00" \
    --enable-bin-log
}

# Run the functions to set up backups
create_snapshot_schedule
configure_sql_backup

echo "Backup configurations have been set up."
