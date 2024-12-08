#vpc.tf
terraform {
  required_providers {
    ncloud = {
      source  = "NaverCloudPlatform/ncloud"
      version = "~> 3.2"  # 버전은 프로젝트에 맞게 조정
    }
  }
}

output "vpc_id" {
  value = ncloud_vpc.main.id
}

output "public_subnet_id" {
  value = ncloud_subnet.public.id
}

output "private_subnet_id" {
  value = ncloud_subnet.private.id
}

output "lb_public_subnet_id" {
  value = ncloud_subnet.public_lb.id
}

output "lb_private_subnet_id" {
  value = ncloud_subnet.private_lb.id
}

output "zone" {
  value = ncloud_subnet.public.zone
}


# Resource : VPC
resource "ncloud_vpc" "main" {
  name            = "vpc-tf"
  ipv4_cidr_block = "10.0.0.0/16"
}

# Public Subnet
resource "ncloud_subnet" "public" {
  name           = "sbn-tf-public"
  network_acl_no = "119578"
  subnet         = "10.0.0.0/24"
  subnet_type = "PUBLIC"  # PUBLIC 서브넷으로 지정
  vpc_no         = ncloud_vpc.main.id
  zone           = "KR-1"
  usage_type     = "GEN"
}

# Private Subnet
resource "ncloud_subnet" "private" {
  name           = "sbn-tf-private"
  network_acl_no = "119578"
  subnet         = "10.0.1.0/24"
  subnet_type = "PRIVATE"  # PRIVATE 서브넷으로 지정
  vpc_no         = ncloud_vpc.main.id
  zone           = "KR-1"
}

# 퍼블릭 로드밸런서 전용 서브넷
resource "ncloud_subnet" "public_lb" {
  name           = "sbn-lb-tf-public"
  network_acl_no = "119578"
  subnet         = "10.0.2.0/24"
  subnet_type    = "PUBLIC"
  vpc_no         = ncloud_vpc.main.id
  zone           = "KR-1"
  usage_type     = "LOADB"
}

# 프라이빗 로드밸런서 전용 서브넷
resource "ncloud_subnet" "private_lb" {
  name           = "sbn-lb-tf-private"
  network_acl_no = "119578"
  subnet         = "10.0.3.0/24"
  subnet_type    = "PRIVATE"
  vpc_no         = ncloud_vpc.main.id
  zone           = "KR-1"
  usage_type     = "LOADB"
}

resource "ncloud_subnet" "nat_subnet" {
  vpc_no         = ncloud_vpc.main.id
  subnet         = "10.0.4.0/24"
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.main.default_network_acl_no
  subnet_type    = "PUBLIC"
  name           = "nat-gateway-subnet"
  usage_type     = "NATGW"
}

# NAT Gateway
resource "ncloud_nat_gateway" "nat_gateway" {
  description = "nat-gateway"
  name        = "nat-gw-tf"
  vpc_no      = ncloud_vpc.main.id
  zone        = "KR-1"
  subnet_no   = ncloud_subnet.nat_subnet.id  # PUBLIC 서브넷을 참조
}

#Resource : Public Route Table & Association
resource "ncloud_route_table" "route_table_public" {
  description           = "Public Route Table with Terraform"
  name                  = "tf-rt-public"
  supported_subnet_type = "PUBLIC"
  vpc_no                = ncloud_vpc.main.id
}

#Resource : Private Route Table & Association
resource "ncloud_route_table" "route_table_private" {
  description           = "Private Route Table with Terraform"
  name                  = "tf-rt-private"
  supported_subnet_type = "PRIVATE"
  vpc_no                = ncloud_vpc.main.id
}
# Route Table & Association
resource "ncloud_route_table_association" "rt_subnet_association_public" {
  route_table_no = ncloud_route_table.route_table_public.route_table_no
  subnet_no      = ncloud_subnet.public.id  # PUBLIC 서브넷과 연결
}

resource "ncloud_route_table_association" "rt_subnet_association_private" {
  route_table_no = ncloud_route_table.route_table_private.route_table_no
  subnet_no      = ncloud_subnet.private.id  # PRIVATE 서브넷과 연결
}
