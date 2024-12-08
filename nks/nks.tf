# nks.tf
terraform {
  required_providers {
    ncloud = {
      source  = "NaverCloudPlatform/ncloud"
      version = "~> 3.2"  # 버전은 프로젝트에 맞게 조정
    }
  }
}

# # # nks.tf
# module "vpc" {
#   source = "../network/vpc.tf"
#   providers = {
#     ncloud = ncloud
#   }
#
# }

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_id" {
  type        = string
  description = "Public Subnet ID"
}

variable "private_subnet_id" {
  type        = string
  description = "Private Subnet ID"
}


variable "lb_public_subnet_id" {
  type        = string
  description = "Public Load Balancer Subnet ID"
}

variable "lb_private_subnet_id" {
  type        = string
  description = "Private Load Balancer Subnet ID"
}

variable "zone" {
  type        = string
  description = "Availability Zone"
}


# kubernetes_version 변수 선언
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29.9"
}



resource "ncloud_nks_cluster" "k8s_cluster" {
  hypervisor_code      = "KVM"
  name                 = "trf-opti-k8s"
  cluster_type         = "SVR.VNKS.STAND.C004.M016.G003"
  k8s_version          = var.kubernetes_version
  login_key_name       = ncloud_login_key.login_key.key_name
  lb_private_subnet_no = var.lb_private_subnet_id
  lb_public_subnet_no  = var.lb_public_subnet_id

  subnet_no_list = [var.public_subnet_id]
  kube_network_plugin = "cilium"
  vpc_no              = var.vpc_id
  public_network      = true
  zone                = var.zone
}

output "image_id" {
  value = data.ncloud_nks_server_images.image.images
}

output "k8s_version" {
  value = [for v in data.ncloud_nks_versions.version : v]
}


resource "ncloud_nks_node_pool" "node_pool" {
  cluster_uuid     = ncloud_nks_cluster.k8s_cluster.id
  node_pool_name   = "prd-trf-opti-node"
  node_count       = 1
  software_code = data.ncloud_nks_server_images.image.images[0].value
  # 서버 사양 코드를 직접 출력하여 확인 후 설정
#   server_spec_code = data.ncloud_nks_server_products.product.products
  storage_size     = 100  # Storage size specified in GB
  autoscale {
    enabled = false
    min     = 1
    max     = 2
  }
}


resource "ncloud_login_key" "login_key" {
  key_name = "ncp-server-access-key"
}


data "ncloud_nks_versions" "version" {
  hypervisor_code = "KVM"
  filter {
    name  = "value"
    values = ["1.29.9"]
    regex = true
  }
}

data "ncloud_nks_server_images" "image" {
  hypervisor_code = "KVM"
  filter {
    name  = "label"
    values = ["ubuntu-22.04"]
    regex = true
  }
}

# 필터 조건을 완화하여 제품 목록을 확인
data "ncloud_nks_server_products" "product" {
  software_code = data.ncloud_nks_server_images.image.images[0].value
  zone          = var.zone

  # 필터를 최소화하여 제품 목록을 더 많이 조회
  filter {
    name = "label"
    values = ["STAND"]
  }
}
