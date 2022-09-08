locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "public access"
      ingress = {
        ssh = {
          from        = 0
          to          = 0
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}