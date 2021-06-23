#
# Create the VPC
#
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = format("%s-vpc-%s", var.prefix, random_id.id.hex)
  cidr                 = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = var.azs

  tags = {
    name        = format("%s-vpc-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "Demo"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    name        = format("%s-igw-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "Demo"
  }
}

resource "aws_route_table" "igw" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    name        = format("%s-igw-route-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "Demo"
  }
}

resource "aws_subnet" "mgmt" {
  vpc_id            = module.vpc.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = var.azs[0]

  tags = {
    name        = format("%s-mgmt-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "Demo"
  }
}

resource "aws_route_table_association" "rt_mgmt" {
  subnet_id      = aws_subnet.mgmt.id
  route_table_id = aws_route_table.igw.id
}

#
# Create a security group for BIG-IP Management
#
module "mgmt-network-security-group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-mgmt-nsg-%s", var.prefix, random_id.id.hex)
  description = "Security group for BIG-IP Management"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = concat([var.vpc_cidr], var.AllowedIPs)
  ingress_rules       = ["https-443-tcp", "https-8443-tcp", "ssh-tcp"]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    name        = format("%s-sg-mgmt-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "Demo"
  }

}
