locals {
  security_groups = {
    ssh = {
      name        = "ssh_sg"
      description = "ssh access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}