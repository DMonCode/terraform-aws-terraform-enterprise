### =================================================================== REQUIRED

variable "vpc_id" {
  type        = "string"
  description = "AWS VPC id to install into"
}

variable "prefix" {
  type        = "string"
  description = "Prefix for resource names"
}

### =================================================================== OPTIONAL

variable "subnet_compute" {
  type        = "list"
  description = "Subnets used by compute nodes"
}

variable "subnet_endpoints" {
  type        = "list"
  description = "Subnets used by endpoints"
}

variable "allow_list" {
  type        = "list"
  description = "list of CIDRs we allow to access the infrastructure"
  default     = []
}

variable "tags" {
  type        = "map"
  description = "Common tags"
}

### ======================================================================= MISC

resource "random_string" "install_id" {
  length  = 8
  special = false
  upper   = false
}
