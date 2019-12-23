module "common" {
  source            = "./modules/common-user-vpc"
  vpc_id            = "${var.vpc_id}"
  subnet_tags       = "${var.subnet_tags}"
  subnets_compute   = "${var.subnets_compute}"
  subnets_endpoints = "${var.subnets_endpoints}"
  allow_list        = "${var.allow_list}"
  prefix            = "${var.prefix}"
}
