terraform {
  required_providers {
    ncloud = {
      source  = "NaverCloudPlatform/ncloud"
      version = "~> 3.2"
    }
  }
}

provider "ncloud" {
  access_key   = "your-access-key"
  secret_key   = "your-secret-key"
  region       = "KR"
  site         = "public"
  support_vpc  = true
}
