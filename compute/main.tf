data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "random_id" "server_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "server_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "prom-graf-server" {
  ami                    = data.aws_ami.ubuntu.id
  count                  = var.instance_count
  instance_type          = var.instance_type
  key_name               = aws_key_pair.server_auth.id
  vpc_security_group_ids = var.public_sg
  subnet_id              = var.public_subnet[count.index]

  root_block_device {
    volume_size = var.vol_size
  }

}