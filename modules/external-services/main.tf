locals {
  namespace = "${var.prefix}tfe-${var.install_id}"
}

### =================================================================== REQUIRED

variable "vpc_id" {
  type        = "string"
  description = "AWS VPC id to install into"
}

variable "install_id" {
  type        = "string"
  description = "Identifier for installation"
}

### =================================================================== OPTIONAL

variable "tags" {
  type = "map"
  description = "Common tags that are added to resouces"
  default = {}
}

variable "prefix" {
  type        = "string"
  description = "string to prefix all resources with "
  default     = ""
}

variable "rds_subnet_ids" {
  type = "list"
  description = "List of subnet IDs that RDS will deploy to."
}

variable "access_subnet_ids" {
  type = "list"
  description = "List of subnet IDs that can access RDS"
}

variable "database_name" {
  type        = "string"
  description = "name of the initial database"
  default     = "tfe"
}

variable "database_username" {
  type        = "string"
  description = "username of the initial user"
  default     = "tfe"
}
