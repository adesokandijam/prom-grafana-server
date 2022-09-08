module "networking" {
  source = "./networking"
  public_sn_count = var.public_sn_count
  private_subnet_cidr = [for i in range(1, 255, 2) : cidrsubnet(var.cidr_block, 8, i)]
  public_subnet_cidr = [for i in range(2, 255, 2) : cidrsubnet(var.cidr_block, 8, i)]
  security_groups = local.security_groups
  private_sn_count = var.private_sn_count
  cidr_block = var.cidr_block
}