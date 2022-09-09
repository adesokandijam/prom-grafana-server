locals {
  security_groups = {
    ssh = {
      name        = "public_sg"
      description = "public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
    public = {
      name        = "public_sg"
      description = "public access"
      ingress = {
        ssh = {
          from        = 3000
          to          = 3000
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}