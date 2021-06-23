#
# Create random password for BIG-IP
#
resource "random_string" "password" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  special     = false
}

#
# Create AWS Key Pair
#
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = format("%s-key-%s", var.prefix, random_id.id.hex)
  public_key = tls_private_key.example.public_key_openssh

  tags = {
    name        = format("%s-key-%s", var.prefix, random_id.id.hex)
    Terraform   = "true"
    Environment = "Demo"
  }
}

#
# Create BIG-IP
#
module "bigip" {
  source                 = "github.com/f5devcentral/terraform-aws-bigip-module"
  for_each               = var.bigip_instances
  prefix                 = format("%s-1nic", var.prefix)
  ec2_key_name           = aws_key_pair.generated_key.key_name
  f5_password            = random_string.password.result
  mgmt_subnet_ids        = [{ "subnet_id" = aws_subnet.mgmt.id, "public_ip" = true, "private_ip_primary" = "" }]
  mgmt_securitygroup_ids = [module.mgmt-network-security-group.security_group_id]
}
