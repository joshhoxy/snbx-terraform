#
# 파일명 : provider.tf
#
# Terraform에서 지원하는 provider 중, AWS를 사용하겠다는 의미입니다.
provider "aws" {
region = "ap-northeast-2"
profile = "default"
# 프로파일을 사용하지 않는 경우 다음과 같이 access_key, secret_key를 기입해도 됩니다.
# access_key = ""
# secret_key = ""
}