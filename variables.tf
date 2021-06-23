variable "AllowedIPs" {
  description = "List of IP addresses allowed accessed to the BIG-IP"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "AWS Region (default is us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "azs" {
  description = "AWS Region Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "prefix" {
  description = "Prefix for resources created in AWS"
  type        = string
  default     = "tf-bigip-tunnel"
}

variable "vpc_cidr" {
  description = "AWS VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}
