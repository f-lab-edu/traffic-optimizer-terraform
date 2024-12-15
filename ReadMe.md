# Terraform Project for Traffic Optimizer

이 Terraform 프로젝트는 네이버 클라우드 플랫폼(Naver Cloud Platform)에서 쿠버네티스 클러스터를 배포하고 관리하기 위한 인프라를 구성 및 관리하도록 설계되었습니다.

---

## 주요 기능

- **기능 1:** VPC 및 서브넷 설정
- **기능 2:** 네이버 클라우드 쿠버네티스(NKS) 클러스터 설정
---

## 사전 요구사항

시작하기 전에 아래 항목이 설치되어 있는지 확인하세요:

- **Terraform** (버전: >= 3.2.0)
- 네이버 클라우드 플랫폼(NCP) 접근 API key

---

### 인증 정보 설정

1. 클라우드 제공자를 위한 API 키 또는 인증 정보를 준비하세요.
2. 환경 변수로 설정하거나 안전한 위치에 저장하세요:
   ```bash
   export NAVER_CLOUD_ACCESS_KEY="<your-access-key>"
   export NAVER_CLOUD_SECRET_KEY="<your-secret-key>"
   ```
---

## 단계별 사용법
### 1. 프로젝트 초기화
- Terraform 프로젝트를 초기화하려면 다음 명령어를 실행하세요:
   ```bash
   terraform init 
   ```

### 2. 인프라 계획 확인

구성된 인프라 변경 사항을 미리 확인하려면 다음 명령어를 실행하세요:
   ```bash
   terraform plan
   ```

### 3. 변경 사항 적용
계획된 인프라 변경 사항을 실제로 적용하려면 다음 명령어를 실행하세요:
   ```bash
   terraform apply
   ```


### 4. 인프라 삭제
프로비저닝된 리소스를 정리하고 삭제하려면 다음 명령어를 실행하세요:
   ```bash
   terraform destroy
   ```

---
## 프로젝트 구조
| 파일            | 설명                                |
|---------------|:------------------------------------|
| main.tf:      | 주요 인프라 구성 파일.                   |
| provider.tf:  | 프로바이더 설정  (Naver Cloud Platform).|
| vpc.tf:       | vpc 구성                             |
| nks.tf:       | nks 구성                             |
