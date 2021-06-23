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

resource "aws_network_interface" "ubuntu" {
  subnet_id       = aws_subnet.mgmt.id
  security_groups = [module.mgmt-network-security-group.security_group_id]
  #   private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_eip" "ubuntu" {
  vpc               = true
  network_interface = aws_network_interface.ubuntu.id
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.generated_key.key_name

  network_interface {
    network_interface_id = aws_network_interface.ubuntu.id
    device_index         = 0
  }

  tags = {
    name        = format("%s-ubuntu-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "Demo"
  }
}
