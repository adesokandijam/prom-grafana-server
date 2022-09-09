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
    prom = {
      name        = "prom_access"
      description = "prom_to_pull_metrics"
      ingress = {
        ssh = {
          from        = 9090
          to          = 9090
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
      }
    }
  }
}