# main.tf
module "vpc" {
  source = "../traffic-optimizer-terraform/network"

  providers = {
    ncloud = ncloud
  }
}

module "nks" {
  source = "../traffic-optimizer-terraform/nks"

  providers = {
    ncloud = ncloud
  }

  vpc_id               = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnet_id
  private_subnet_id    = module.vpc.private_subnet_id
  lb_public_subnet_id  = module.vpc.lb_public_subnet_id
  lb_private_subnet_id = module.vpc.lb_private_subnet_id
  zone                 = module.vpc.zone
  kubernetes_version   = "1.29.9"
}
