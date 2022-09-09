module "networking" {
  source              = "./networking"
  public_sn_count     = var.public_sn_count
  private_subnet_cidr = [for i in range(1, 255, 2) : cidrsubnet(var.cidr_block, 8, i)]
  public_subnet_cidr  = [for i in range(2, 255, 2) : cidrsubnet(var.cidr_block, 8, i)]
  security_groups     = local.security_groups
  private_sn_count    = var.private_sn_count
  cidr_block          = var.cidr_block
}

module "compute" {
  source = "./compute"

  instance_count  = 1
  instance_type   = "t2.micro"
  public_sg       = [module.networking.public_sg,module.networking.ssh_sg, module.networking.prom_sg]
  public_subnet   = module.networking.public_subnet
  vol_size        = 8
  public_key_path = "prom_server_rsa.pub"
  key_name        = "prom_server_rsa"

}